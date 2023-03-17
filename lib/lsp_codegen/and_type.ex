defmodule LSPCodegen.AndType do
  @moduledoc """
  Represents an `and`type (e.g. TextDocumentParams & WorkDoneProgressParams`).
  """

  use TypedStruct

  alias LSPCodegen.Type

  typedstruct do
    field :kind, :and, default: :and, enforce: true
    field :items, list(Type.t()), default: [], enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :and,
      items: for(i <- type.items, do: Type.new(i))
    }
  end
end
