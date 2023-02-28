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
end
