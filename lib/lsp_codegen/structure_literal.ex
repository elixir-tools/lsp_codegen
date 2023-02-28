defmodule LSPCodegen.StructureLiteral do
  @moduledoc """
  Defines a unnamed structure of an object literal.
  """

  alias LSPCodegen.Property

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :properties, list(Property.t()), enforce: true
    field :proposed, boolean()
    field :since, String.t()
  end

  def new(type) do
    %__MODULE__{
      documentation: type[:documentation],
      properties: for(p <- type.properties, do: Property.new(p)),
      proposed: type[:proposed],
      since: type[:since]
    }
  end
end
