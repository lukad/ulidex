defmodule Ulid.Rand do
  @moduledoc false
  @spec bytes(non_neg_integer()) :: binary()
  def bytes(size), do: rand_bytes().(size)

  defp rand_bytes(), do: Application.fetch_env!(:ulid, :rand_bytes)
end
