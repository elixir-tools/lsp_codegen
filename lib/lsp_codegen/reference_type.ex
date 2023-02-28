defmodule LSPCodegen.ReferenceType do
  @moduledoc """
  Represents a reference to another type (e.g. `TextDocument`). This is either a `Structure`, a `Enumeration` or a `TypeAlias` in the same meta model.
  """

  use TypedStruct

  typedstruct do
    field :kind, :reference, default: :reference, enforce: true
    field :name, String.t(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :reference,
      name: type.name
    }
  end

  defimpl LSPCodegen.Codegen do
    def to_string(%{name: name} = ref, metamodel) do
      "GenLSP.Structures.#{name}.t()"
    end
  end
end
