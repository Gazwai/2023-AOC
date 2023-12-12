defmodule Helper do
end

# Read the contents of the input.txt file
file_path = "day_3/advent_3.txt"

inputs =
  case File.read(file_path) do
    {:ok, content} ->
      content
      |> String.split(~r/\R/, trim: true)
      |> Enum.map(&String.graphemes(&1))

    {:error, reason} ->
      IO.inspect("Failed to read the file: #{reason}")
  end

directions = [
  {-1, -1},
  {-1, 0},
  {-1, 1},
  {0, -1},
  {0, 1},
  {1, -1},
  {1, 0},
  {1, 1}
]

two_d_array =
  Enum.with_index(inputs)
  |> Enum.map(fn {element, index} ->
    Enum.with_index(element)
    |> Enum.map(fn {e, i} ->
      [index, i, e]
    end)
  end)
  |> IO.inspect()

symbol_loc =
  two_d_array
  |> Enum.map(fn x ->
    Enum.map(x, fn y -> y end)
    |> Enum.reject(fn [_, _, m] -> m == "." || Regex.match?(~r/\d/, m) end)
  end)
  |> List.flatten()
  |> Enum.chunk_every(3)

part_num_loc =
  two_d_array
  |> Enum.map(fn x ->
    Enum.map(x, fn y -> y end)
    |> Enum.filter(fn [_, _, m] -> Regex.match?(~r/\d/, m) end)
  end)
  |> List.flatten()
  |> Enum.chunk_every(3)
