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

tag =
  case System.cmd("git", ["describe", "--tags"]) do
    {reference, 0} ->
      String.trim_trailing(reference)

    {error, _other} ->
      IO.puts("cannot get human readable name from git: #{inspect(error)}")
      "unknown"
  end

IO.puts("tag in use for this benchmark is: #{tag}")

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
  save: [path: "benchs/results/tokenizers-#{tag}.benchee", tag: tag],
  memory_time: 2
)

results = Path.wildcard("benchs/results/tokenizers-*.benchee")

if Enum.count(results) > 1 and function_exported?(Benchee, :report, 1) do
  html_path = "benchs/results/tokenizers.html"

  Benchee.report(
    load: results,
    formatters: [
      Benchee.Formatters.Console,
      {Benchee.Formatters.HTML, file: html_path, auto_open: true}
    ]
  )

  IO.puts("open the HTML version in: #{html_path}")
end
