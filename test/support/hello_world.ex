defmodule AntFarm.HelloWorld do
  alias AntFarm.{
    Codon.GenCodon,
    Codon.Sequence,
    Mutable,
    Utils
  }

  def letters_sequence do
    codons =
      AntFarm.new_int_sequence(10, fn -> :rand.uniform(?Z - ?A) + ?A end)
      |> Map.get(:codons)
      |> Enum.map(fn c ->
        %GenCodon{frequency: freq} = c
        new_freq_value = Utils.randomize_frequency(0.5, 0.2)
        new_freq = %Mutable{freq | value: new_freq_value}
        %GenCodon{c | frequency: new_freq}
      end)

    %Sequence{codons: codons}
  end

  def run(s1 \\ letters_sequence(), s2 \\ letters_sequence(), round \\ 0) do
    o1 = AntFarm.output(s1)
    o2 = AntFarm.output(s2)
    raw_e1 = error(o1)
    e1 = Utils.randomize_frequency(raw_e1, 0.0345)
    raw_e2 = error(o2)
    e2 = Utils.randomize_frequency(raw_e2, 0.0345)

    if rem(round, 100) == 0 do
      IO.inspect({o1, raw_e1, e1}, label: "a round #{round}")
      IO.inspect({o2, raw_e2, e2}, label: "b round #{round}")
    end

    cond do
      raw_e1 <= 0.04 ->
        {:ok, o1}

      raw_e2 <= 0.04 ->
        {:ok, o2}

      e1 >= e2 ->
        softener =
          e1
          |> Kernel.*(1.5)
          |> Utils.flip_frequency()

        err =
          e1
          |> Utils.randomize_frequency(softener)
          |> Utils.squash_frequency()

        run(AntFarm.mutate(s2, err), s2, round + 1)

      e1 < e2 ->
        softener =
          e1
          |> Kernel.*(1.5)
          |> Utils.flip_frequency()

        err =
          e2
          |> Utils.randomize_frequency(softener)
          |> Utils.squash_frequency()

        run(s1, AntFarm.mutate(s1, err), round + 1)
    end
  end

  def error(guess) do
    score =
      guess
      |> to_string()
      |> String.jaro_distance("HELLOWORLD")

    1 - score
  end
end
