# This benchmark compares the implementation of tokenizers
# from mochiweb and the brand new one from Floki.
# In order to run this, you first need to extract the
# HTML files using the "extract.sh" script:
#
#   ./extract.sh
#
# After that, you need to run like this:
#
#   mix run benchs/tokenizers.exs
#

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
  time: 20,
  inputs: inputs,
  memory_time: 4
)
