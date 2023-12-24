defmodule Floki.EntitiesTest do
  use ExUnit.Case, async: true

  alias Floki.Entities

  describe "encode/1" do
    test "encode single-quote" do
      assert IO.iodata_to_binary(Entities.encode("'")) == "&#39;"
    end

    test "encode double-quote" do
      assert IO.iodata_to_binary(Entities.encode("\"")) == "&quot;"
    end

    test "ampersand" do
      assert IO.iodata_to_binary(Entities.encode("&")) == "&amp;"
    end

    test "encode less-than sign" do
      assert IO.iodata_to_binary(Entities.encode("<")) == "&lt;"
    end

    test "encode greater-than sign" do
      assert IO.iodata_to_binary(Entities.encode(">")) == "&gt;"
    end

    test "does not encode others" do
      assert Entities.encode("!") == "!"
      assert Entities.encode("?") == "?"
      assert Entities.encode("aaaa") == "aaaa"
    end
  end

  describe "decode/1" do
    test "decode all known entities" do
      {:ok, json} = Jason.decode(File.read!("priv/entities.json"))
      entities = Map.keys(json)

      for entity <- entities do
        assert {:ok, valid} = Entities.decode(entity)
        assert String.valid?(valid)
      end
    end

    test "decode some numeric references" do
      entities =
        ~w(&#x202B; &#1585; &#1602; &#1605; &#1575; &#1604; &#1607; &#1575; &#1578; &#1601; &#x202E;)

      for entity <- entities do
        assert {:ok, valid} = Entities.decode(entity)
        assert String.valid?(valid)
      end
    end

    test "returns not found for unknown entities" do
      assert {:error, :not_found} = Entities.decode("&pastel;")
      assert {:error, :not_found} = Entities.decode("&churrasco;")
      assert {:error, :not_found} = Entities.decode("&#-37;")
    end
  end
end
