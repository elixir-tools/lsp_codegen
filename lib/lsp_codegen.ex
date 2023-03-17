defmodule LSPCodegen do
  def generate(argv) when is_list(argv) do
    {opts, _} = OptionParser.parse!(argv, strict: [path: :string])
    path = opts[:path]

    File.rm_rf!(path)
    File.mkdir_p!(path)

    %LSPCodegen.MetaModel{} =
      metamodel =
      File.read!("./metaModel.json")
      |> Jason.decode!(keys: :atoms)
      |> LSPCodegen.MetaModel.new()

    for mod <-
          metamodel.structures ++
            metamodel.requests ++
            metamodel.notifications ++ metamodel.enumerations ++ metamodel.type_aliases do
      source_code = LSPCodegen.Codegen.to_string(mod, metamodel)

      File.write!(
        Path.join(path, Macro.underscore(LSPCodegen.Naming.name(mod)) <> ".ex"),
        source_code
      )
    end
  end
end
