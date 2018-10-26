defmodule BitfieldTest do
  use ExUnit.Case, async: true

  test "new" do
    assert Status.new().value == 0
    assert Status.new([:a, :c]).value == 0b101
    assert Status.new(0b101) == Status.new([:a, :c])

    assert_raise KeyError, fn ->
      Status.new([:a, :bad])
    end
  end

  test "fields/1" do
    assert Status.fields(Status.new()) == []
    assert Status.fields(Status.new([:a, :b])) == [:a, :b]
  end

  test "has?/2" do
    assert Status.has?(Status.new([:a, :b]), :a)
    assert Status.has?(Status.new([:a, :b]), :b)
    refute Status.has?(Status.new([:a, :b]), :c)

    assert_raise FunctionClauseError, fn ->
      Status.has?(Status.new(), :bad)
    end
  end

  test "put/2" do
    assert Status.put(Status.new([:a]), :b) == Status.new([:a, :b])

    assert_raise FunctionClauseError, fn ->
      Status.put(Status.new(), :bad)
    end
  end

  test "inspect" do
    assert inspect(Status.new([:a, :b])) == "#Status<[:a, :b]>"
  end

  test "define using atoms" do
    assert Atoms.new([:foo]).value == 0b0001
    assert Atoms.new([:bar]).value == 0b0010
    assert Atoms.new([:baz]).value == 0b0100
    assert Atoms.new([:qux]).value == 0b1000
  end
end
