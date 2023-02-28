defmodule LSPCodegen.MapKeyType do
  @moduledoc """
  Represents a type that can be used as a key in a map type. If a reference type is used then the type must either resolve to a `string` or `integer` type. (e.g. `type ChangeAnnotationIdentifier === string`).
  """
  defmodule BaseType do
    use TypedStruct

    typedstruct do
      field :kind, :base, default: :base, enforce: true
      field :name, :URI | :DocumentUri | :string | :integer, enforce: true
    end

    def new(type) do
      name =
        case type.name do
          "Uri" -> :Uri
          "DocumentUri" -> :DocumentUri
          "integer" -> :integer
          "string" -> :string
        end

      %__MODULE__{
        name: name,
        kind: :base
      }
    end
  end

  alias LSPCodegen.ReferenceType

  @type t :: __MODULE__.BaseType.t() | ReferenceType.t()

  def new(%{kind: kind} = type) do
    case kind do
      "base" -> __MODULE__.BaseType.new(type)
      "reference" -> ReferenceType.new(type)
    end
  end
end
