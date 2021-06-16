defmodule Hallux.Internal.OrderedInterval do
  defstruct [:interval, :value]

  alias Hallux.Internal.DateTimeInterval

  @type t(value) :: %__MODULE__{
    interval: DateTimeInterval.t(),
    value: value
  }

  defimpl Hallux.Protocol.Measured do
    alias Hallux.Internal.OrderedInterval

    def size(%OrderedInterval{interval: interval}) do
      interval
    end

    def monoid_type(%OrderedInterval{}) do
      DateTimeInterval.mempty()
    end
  end
end
