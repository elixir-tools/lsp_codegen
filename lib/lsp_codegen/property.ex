defmodule LSPCodegen.Property do
  @moduledoc """
  Represents an object property.
  """

  alias LSPCodegen.Type

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :name, String.t(), enforce: true
    field :optional, boolean()
    field :proposed, boolean()
    field :since, String.t()
    field :type, Type.t()
  end

  def new(type) do
    %__MODULE__{
      documentation: type[:documentation],
      name: type.name,
      optional: type[:optional],
      proposed: type[:proposed],
      since: type[:since],
      type: Type.new(type[:type])
    }
  end
end
