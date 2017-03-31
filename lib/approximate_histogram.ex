defmodule ApproximateHistogram do
  @type t :: %__MODULE__{
    bins: [bin],
    options: options
  }

  @type bin :: {value, count}
  @type value :: number()
  @type count :: non_neg_integer()

  @type options :: %{max_bins: pos_integer()}

  defstruct [
    :bins,
    :options,
  ]

  @default_size 50

  @spec new(pos_integer()) :: t
  def new(size \\ @default_size) do
    %__MODULE__{
      bins: [],
      options: %{max_bins: size},
    }
  end

  @spec size(t) :: non_neg_integer()
  def size(%__MODULE__{} = histo) do
    Enum.reduce(histo.bins, 0, fn {_, count}, total -> total + count end)
  end

  @spec max_bins(t) :: non_neg_integer()
  def max_bins(%__MODULE__{} = histo) do
    histo.options.max_bins
  end

  @spec add(t, value) :: t
  def add(%__MODULE__{} = histo, value) do
    if at_capacity?(histo) do
      # Split the list into:
      #   [before] | closest | [after]
      # Use a weighted average to merge the value and increment count correctly into a new middle bin
      {bef, closest, aft} = split(histo.bins, value)

      new_value =
        ((bin_value(closest) * bin_count(closest)) + value * 1) / (bin_count(closest) + 1)

      new_bin = {new_value, bin_count(closest) + 1}

      new_bins = bef ++ [new_bin] ++ aft
      %{histo | bins: new_bins}

    else
      # Split the list into:
      #   [before] | closest | [after]
      # Based on closest, come up with a 1 or 2 element list in the middle, then concat all 3 lists.
      #   [before] [closest, new] [after]   <-- value is bigger than the closest
      #   [before] [new, closest] [after]   <-- value is smaller than the closest
      #   [before] [new] [after]            <-- First element and identical value cases
      float_value = value / 1
      {bef, closest, aft} = split(histo.bins, float_value)

      middle = cond do
        closest == nil ->
          [{float_value, 1}]
        bin_value(closest) == float_value ->
          [{float_value, bin_count(closest) + 1}]
        bin_value(closest) < float_value ->
          [closest, {float_value, 1}]
        bin_value(closest) > float_value ->
          [{float_value, 1}, closest]
      end

      new_bins = bef ++ middle ++ aft
      %{histo | bins: new_bins}
    end
  end

  def bin_value({value, _}), do: value

  def bin_count({_, count}), do: count

  def bins_used(%__MODULE__{} = histo) do
    Enum.count(histo.bins)
  end

  @spec to_list(t) :: list(bin)
  def to_list(%__MODULE__{} = histo) do
    histo.bins
  end

  def percentile(%__MODULE__{} = histo, percentile) do
    target = size(histo) * (percentile / 100)
    Enum.reduce_while(
      histo.bins,
      target,
      fn {value, count}, remaining ->
        next = remaining - count
        if next <= 0 do
          {:halt, value}
        else
          {:cont, next}
        end
      end
    )
  end

  # Figure out which percentile this value would slot into
  def percentile_for_value(%__MODULE__{} = histo, target) do
    found_at = Enum.reduce_while(
      histo.bins,
      0,
      fn {bin_val, bin_count}, count ->
        if bin_val > target do
          {:halt, count}
        else
          {:cont, count + bin_count}
        end
      end
    )

    # Protect against div by 0
    s = size(histo)
    if s == 0 do
      0
    else
      found_at / size(histo) * 100
    end
  end

  @spec at_capacity?(t) :: boolean()
  defp at_capacity?(%__MODULE__{} = histo) do
    histo.options.max_bins == Enum.count(histo.bins)
  end

  # returns three-tuple: {[before], closest, [after]}
  # before and after may be empty lists
  defp split(bins, value) do
    {bef, aft} = Enum.split_while(bins, fn {bin_val, _} -> value > bin_val end)

    bef_closest = List.last(bef)
    bef_rest = Enum.drop(bef, -1)

    aft_closest = List.first(aft)
    aft_rest = Enum.drop(aft, 1)


    cond do
      bef_closest == nil ->
        {[], aft_closest, aft_rest}

      aft_closest == nil ->
        {bef_rest, bef_closest, []}

      true ->
        dist_to_bef = value - bin_value(bef_closest)
        dist_to_aft = value - bin_value(aft_closest)

        if dist_to_bef < dist_to_aft do
          {bef_rest, bef_closest, aft}
        else
          {bef, aft_closest, aft_rest}
        end
    end
  end

end
