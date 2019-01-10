# AntFarm

A linear genetic algorithm experiment.


```elixir

iex(1)> 1..5 |> Enum.map(fn _ -> AntFarm.HelloWorld.run end)
# ... many IO.inspect/2 outputs
[
  ok: 'HELLOOWRLD',
  ok: 'HLLOWEORLD',
  ok: 'LLHOWEORLD',
  ok: 'HEOWLLORLD',
  ok: 'OHWELORLLD'
]
```