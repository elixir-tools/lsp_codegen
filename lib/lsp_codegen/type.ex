defmodule LSPCodegen.Type do
  alias LSPCodegen.{
    BaseType,
    ReferenceType,
    ArrayType,
    MapType,
    AndType,
    OrType,
    TupleType,
    StructureLiteralType,
    StringLiteralType,
    IntegerLiteralType,
    BooleanLiteralType
  }

  @type t ::
          BaseType.t()
          | ReferenceType.t()
          | ArrayType.t()
          | MapType.t()
          | AndType.t()
          | OrType.t()
          | TupleType.t()
          | StructureLiteralType.t()
          | StringLiteralType.t()
          | IntegerLiteralType.t()
          | BooleanLiteralType.t()

  def new(nil), do: nil

  def new(%{kind: kind} = type) do
    case kind do
      "base" -> BaseType.new(type)
      "reference" -> ReferenceType.new(type)
      "array" -> ArrayType.new(type)
      "map" -> MapType.new(type)
      "and" -> AndType.new(type)
      "or" -> OrType.new(type)
      "tuple" -> TupleType.new(type)
      "literal" -> StructureLiteralType.new(type)
      "stringLiteral" -> StringLiteralType.new(type)
      "integerLiteral" -> IntegerLiteralType.new(type)
      "booleanLiteral" -> BooleanLiteralType.new(type)
    end
  end
end
