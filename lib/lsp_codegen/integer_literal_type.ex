defmodule LSPCodegen.IntegerLiteralType do
  use TypedStruct

  typedstruct do
    field :kind, :integer_literal, default: :integer_literal, enforce: true
    field :value, number(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :integer_literal,
      value: type.value
    }
  end
end
