defmodule UlidTest do
  @moduledoc false
  use Ulidex.UlidCase
  doctest Ulidex

  alias Ulidex.Error.InvalidBinary
  alias Ulidex.Error.InvalidUlidString

  describe "Ulidex.encode/1" do
    test "encodes a binary ULID with Crockford 32" do
      assert Ulidex.encode(<<0::128>>) == "00000000000000000000000000"
      assert Ulidex.encode(<<7::3, 0::125>>) == "70000000000000000000000000"
      assert Ulidex.encode(<<7::3, 0::125>>) == "70000000000000000000000000"
      assert Ulidex.encode(<<1::128>>) == "00000000000000000000000001"
      assert Ulidex.encode(<<31::128>>) == "0000000000000000000000000Z"
      assert Ulidex.encode(<<32::128>>) == "00000000000000000000000010"

      assert Ulidex.encode(<<0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF::128>>) ==
               "7ZZZZZZZZZZZZZZZZZZZZZZZZZ"
    end

    test "ensures that the input is a 128 bit binary" do
      assert_raise InvalidBinary, fn -> Ulidex.encode(<<0::0>>) end
      assert_raise InvalidBinary, fn -> Ulidex.encode(<<0::127>>) end
      assert_raise InvalidBinary, fn -> Ulidex.encode(<<0::129>>) end
      assert_raise InvalidBinary, fn -> Ulidex.encode(0) end
      assert_raise InvalidBinary, fn -> Ulidex.encode(:invalid) end
      assert_raise InvalidBinary, fn -> Ulidex.encode("invalid") end
    end
  end

  describe "Ulidex.decode/1" do
    test "decodes the Crockford 32 encoded ULID" do
      assert Ulidex.decode("7" <> String.duplicate("0", 25)) == <<224::8, 0::120>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "0") == <<0::123, 0::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "o") == <<0::123, 0::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "O") == <<0::123, 0::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "1") == <<0::123, 1::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "i") == <<0::123, 1::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "I") == <<0::123, 1::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "l") == <<0::123, 1::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "L") == <<0::123, 1::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "Z") == <<0::123, 31::5>>
      assert Ulidex.decode(String.duplicate("0", 25) <> "z") == <<0::123, 31::5>>
    end

    test "ensures that the input is a 26 byte string" do
      assert_raise InvalidUlidString, fn -> Ulidex.decode(String.duplicate("0", 27)) end
      assert_raise InvalidUlidString, fn -> Ulidex.decode(String.duplicate("0", 25)) end
      assert_raise InvalidUlidString, fn -> Ulidex.decode(<<0>>) end
    end
  end
end
