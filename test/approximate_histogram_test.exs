defmodule ApproximateHistogramTest do
  use ExUnit.Case, async: true
  alias ApproximateHistogram, as: Histo
  doctest ApproximateHistogram

  test "new creates a 0 sized histogram" do
    assert 0 == Histo.size(Histo.new())
  end

  test "new with a max size stores that max size" do
    assert 289 == Histo.max_bins(Histo.new(289))
  end

  test "adding a value when not at bin-capacity stores it exactly" do
    assert [{2, 1}, {10.5,1}] ==
      Histo.new()
      |> Histo.add(2)
      |> Histo.add(10.5)
      |> Histo.to_list
  end

  test "adding a value already present (exactly) increments the count" do
    assert [{2, 2}] ==
      Histo.new()
      |> Histo.add(2)
      |> Histo.add(2)
      |> Histo.to_list
  end

  test "adding to a full histogram merges with the closest existing bin" do
    assert [{2, 1}, {4,1}, {8,1}, {12,1}, {16.5, 2}] ==
      Histo.new(5)
      |> Histo.add(2)
      |> Histo.add(4)
      |> Histo.add(8)
      |> Histo.add(12)
      |> Histo.add(16)

      |> Histo.add(17) # Will hit capacity, then merge w/ the 16
      |> Histo.to_list
  end

  test "adding to a full histogram doesn't increase bin count" do
    assert 5 ==
      Histo.new(5)
      |> Histo.add(2)
      |> Histo.add(4)
      |> Histo.add(8)
      |> Histo.add(12)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.bins_used
  end

  test "adding to a full histogram merges using a weighted average" do
    # Merged value for the 16s should be calculated like:
    16.25 = (16 + 16 + 16 + 17) / 4

    assert [{2, 1}, {4,1}, {8,1}, {12,1}, {16.25, 4}] ==
      Histo.new(5)
      |> Histo.add(2)
      |> Histo.add(4)
      |> Histo.add(8)
      |> Histo.add(12)
      |> Histo.add(16)
      |> Histo.add(16)
      |> Histo.add(16) # 3 16s.

      |> Histo.add(17) # Will hit capacity, then merge w/ the 16s.
      |> Histo.to_list
  end
end