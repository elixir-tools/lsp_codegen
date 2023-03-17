defmodule LSPCodegen.TypeKind do
  @type t ::
          :base
          | :reference
          | :array
          | :map
          | :and
          | :or
          | :tuple
          | :literal
          | :string_literal
          | :integer_literal
          | :boolean_literal
end
