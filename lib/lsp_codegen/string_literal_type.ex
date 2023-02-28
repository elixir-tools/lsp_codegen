defmodule LSPCodegen.StringLiteralType do
  @moduledoc """
  Represents a string literal type (e.g. `kind: 'rename'`).
  """

  use TypedStruct

  typedstruct enforce: true do
    field :kind, :string_literal, default: :string_literal
    field :value, String.t()
  end

  def new(type) do
    %__MODULE__{
      kind: :string_literal,
      value: type.value
    }
  end
end
