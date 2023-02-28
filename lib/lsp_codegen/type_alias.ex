defmodule LSPCodegen.TypeAlias do
  @moduledoc """
  Defines a type alias. (e.g. `type Definition = Location | LocationLink`)
  """

  use TypedStruct

  typedstruct do
    field :documentation, String.t()
    field :name, String.t(), enforce: true
    field :proposed, boolean()
    field :since, String.t()
    field :type, Type.t(), enforce: true
  end

  def new(type_alias) do
    %__MODULE__{
      documentation: type_alias[:documentation],
      name: type_alias.name,
      proposed: type_alias[:proposed],
      since: type_alias[:since],
      type: type_alias.type
    }
  end
end
