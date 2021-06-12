defmodule Mix.Tasks.GenerateTokenizerTests do
  @moduledoc """
  It generates tests based on test files from WHATWG.

  This task will take a look at tokenizer test files
  that are located in "./test/html5lib-tests/tokenizer"
  and generate modules to run those tests.

  This is necessary every time the specs of HTML change,
  so we can keep up to date and also we can keep track
  of what changed.
  """

  @shortdoc "Generate tokenizer tests based on specs."

  @base_path "test/html5lib-tests/tokenizer"
  @html5lib_revision_path ".git/modules/test/html5lib-tests/HEAD"
  @template_path "priv/tokenizer_test_template.ex.eex"
  @destination_path "test/floki/html/generated/tokenizer"

  use Mix.Task

  @impl Mix.Task
  def run([filename | _]) do
    Mix.shell().info("generating #{filename}...")

    {:ok, content} = File.read(Path.join([@base_path, filename]))
    {:ok, json} = Jason.decode(content)

    identity_fun = fn %{"description" => desc} -> desc end
    revision = File.read!(@html5lib_revision_path)

    tests =
      Map.fetch!(json, "tests")
      |> Enum.filter(fn %{"description" => desc} ->
        is_binary(desc) && desc != ""
      end)
      |> Enum.uniq_by(identity_fun)
      |> Enum.sort_by(identity_fun)

    basename = String.split(filename, ".") |> List.first()

    if length(tests) <= 100 do
      save_tests(basename, filename, tests, revision)
    else
      tests
      |> Enum.chunk_every(100)
      |> Enum.with_index(1)
      |> Enum.each(fn {tests_group, idx} ->
        save_tests(basename <> "_part#{idx}", filename, tests_group, revision)
      end)
    end
  end

  defp save_tests(basename, filename, tests, revision) do
    test_name =
      basename
      |> String.split("_")
      |> Enum.map_join(&String.capitalize(&1))

    destination_path = Path.join([@destination_path, basename <> "_test.exs"])

    contents =
      @template_path
      |> EEx.eval_file(
        tests: tests,
        test_name: test_name,
        test_file: filename,
        revision: revision
      )
      |> Code.format_string!()

    Mix.shell().info(contents)

    File.write!(destination_path, contents)

    Mix.shell().info("saved in #{destination_path}.")
  end
end
