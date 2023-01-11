defmodule Ulidex.UlidCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  setup do
    :rand.seed(:default, {1, 2, 3})
    :ok
  end
end
