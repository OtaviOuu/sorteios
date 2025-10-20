defmodule Sorteios.Prizes.Status do
  use Ash.Type.Enum, values: [:active, :paused, :inactive, :completed]
end
