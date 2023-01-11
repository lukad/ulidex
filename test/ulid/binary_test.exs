defmodule Ulidex.BinaryTest do
  @moduledoc false
  use Ulidex.UlidCase, async: true
  doctest Ulidex.Binary

  describe "Ulidex.Binary.generate/1" do
    test "generates a 128 bit id" do
      assert <<_::size(128)>> = Ulidex.Binary.generate()
    end
  end
end
