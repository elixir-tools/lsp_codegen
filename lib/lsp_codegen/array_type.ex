defmodule LSPCodegen.ArrayType do
  @moduledoc """
  Represents an array type (e.g. `TextDocument[]`).
  """

  use TypedStruct

  alias LSPCodegen.Type

  typedstruct do
    field :kind, :array, default: :array, enforce: true
    field :element, Type, enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :array,
      element: Type.new(type.element)
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(%{element: type}, metamodel) do
      # dbg(type)
      "list(#{LSPCodegen.Codegen.to_string(type, metamodel)})"
    end
  end
end
