defmodule LSPCodegen.EnumerationType do
  use TypedStruct

  typedstruct do
    field :kind, :atom, default: :base, enforce: true
    field :name, :string | :integer | :uinteger, enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :base,
      name: type.name
    }
  end
end
