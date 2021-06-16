defmodule Hallux.Internal.DateTimeInterval do
  defstruct [
    # Yes, reversed.
    from: :pos_infinity,
    until: :neg_infinity
  ]

  @type t() :: %__MODULE__{
    from: DateTime.t() | :neg_infinity,
    until: DateTime.t() | :pos_infinity,
  }

  defimpl Hallux.Protocol.Monoid do
    alias Hallux.Internal.DateTimeInterval

    def mempty(_) do
      %DateTimeInterval{}
    end

    def mappend(dti1, dti2) do
      {from,  _} = sort_datetime(dti1.from , dti2.from)
      {_, until} = sort_datetime(dti1.until, dti2.until)
      %DateTimeInterval{
        from: from,
        until: until
      }
    end

    defp sort_datetime(:neg_infinity, datetime) do
      {:neg_infinity, datetime}
    end

    defp sort_datetime(:pos_infinity, datetime) do
      {datetime, :pos_infinity}
    end

    defp sort_datetime(datetime1 = %DateTime{}, datetime2 = %DateTime{}) do
      case DateTime.compare(datetime1, datetime2) do
        :lt -> {datetime1, datetime2}
        _ -> {datetime2, datetime1}
      end
    end

    defp sort_datetime(datetime1, datetime2) do
      sort_datetime(datetime2, datetime1)
    end
  end

  def before(interval1, interval2) do
    DateTime.compare(interval1.until, interval2.from) == :gt
  end
end
