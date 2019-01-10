defmodule AntFarm do
  @moduledoc """
  Documentation for AntFarm.
  """
  alias AntFarm.{
    Codon.Sequence,
    Codon.GenCodon
  }

  def new_int_sequence(count, func) when is_function(func, 0) and is_integer(count) do
    codons =
      Enum.map(1..count, fn _ ->
        GenCodon.new(value: func.(), value_mutator: fn _, _ -> func.() end)
      end)

    Sequence.new(codons: codons)
  end

  def output(%module{} = executable, input \\ nil) do
    module.execute(executable, input)
  end

  def mutate(%module{} = mutable, modifier) do
    module.mutate(mutable, modifier)
  end
end
