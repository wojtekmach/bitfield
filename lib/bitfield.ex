defmodule Bitfield do
  use Bitwise

  defmacro __using__(available) do
    field_type =
      quote unquote: false do
        unquote(Bitfield.__field_type__(@fields))
      end

    quote do
      normalized = Bitfield.__normalize__(unquote(available))
      length = length(normalized)

      if length == 0 do
        raise "must have at least one field"
      end

      defstruct value: 0

      @fields Keyword.keys(normalized)
      @first List.first(@fields)
      @available Map.new(normalized)

      @type t :: %__MODULE__{value: value}
      @type value :: non_neg_integer
      @type field :: unquote(field_type)

      available_fields_doc =
        Enum.map_join(@fields, "\n", fn field ->
          value =
            @available
            |> Map.fetch!(field)
            |> Integer.to_string(2)
            |> String.pad_leading(length, "0")

          " * `" <> inspect(field) <> "` (`0b#{value}`)"
        end)

      @moduledoc """
      #{inspect(__MODULE__)} bitfield.

      Available fields:
      #{available_fields_doc}
      """

      @spec new(value | [field]) :: t
      @doc """
      Returns a new `#{inspect(__MODULE__)}` bitfield.
      """
      def new(value_or_fields \\ 0) do
        value = Bitfield.__new__(@available, value_or_fields)
        %__MODULE__{value: value}
      end

      @spec fields(t) :: [field]
      @doc """
      Returns fields set on the given `bitfield`.
      """
      def fields(bitfield)

      def fields(%__MODULE__{value: value}) do
        Bitfield.__fields__(@available, @fields, value)
      end

      @spec has?(t, field) :: t
      @doc """
      Returns if `bitfield` has `field` set.
      """
      def has?(bitfield, field)

      @spec put(t, field) :: t
      @doc """
      Sets `field` on `bitfield`.
      """
      def put(bitfield, field)

      for {field, field_value} <- @available do
        @field field
        @field_value field_value

        def has?(%__MODULE__{value: value}, @field), do: (value &&& @field_value) == @field_value

        def put(%__MODULE__{value: value}, @field), do: %__MODULE__{value: value ||| @field_value}
      end

      defimpl Inspect do
        import Inspect.Algebra

        def inspect(struct, opts) do
          concat(["##{inspect(@for)}<", to_doc(@for.fields(struct), opts), ">"])
        end
      end
    end
  end

  @doc false
  def __normalize__(list) when is_list(list) do
    if Keyword.keyword?(list) do
      list
    else
      for {field, index} <- Enum.with_index(list) do
        {field, 1 <<< index}
      end
    end
  end

  @doc false
  def __field_type__([field1, field2]) do
    {:|, [], [field1, field2]}
  end

  def __field_type__([field | rest]) do
    {:|, [], [field, __field_type__(rest)]}
  end

  @doc false
  def __new__(_available, value) when is_integer(value) and value >= 0 do
    value
  end

  def __new__(available, fields) when is_list(fields) do
    Enum.reduce(fields, 0, &(&2 ||| Map.fetch!(available, &1)))
  end

  @doc false
  def __fields__(available, fields, value) do
    fields
    |> Enum.reduce([], fn field, acc ->
      field_value = Map.fetch!(available, field)

      if (value &&& field_value) == field_value do
        [field | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
  end
end
