defmodule AntFarm.Mutable do
  alias AntFarm.Mutable

  defstruct value: nil,
            function: nil

  def new(value, function) when is_function(function, 2) do
    %Mutable{value: value, function: function}
  end

  def mutate(%Mutable{value: value, function: function} = m, modifier) do
    %Mutable{m | value: function.(value, modifier)}
  end
end
