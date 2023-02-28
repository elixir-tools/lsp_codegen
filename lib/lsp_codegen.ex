defmodule LSPCodegen do
  def generate(_) do
    %LSPCodegen.MetaModel{structures: structures} =
      metamodel =
      File.read!("./metaModel.json")
      |> Jason.decode!(keys: :atoms)
      |> LSPCodegen.MetaModel.new()

    Enum.find(structures, fn s -> s.name == "SelectionRange" end) |> dbg

    for {%LSPCodegen.Structure{} = structure, idx} <- Enum.with_index(structures) do
      if idx == 22 do
        LSPCodegen.Codegen.to_string(structure, metamodel)
        |> IO.puts()
      end
    end
  end
end
