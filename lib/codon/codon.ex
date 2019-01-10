defmodule AntFarm.Codon do
  alias AntFarm.Utils

  @callback new(Keyword.t()) :: any()
  @callback mutate(any(), Utils.frequency()) :: any()
  @callback execute(any(), any()) :: any()

  @spec execute(%{__struct__: atom()}, any()) :: any()
  def execute(%module{} = item, modifier) do
    module.execute(item, modifier)
  end

  @spec mutate(struct(), Utils.frequency()) :: any()
  def mutate(%module{} = item, freq) do
    module.mutate(item, freq)
  end
end
