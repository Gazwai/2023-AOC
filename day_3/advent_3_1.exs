defmodule FileParser do
  case File.read(file_path) do
    {:ok, content} ->
      content
      |> String.split(~r/\R/, trim: true)
      |> Enum.map(&String.graphemes(&1))

    {:error, reason} ->
      IO.inspect("Failed to read the file: #{reason}")
  end
end

defmodule Helper do
end

# Read the contents of the input.txt file
file_path = "day_3/advent_3.txt"

inputs = FileParser.read_file(file_path)

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

word_arrays =
  Enum.with_index(inputs)
  |> Enum.map(fn {element, index} ->
    Enum.with_index(element)
    |> Enum.map(fn {e, i} ->
      [index, i, e]
    end)
    |> Enum.chunk_by(fn [_x, _y, value] -> Regex.match?(~r/\D/, value) end)
    |> Enum.filter(fn chunk ->
      Enum.any?(chunk, fn [_x, _y, value] -> Regex.match?(~r/\d/, value) end)
    end)
  end)

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
    x |> Enum.filter(fn [_, _, m] -> Regex.match?(~r/\d/, m) end)
  end)
  |> List.flatten()
  |> Enum.chunk_every(3)
