defmodule Ulid.Rand do
  @moduledoc false
  @rand_bytes Application.compile_env(:ulid, :rand_bytes)

  @spec bytes(non_neg_integer()) :: binary()
  def bytes(size), do: @rand_bytes.(size)
end
