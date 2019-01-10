defmodule AntFarm.Codex do
  alias AntFarm.{
    Codex
  }

  @type t :: %Codex{tid: :ets.tid() | atom}

  defstruct tid: nil

  def new() do
    %Codex{
      tid: :ets.new(nil, [:set, read_concurrency: true])
    }
  end

  def put_rule(%Codex{tid: tid}, name, mutation, state) do
    true = :ets.insert(tid, {name, mutation, state})
    :ok
  end

  def fetch_rule(%Codex{tid: tid}, name) do
    case :ets.lookup(tid, name) do
      [{^name, mutation, state}] ->
        {:ok, mutation, state}

      [] ->
        :error
    end
  end
end
