defmodule LSPCodegen.Notification do
  @moduledoc """
  Represents a LSP notification
  """

  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :method, String.t(), enforce: true
    field :params, Type.t() | list(Type.t())
    field :proposed, boolean()
    field :registration_options, Type.t()
    field :since, String.t()
  end

  def new(notification) do
    params =
      case notification[:params] do
        params when is_list(params) -> for(p <- params, do: Type.new(p))
        params -> Type.new(params)
      end

    %__MODULE__{
      method: notification.method,
      documentation: notification[:documentation],
      params: params,
      proposed: notification[:proposed],
      registration_options: Type.new(notification[:registrationOptions]),
      since: notification[:since]
    }
  end

  defimpl LSPCodegen.Codegen do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "notification.ex.eex")

    def to_string(notification, metamodel) do
      render(%{
        notification: notification,
        params: notification.params,
        metamodel: metamodel
      })
    end

    def enforce(value) when value in [false, nil], do: ", enforce: true"
    def enforce(true), do: ""

    EEx.function_from_file(:defp, :render, @path, [:assigns])
  end

  defimpl LSPCodegen.Naming do
    def name(%{method: method}) do
      method
      |> String.replace("/", "_")
      |> String.replace("$", "Dollar")
      |> Macro.camelize()
    end
  end
end
