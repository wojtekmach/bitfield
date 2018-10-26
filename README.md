# Bitfield

## Example

```elixir
defmodule Chmod do
  use Bitfield,
    r: 0b100,
    w: 0b010,
    x: 0b001
end

iex> Chmod.new([:r]).value
4
iex> Chmod.new([:w]).value
2
iex> Chmod.new([:r, :w, :x]).value
7
iex> Chmod.new(0b001)
#Chmod<[:x]>
iex> Chmod.new(0b111)
#Chmod<[:r, :w, :x]>
iex> Chmod.new([:w, :r]) |> Chmod.put(:x)
#Chmod<[:r, :w, :x]>
iex> Chmod.new([:w, :r]) |> Chmod.has?(:r)
true
iex> Chmod.new([:w, :r]) |> Chmod.has?(:x)
false
iex> Chmod.new([:w, :r]) |> Chmod.has?(:execute)
** (FunctionClauseError) no function clause matching in Chmod.has?/2

    The following arguments were given to Chmod.has?/2:

        # 1
        #Chmod<[:r, :w]>

        # 2
        :execute

    Attempted function clauses (showing 3 out of 3):

        def has?(%Chmod{value: value}, :r)
        def has?(%Chmod{value: value}, :w)
        def has?(%Chmod{value: value}, :x)
```

```
iex> h Chmod

Chmod bitfield.

Available fields:

  • :r (0b100)
  • :w (0b010)
  • :x (0b001)
```

```elixir
iex> t Chmod
@type field() :: :r | :w | :x

@type value() :: non_neg_integer()

@type t() :: %Chmod{value: value()}
```
