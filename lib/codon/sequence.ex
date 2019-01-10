defmodule AntFarm.Codon.Sequence do
  alias AntFarm.{
    Codon,
    Codon.Sequence
  }

  @type t :: %__MODULE__{
          codons: list(any)
        }
  defstruct codons: [],
            mutator: nil

  @behaviour Codon

  defguard is_non_neg_integer(item) when is_integer(item) and item > 0

  @impl true
  @spec new(keyword()) :: Sequence.t()
  def new(opts) when is_list(opts) do
    %Sequence{codons: Keyword.get(opts, :codons, [])}
  end

  @impl true
  @spec mutate(Sequence.t(), any()) :: Sequence.t()
  def mutate(%Sequence{codons: codons} = sequence, modifier) do
    {updated, _} =
      codons
      |> Enum.reduce({[], modifier}, fn item, {acc_list, modifier_acc} ->
        case Codon.mutate(item, modifier_acc) do
          nil ->
            {acc_list, modifier_acc}

          {nil, new_modifier} ->
            {acc_list, new_modifier}

          {changed_items, new_modifier} when is_list(changed_items) ->
            {changed_items ++ acc_list, new_modifier}

          {%_{} = changed_item, new_modifier} ->
            {[changed_item | acc_list], new_modifier}

          %_{} = changed_item ->
            {[changed_item | acc_list], modifier_acc}
        end
      end)

    %Sequence{sequence | codons: Enum.reverse(updated)}
  end

  @impl true
  @spec execute(Sequence.t(), any()) :: list()
  def execute(%Sequence{codons: codons}, input) do
    Enum.reduce(codons, [], fn codon, acc -> [Codon.execute(codon, input) | acc] end)
  end
end
