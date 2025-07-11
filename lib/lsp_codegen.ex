defmodule LSPCodegen do
  require EEx

  alias LSPCodegen.{
    Enumeration,
    Notification,
    Request,
    Structure,
    TypeAlias
  }

  def generate(argv) when is_list(argv) do
    {opts, _} = OptionParser.parse!(argv, strict: [path: :string])
    path = opts[:path]

    File.rm_rf!(path)

    %LSPCodegen.MetaModel{} =
      metamodel =
      File.read!(Path.join(:code.priv_dir(:lsp_codegen), "metaModel.json"))
      |> Jason.decode!(keys: :atoms)
      |> LSPCodegen.MetaModel.new()

    for mod <-
          metamodel.structures ++
            metamodel.requests ++
            metamodel.notifications ++ metamodel.enumerations ++ metamodel.type_aliases do
      source_code = LSPCodegen.Codegen.to_string(mod, metamodel)

      path =
        case mod do
          %Enumeration{} -> Path.join(path, "enumerations")
          %Notification{} -> Path.join(path, "notifications")
          %Request{} -> Path.join(path, "requests")
          %Structure{} -> Path.join(path, "structures")
          %TypeAlias{} -> Path.join(path, "type_aliases")
        end

      File.mkdir_p!(path)

      File.write!(
        Path.join(path, Macro.underscore(LSPCodegen.Naming.name(mod)) <> ".ex"),
        source_code
      )
    end

    File.write!(Path.join(path, "requests.ex"), render_requests(%{requests: metamodel.requests}))

    File.write!(
      Path.join(path, "notifications.ex"),
      render_notifications(%{notifications: metamodel.notifications})
    )

    File.write!(Path.join(path, "base_types.ex"), render_base_types())
    File.write!(Path.join(path, "error_response.ex"), render_error())
  end

  EEx.function_from_string(
    :defp,
    :render_requests,
    """
    # codegen: do not edit
    defmodule GenLSP.Requests do
      import Schematic

      def new(request) do
        unify(oneof(fn
          <%= for r <- Enum.sort_by(@requests, & &1.method) do %>
            %{"method" => <%= inspect(r.method) %>} -> GenLSP.Requests.<%= LSPCodegen.Naming.name(r) %>.schema()
          <% end %>
            _ -> {:error, "unexpected request payload"}
        end), request)
      end
    end
    """,
    [:assigns]
  )

  EEx.function_from_string(
    :defp,
    :render_notifications,
    """
    # codegen: do not edit
    defmodule GenLSP.Notifications do
      import Schematic

      def new(notification) do
        unify(oneof(fn
          <%= for n <- Enum.sort_by(@notifications, & &1.method) do %>
            %{"method" => <%= inspect(n.method) %>} -> GenLSP.Notifications.<%= LSPCodegen.Naming.name(n) %>.schema()
          <% end %>
            _ -> {:error, "unexpected notification payload"}
        end), notification)
      end
    end
    """,
    [:assigns]
  )

  EEx.function_from_string(
    :defp,
    :render_base_types,
    """
    # codegen: do not edit
    defmodule GenLSP.BaseTypes do
      @type uri :: String.t()
      @type document_uri :: String.t()
      @type uinteger :: integer()
      @type null :: nil
    end
    """,
    []
  )

  EEx.function_from_string(
    :defp,
    :render_error,
    ~s'''
    # codegen: do not edit
    defmodule GenLSP.ErrorResponse do
      @moduledoc """
      A Response Message sent as a result of a request.

      If a request doesn’t provide a result value the receiver of a request still needs to return a response message to conform to the JSON-RPC specification.

      The result property of the ResponseMessage should be set to null in this case to signal a successful request.
      """
      import Schematic

      use TypedStruct

      typedstruct do
        field :data, String.t() | number() | boolean() | list() | map() | nil
        field :code, integer(), enforce: true
        field :message, String.t(), enforce: true
      end

      @spec schema() :: Schematic.t()
      def schema() do
        schema(__MODULE__, %{
          optional(:data) => oneof([str(), int(), bool(), list(), map(), nil]),
          code: int(),
          message: str(),
        })
      end
    end
    ''',
    []
  )
end
