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
    def to_string(type, metamodel) do
      "{#{Enum.map_join(type.items, ", ", &LSPCodegen.Codegen.to_string(&1, metamodel))}}"
    end
  end

  defimpl LSPCodegen.Schematic do
    def to_string(type, metamodel) do
      ~s|tuple([#{Enum.map_join(type.items, ", ", &LSPCodegen.Schematic.to_string(&1, metamodel))}], from: :list)|
    end
  end
end
