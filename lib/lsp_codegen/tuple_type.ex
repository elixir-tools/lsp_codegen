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

  defimpl LSPCodegen.Codegen do
    def to_string(_type, _metamodel) do
      "list()"
    end
  end

  defimpl LSPCodegen.Schematic do
    def to_string(type, _metamodel) do
      ~s|all([list(), func(& length(&1) == #{length(type.items)})])|
    end
  end
end
