# LSPCodegen

Library to generate LSP protocol code for [gen_lsp](https://github.com/mhanberg/gen_lsp).

## Usage

```
elixir -e 'Mix.install([{:lsp_codegen, github: "mhanberg/lsp_codegen"}]); LSPCodegen.generate(System.argv())' -- --path ./path/for/files
```

