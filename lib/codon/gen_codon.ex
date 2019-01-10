defmodule AntFarm.Codon.GenCodon do
  alias AntFarm.{
    Utils,
    Codon,
    Codon.GenCodon,
    Mutable
  }

  require Utils

  defstruct frequency: nil,
            value: nil

  @type t :: %GenCodon{
          frequency: float(),
          value: any()
        }
  @behaviour Codon

  @impl true
  def new(opts) when is_list(opts) do
    value = Keyword.fetch!(opts, :value)
    value_mutator = Keyword.fetch!(opts, :value_mutator)
    freq_mutator = frequency_mutator(opts)
    freq_value = frequency_value(opts)

    %GenCodon{
      value: Mutable.new(value, value_mutator),
      frequency: Mutable.new(freq_value, freq_mutator)
    }
  end

  @impl true
  def mutate(%GenCodon{frequency: freq_mut, value: value} = original, modifier)
      when is_float(modifier) do
    %Mutable{value: freq_value} = freq_mut

    modifier =
      modifier
      |> Utils.randomize_frequency(0.4)
      |> Utils.squash_frequency()

    if Utils.should_activate?(freq_value, modifier) do
      %GenCodon{
        value: Mutable.mutate(value, modifier),
        frequency: Mutable.mutate(freq_mut, modifier)
      }
    else
      %GenCodon{
        original
        | frequency: Mutable.mutate(freq_mut, modifier)
      }
    end
  end

  @impl true
  @spec execute(AntFarm.Codon.GenCodon.t(), any()) :: any()
  def execute(%GenCodon{value: %Mutable{value: value}}, _input) do
    value
  end

  defp frequency_value(opts),
    do: Keyword.get_lazy(opts, :frequency, fn -> Utils.random_frequency() end)

  defp frequency_mutator(opts) do
    case Keyword.get(opts, :frequency_mutator) do
      m when is_function(m, 2) -> m
      _ -> fn _, _ -> Utils.random_frequency() end
    end
  end
end
