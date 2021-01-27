read_file = fn name ->
  __ENV__.file
  |> Path.dirname()
  |> Path.join(name)
  |> File.read!()
end

inputs = %{
  "big" => read_file.("big.html"),
  "medium" => read_file.("medium.html"),
  "small" => read_file.("small.html")
}

Benchee.run(
  %{
    "mochiweb" => fn input -> :floki_mochi_html.tokens(input) end,
    "floki" => fn input -> Floki.HTML.Tokenizer.tokenize(input) end
  },
  time: 10,
  inputs: inputs,
  memory_time: 2
)
