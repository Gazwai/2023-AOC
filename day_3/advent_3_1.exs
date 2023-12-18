defmodule FileParser do
  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.trim()
        |> String.split(~r/\R/, trim: true)
        |> Enum.map(&String.graphemes(&1))

      {:error, reason} ->
        IO.puts("Failed to read the file: #{reason}")
        []
    end
  end
end

defmodule Helper do
  def check_for_symbols(row, col, symbol_loc) do
    symbol_loc
    |> Enum.any?(fn [sym_row, sym_col] ->
      abs(sym_row - row) <= 1 && abs(sym_col - col) <= 1
    end)
  end
end

# Read the contents of the input.txt file
file_path = "day_3/advent_3.txt"

inputs = FileParser.read_file(file_path)

two_d_array =
  Enum.with_index(inputs)
  |> Enum.map(fn {element, index} ->
    Enum.with_index(element)
    |> Enum.map(fn {e, i} ->
      [index, i, e]
    end)
  end)

symbol_loc =
  two_d_array
  |> Enum.map(fn x ->
    Enum.map(x, fn y -> y end)
    |> Enum.reject(fn [_, _, m] -> m == "." || Regex.match?(~r/\d/, m) end)
    |> Enum.map(fn [x, y, _] -> [x, y] end)
  end)
  |> List.flatten()
  |> Enum.chunk_every(2)

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
  |> Enum.map(fn x ->
    is_part? =
      Enum.any?(
        x,
        fn [row, col, _value] ->
          Helper.check_for_symbols(row, col, symbol_loc)
        end
      )

    if is_part? do
      Enum.map(x, fn [_, _, value] -> value end)
      |> Enum.join()
      |> String.to_integer()
    else
      0
    end
  end)
end)
|> List.flatten()
|> Enum.sum()
|> IO.inspect()
