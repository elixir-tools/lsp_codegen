File.rm_rf("lib/codegen")

defmodule StructureGenerator do
  def field(%LSPCodegen.Property{} = property) do
    [
      if(property.documentation,
        do: "# #{String.replace(property.documentation, "\n", " ")}\n",
        else: ""
      ),
      "field :#{property.name}, #{resolve_type(property.type)}#{enforce(property.optional)}\n\n"
    ]
    |> Enum.map(&("    " <> &1))
  end


end

for %LSPCodegen.Structure{
      documentation: documentation,
      extends: extends,
      mixins: mixins,
      name: name,
      properties: properties,
      proposed: proposed,
      since: since
    } = s <- structures do
  IO.inspect(properties)

  """
  defmodule GenLSP.Structures.#{name} do
    @moduledoc \"\"\"
    #{documentation}
    \"\"\"

    use TypedStruct

    typedstruct do
  #{for p <- properties do
    StructureGenerator.field(p)
  end}
    end
  end
  """
  |> IO.puts()
end
