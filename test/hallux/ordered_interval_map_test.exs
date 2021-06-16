defmodule Hallux.OrderedIntervalMapTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Hallux.OrderedIntervalMap
  alias Hallux.Protocol.Valid

  import Hallux.Test.Generators

  doctest OrderedIntervalMap, import: true

  describe "valid" do
    property "generator" do
      check all(oim <- ordered_interval_map()) do
        assert Valid.valid?(oim)
      end
    end

    property "merge" do
      check all(
        oim1 <- ordered_interval_map(),
        oim2 <- ordered_interval_map()
      ) do
        oim = OrderedIntervalMap.merge(oim1, oim2)
        assert Valid.valid?(oim)
      end
    end
  end

  describe "Monoid laws" do
    property "left unit" do
      check all(interval <- datetime_interval()) do
        DateTimeInterval.mappend(DateTimeInterval.mempty(), interval) == interval
      end
    end
  end
end
