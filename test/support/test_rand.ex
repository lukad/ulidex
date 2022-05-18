defmodule Ulid.TestRand do
  @moduledoc false
  @spec bytes(pos_integer()) :: binary()
  def bytes(size) do
    bits = size * 8
    <<:rand.uniform(2 ** bits)::signed-size(bits)>>
  end
end
