defmodule UlidTest do
  @moduledoc false
  use Ulid.UlidCase
  doctest Ulid

  alias Ulid.Error.InvalidBinary
  alias Ulid.Error.InvalidUlidString

  describe "Ulid.encode/1" do
    test "encodes a binary ULID with Crockford 32" do
      assert Ulid.encode(<<0::128>>) == "00000000000000000000000000"
      assert Ulid.encode(<<7::3, 0::125>>) == "70000000000000000000000000"
      assert Ulid.encode(<<7::3, 0::125>>) == "70000000000000000000000000"
      assert Ulid.encode(<<1::128>>) == "00000000000000000000000001"
      assert Ulid.encode(<<31::128>>) == "0000000000000000000000000Z"
      assert Ulid.encode(<<32::128>>) == "00000000000000000000000010"

      assert Ulid.encode(<<0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF::128>>) ==
               "7ZZZZZZZZZZZZZZZZZZZZZZZZZ"
    end

    test "ensures that the input is a 128 bit binary" do
      assert_raise InvalidBinary, fn -> Ulid.encode(<<0::0>>) end
      assert_raise InvalidBinary, fn -> Ulid.encode(<<0::127>>) end
      assert_raise InvalidBinary, fn -> Ulid.encode(<<0::129>>) end
      assert_raise InvalidBinary, fn -> Ulid.encode(0) end
      assert_raise InvalidBinary, fn -> Ulid.encode(:invalid) end
      assert_raise InvalidBinary, fn -> Ulid.encode("invalid") end
    end
  end

  describe "Ulid.decode/1" do
    test "decodes the Crockford 32 encoded ULID" do
      assert Ulid.decode("7" <> String.duplicate("0", 25)) == <<224::8, 0::120>>
      assert Ulid.decode(String.duplicate("0", 25) <> "0") == <<0::123, 0::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "o") == <<0::123, 0::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "O") == <<0::123, 0::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "1") == <<0::123, 1::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "i") == <<0::123, 1::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "I") == <<0::123, 1::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "l") == <<0::123, 1::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "L") == <<0::123, 1::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "Z") == <<0::123, 31::5>>
      assert Ulid.decode(String.duplicate("0", 25) <> "z") == <<0::123, 31::5>>
    end

    test "ensures that the input is a 26 byte string" do
      assert_raise InvalidUlidString, fn -> Ulid.decode(String.duplicate("0", 27)) end
      assert_raise InvalidUlidString, fn -> Ulid.decode(String.duplicate("0", 25)) end
      assert_raise InvalidUlidString, fn -> Ulid.decode(<<0>>) end
    end
  end
end
