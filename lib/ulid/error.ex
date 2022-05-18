defmodule Ulid.Error do
  @moduledoc false

  defmodule InvalidBinary do
    defexception message: "Must be a 128 bit binary"
  end

  defmodule InvalidUlidString do
    defexception [:message]

    @impl true
    def exception(string) do
      %__MODULE__{message: "Invalid ULID string: #{inspect(string)}"}
    end
  end
end
