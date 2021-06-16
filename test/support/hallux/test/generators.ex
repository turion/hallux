defmodule Hallux.Test.Generators do
  use ExUnitProperties

  alias Hallux.IntervalMap
  alias Hallux.Seq
  alias Hallux.Internal.DateTimeInterval

  def seq(generator \\ term()) do
    gen all(xs <- list_of(generator)) do
      Seq.new(xs)
    end
  end

  def interval_map() do
    gen all(
          is <- list_of(interval()),
          size = length(is),
          payloads <- list_of(term(), length: size)
        ) do
      is
      |> Stream.zip(payloads)
      |> Enum.reduce(IntervalMap.new(), &IntervalMap.insert(&2, &1))
    end
  end

  def interval() do
    gen all(bounds <- list_of(integer(), length: 2)) do
      [x, y] = Enum.sort(bounds)
      {x, y}
    end
  end

  def disjoint_intervals() do
    gen all(xs <- list_of(integer())) do
      xs
      |> Enum.sort()
      |> Enum.dedup()
      |> Stream.chunk_every(2, 2, :discard)
      |> Enum.map(fn [x, y] -> {x, y} end)
    end
  end

  def raw_datetime_interval() do
    gen all(bounds <- list_of(integer(), length: 2)) do
      [x, y] = Enum.sort(bounds)
      {DateTime.from_unix!(abs(x)), DateTime.from_unix!(abs(y))}
    end
  end

  def datetime_interval() do
    gen all({from, until} <- raw_datetime_interval()) do
      %DateTimeInterval{
        from: from,
        until: until
      }
    end
  end

  def ordered_interval_map() do
    gen all(
      intervals <- list_of(raw_datetime_interval()),
      values <- list_of(term(), length: length(intervals))
    ) do
      intervals
      |> Stream.zip(values)
      |> Enum.reduce(
        OrderedIntervalMap.new(),
        fn {{from, until}, value}, oim -> OrderedIntervalMap.insert(oim, {from, until}, value) end
      )
    end
  end
end
