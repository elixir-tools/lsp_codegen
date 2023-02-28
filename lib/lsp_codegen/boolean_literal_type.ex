defmodule LSPCodegen.BooleanLiteralType do
  @moduledoc """
  Represents a boolean literal type (e.g. `kind: true`).
  """

  use TypedStruct

  typedstruct do
    field :kind, :boolean_literal, default: :boolean_literal, enforce: true
    field :value, boolean(), enforce: true
  end

  def new(type) do
    %__MODULE__{
      kind: :boolean_literal,
      value: type.value
    }
  end
end
