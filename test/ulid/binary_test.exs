defmodule Ulid.BinaryTest do
  @moduledoc false
  use Ulid.UlidCase, async: true
  doctest Ulid.Binary

  describe "Ulid.Binary.generate/1" do
    test "generates a 128 bit id" do
      assert <<_::size(128)>> = Ulid.Binary.generate()
    end
  end
end
