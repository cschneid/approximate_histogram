# ApproximateHistogram

An implementation of "Streaming Approximate Histograms" - based on a Go
implementation by VividCortex (https://github.com/VividCortex/gohistogram)

## Installation

```elixir
def deps do
  [{:approximate_histogram, "~> 0.1.0"}]
end
```

## Usage

```elixir
histo = ApproximateHistogram.new(50) # Optional max-size argument. Defaults to 50 bins.

filled_histo =
  histo |> ApproximateHistogram.add(10) |> ApproximateHistogram.add(20) |> ApproximateHistogram.add(15)

# A list of two-tuples, each having a value, and a count for that value.
# The length will never exceed the max-size argument.
list = ApproximateHistogram.to_list(filled_histo) # => [{10, 1}, {15, 1}, {20, 1}]

# What is the value for the 50th percentile?
ApproximateHistogram.percentile(filled_histo, 50) # => 15.0

# What is the percentile for the value 18?
ApproximateHistogram.percentile_for_value(filled_histo, 18) # => 66.66
```

