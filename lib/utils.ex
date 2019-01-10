defmodule AntFarm.Utils do
  @type frequency :: float()

  def random(low..high), do: :rand.uniform(high - low) + low
  def random_frequency, do: :rand.uniform()

  defguard is_frequency(f) when is_float(f) and f >= 0.0 and f <= 1.0

  @spec should_activate?(float(), float()) :: boolean()
  def should_activate?(freq, error) when is_frequency(freq) and is_float(error) do
    random_frequency() * error >= freq
  end

  def squash_frequency(f) when not is_float(f),
    do: raise(ArgumentError, message: "AntFarm.Utils.squash_frequency requires a float")

  def squash_frequency(f) when f < 0.0, do: 0.01
  def squash_frequency(f) when f > 1.0, do: 0.99
  def squash_frequency(f) when f >= 0.0 and f <= 1.0, do: f

  def randomize_frequency(f, modifier) do
    if random_frequency() >= 0.5 do
      f + random_frequency() * modifier
    else
      f - random_frequency() * modifier
    end
  end

  def flip_frequency(f) do
    1 - squash_frequency(f)
  end
end
