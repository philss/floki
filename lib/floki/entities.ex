defmodule Floki.Entities do
  def load_entities(file_name) do
    with {:ok, content} <- File.read(file_name),
         {:ok, json} <- Jason.decode(content) do
      json
    end
  end
end
