defmodule LSPCodegen.OrType do
  @moduledoc """
  Represents an `or` type (e.g. `Location | LocationLink`).
  """

  use TypedStruct

  alias LSPCodegen.Type

  typedstruct do
    field :kind, :or, default: :or, enforce: true
    field :items, list(Type.t()), default: [], enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :or,
      items: for(i <- type.items, do: Type.new(i))
    }
  end
end
