defmodule LSPCodegen.Request do
  @moduledoc """
  Represents a LSP request
  """

  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :error_data, Type.t()
    field :method, String.t(), enforce: true
    field :params, Type.t() | list(Type.t())
    field :partial_result, Type.t()
    field :proposed, boolean()
    field :registration_options, Type.t()
    field :result, Type.t(), enforce: true
    field :since, String.t()
  end

  def new(request) do
    params =
      case request[:params] do
        params when is_list(params) -> for(p <- params, do: Type.new(p))
        params -> Type.new(params)
      end

    %__MODULE__{
      method: request.method,
      result: Type.new(request.result),
      documentation: request[:documentation],
      params: params,
      partial_result: Type.new(request[:partial_result]),
      proposed: request[:proposed],
      registration_options: Type.new(request[:registrationOptions]),
      since: request[:since]
    }
  end

  defimpl LSPCodegen.Codegen do
    require EEx
    @path Path.join(:code.priv_dir(:lsp_codegen), "request.ex.eex")

    def to_string(request, metamodel) do
      render(%{
        request: request,
        params: request.params,
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
      |> Macro.camelize()
    end
  end
end
