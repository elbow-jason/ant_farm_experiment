defmodule AntFarmTest do
  use ExUnit.Case
  doctest AntFarm

  test "greets the world" do
    assert AntFarm.hello() == :world
  end
end
