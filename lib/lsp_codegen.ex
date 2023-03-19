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
  end

  EEx.function_from_string(
    :defp,
    :render_requests,
    """
    defmodule GenLSP.Requests do
      import Schematic

      def new(request) do
        one_of([
          <%= for r <- Enum.sort_by(@requests, & &1.method) do %>
            GenLSP.Requests.<%= LSPCodegen.Naming.name(r) %>.schematic(),
          <% end %>
        ])
      end
    end
    """,
    [:assigns]
  )

  EEx.function_from_string(
    :defp,
    :render_notifications,
    """
    defmodule GenLSP.Notifications do
      import Schematic

      def new(request) do
        one_of([
          <%= for n <- Enum.sort_by(@notifications, & &1.method) do %>
            GenLSP.Notifications.<%= LSPCodegen.Naming.name(n) %>.schematic(),
          <% end %>
        ])
      end
    end
    """,
    [:assigns]
  )
end
