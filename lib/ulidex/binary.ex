defmodule Ulidex.Binary do
  @moduledoc """
  Generates binary ULIDs.
  """

  alias Ulidex.Rand

  @typedoc """
  A 128 bit ULID consisting of:
  * 48 bits millisecond timestamp
  * 80 bits of randomness
  """
  @type t() :: binary()

  @doc """
  Generates a binary ULID.

  ## Examples

      iex> ulid = Ulidex.Binary.generate()
      iex> <<_::size(128)>> = ulid

  """
  @spec generate(integer()) :: t()
  def generate(timestamp \\ System.system_time(:millisecond)) do
    <<timestamp::unsigned-size(48), Rand.bytes(10)::binary>>
  end
end
