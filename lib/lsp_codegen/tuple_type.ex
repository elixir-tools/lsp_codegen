defmodule LSPCodegen.TupleType do
  @moduledoc """
  Represents a `tuple` type (e.g. `[integer, integer]`).
  """

  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :kind, :tuple, default: :tuple, enforce: true
    field :items, list(Type.t()), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :tuple,
      items: for(i <- type.items, do: Type.new(i))
    }
  end
end
