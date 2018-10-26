# Bitfield

## Example

```elixir
defmodule Status do
  use Bitfield,
    a: 0b001,
    b: 0b010,
    c: 0b100
end

iex> Status.new([:a]).value
0b001
iex> Status.new([:b]).value
0b010
iex> Status.new([:a, :b]).value
0b011
iex> Status.new(0b011)
#Status<[:a, :b]>

iex> Status.put(Status.new([:a, :b]), :c)
#Status<[:a, :b, :c]>

iex> Status.has?(Status.new([:a, :b]), :a)
true
iex> Status.has?(Status.new([:a, :b]), :c)
false
iex> Status.has?(Status.new([:a, :b]), :bad)
** (FunctionClauseError) no function clause matching in Status.has?/2

    The following arguments were given to Status.has?/2:

        # 1
        #Status<[:a]>

        # 2
        :bad

    Attempted function clauses (showing 3 out of 3):

        def has?(%Status{value: value}, :a)
        def has?(%Status{value: value}, :b)
        def has?(%Status{value: value}, :c)
```

```
iex> h Status

Status bitfield.

Available fields:

  • :a (0b001)
  • :b (0b010)
  • :c (0b100)
```

```elixir
iex> t Status
@type field() :: :a | :b | :c

@type value() :: non_neg_integer()

@type t() :: %Status{value: value()}
```
