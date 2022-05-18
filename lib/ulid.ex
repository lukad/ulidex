defmodule Ulid do
  @moduledoc """
  This is an implementation of the ULID (Universally Unique Lexicographically Sortable Identifier) spec.
  """

  alias Ulid.Binary

  @typedoc """
  A Crockford 32 encoded ULID.
  """
  @type t() :: String.t()

  @doc """
  Generates a Crockford 32 encoded ULID for the given timestamp which must be in milliseconds.

  If no timestamp is given it uses the current system time.

  ## Examples

      iex> ulid = Ulid.generate()
      iex> <<_::size(208)>> = ulid
  """
  @spec generate(integer()) :: binary()
  def generate(timestamp \\ System.system_time(:millisecond)) do
    timestamp
    |> Binary.generate()
    |> encode()
  end

  @doc """
  Takes a 128 bit binary ULID and returns a Crockford 32 encoded ULID.

  Raises `Ulid.Error.InvalidBinary` when the input is malformed.

  ## Examples
      iex> ulid = <<1, 128, 211, 67, 45, 254, 115, 142, 105, 252, 121, 217, 228, 222, 219, 155>>
      iex> Ulid.encode(ulid)
      "01G39M6BFYEE76KZ3SV7JDXPWV"
  """
  @spec encode(Binary.t()) :: t()
  def encode(ulid) when is_binary(ulid) and byte_size(ulid) == 16 do
    encoded =
      for <<(symbol::5 <- <<0::2, ulid::bitstring>>)>> do
        encode_symbol(symbol)
      end

    to_string(encoded)
  end

  def encode(_), do: raise(Ulid.Error.InvalidBinary, "Must be a 128 bit binary")

  @doc """
  Takes a Crockford 32 encoded ULID and returns a a 128 bit binary ULID.

  Raises `Ulid.Error.InvalidUlidString` when the input is malformed.

  ## Examples

      iex> ulid = "01G3C1TW8AKE19BYDDR6996C1D"
      iex> Ulid.decode(ulid)
      <<1, 128, 216, 29, 113, 10, 155, 130, 149, 249, 173, 193, 146, 147, 48, 45>>
  """
  @spec decode(t()) :: Binary.t()
  def decode(ulid) when is_binary(ulid) and byte_size(ulid) == 26 do
    decoded =
      ulid
      |> to_charlist()
      |> Enum.reduce(<<>>, fn el, acc ->
        <<acc::bitstring, decode_symbol(el)::5>>
      end)

    <<_padding::2, decoded::binary>> = decoded
    decoded
  end

  def decode(string), do: raise(Ulid.Error.InvalidUlidString, string)

  defp encode_symbol(0), do: ?0
  defp encode_symbol(1), do: ?1
  defp encode_symbol(2), do: ?2
  defp encode_symbol(3), do: ?3
  defp encode_symbol(4), do: ?4
  defp encode_symbol(5), do: ?5
  defp encode_symbol(6), do: ?6
  defp encode_symbol(7), do: ?7
  defp encode_symbol(8), do: ?8
  defp encode_symbol(9), do: ?9
  defp encode_symbol(10), do: ?A
  defp encode_symbol(11), do: ?B
  defp encode_symbol(12), do: ?C
  defp encode_symbol(13), do: ?D
  defp encode_symbol(14), do: ?E
  defp encode_symbol(15), do: ?F
  defp encode_symbol(16), do: ?G
  defp encode_symbol(17), do: ?H
  defp encode_symbol(18), do: ?J
  defp encode_symbol(19), do: ?K
  defp encode_symbol(20), do: ?M
  defp encode_symbol(21), do: ?N
  defp encode_symbol(22), do: ?P
  defp encode_symbol(23), do: ?Q
  defp encode_symbol(24), do: ?R
  defp encode_symbol(25), do: ?S
  defp encode_symbol(26), do: ?T
  defp encode_symbol(27), do: ?V
  defp encode_symbol(28), do: ?W
  defp encode_symbol(29), do: ?X
  defp encode_symbol(30), do: ?Y
  defp encode_symbol(31), do: ?Z

  defp decode_symbol(?0), do: 0
  defp decode_symbol(?o), do: 0
  defp decode_symbol(?O), do: 0
  defp decode_symbol(?1), do: 1
  defp decode_symbol(?I), do: 1
  defp decode_symbol(?i), do: 1
  defp decode_symbol(?L), do: 1
  defp decode_symbol(?l), do: 1
  defp decode_symbol(?2), do: 2
  defp decode_symbol(?3), do: 3
  defp decode_symbol(?4), do: 4
  defp decode_symbol(?5), do: 5
  defp decode_symbol(?6), do: 6
  defp decode_symbol(?7), do: 7
  defp decode_symbol(?8), do: 8
  defp decode_symbol(?9), do: 9
  defp decode_symbol(?A), do: 10
  defp decode_symbol(?a), do: 10
  defp decode_symbol(?B), do: 11
  defp decode_symbol(?b), do: 11
  defp decode_symbol(?C), do: 12
  defp decode_symbol(?c), do: 12
  defp decode_symbol(?D), do: 13
  defp decode_symbol(?d), do: 13
  defp decode_symbol(?E), do: 14
  defp decode_symbol(?e), do: 14
  defp decode_symbol(?F), do: 15
  defp decode_symbol(?f), do: 15
  defp decode_symbol(?G), do: 16
  defp decode_symbol(?g), do: 16
  defp decode_symbol(?H), do: 17
  defp decode_symbol(?h), do: 17
  defp decode_symbol(?J), do: 18
  defp decode_symbol(?j), do: 18
  defp decode_symbol(?K), do: 19
  defp decode_symbol(?k), do: 19
  defp decode_symbol(?M), do: 20
  defp decode_symbol(?m), do: 20
  defp decode_symbol(?N), do: 21
  defp decode_symbol(?n), do: 21
  defp decode_symbol(?P), do: 22
  defp decode_symbol(?p), do: 22
  defp decode_symbol(?Q), do: 23
  defp decode_symbol(?q), do: 23
  defp decode_symbol(?R), do: 24
  defp decode_symbol(?r), do: 24
  defp decode_symbol(?S), do: 25
  defp decode_symbol(?s), do: 25
  defp decode_symbol(?T), do: 26
  defp decode_symbol(?t), do: 26
  defp decode_symbol(?V), do: 27
  defp decode_symbol(?v), do: 27
  defp decode_symbol(?W), do: 28
  defp decode_symbol(?w), do: 28
  defp decode_symbol(?X), do: 29
  defp decode_symbol(?x), do: 29
  defp decode_symbol(?Y), do: 30
  defp decode_symbol(?y), do: 30
  defp decode_symbol(?Z), do: 31
  defp decode_symbol(?z), do: 31
end
