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

  def check_for_num(symbols, num_loc) do
    [row, col] = symbols
    numbers = process_num_loc(num_loc, row, col, [])
    if length(numbers) == 2, do: Enum.reduce(numbers, 1, &(&1 * &2)), else: 0
  end

  defp process_num_loc([], _row, _col, acc), do: Enum.uniq(acc)

  defp process_num_loc([parts | rest], row, col, acc) do
    updated_acc =
      Enum.reduce(parts, acc, fn part_number_list, acc_inner ->
        process_part_number_list(part_number_list, row, col, acc_inner)
      end)

    process_num_loc(rest, row, col, updated_acc)
  end

  defp process_part_number_list(part_number_list, row, col, acc) do
    Enum.reduce(part_number_list, acc, fn part_number, acc_inner ->
      [part_number_row, part_number_col, _] = part_number

      if abs(part_number_row - row) <= 1 && abs(part_number_col - col) <= 1 do
        parsed_part =
          part_number_list
          |> Enum.map(fn [_, _, part_num] -> part_num end)
          |> Enum.join()
          |> String.to_integer()

        acc_inner ++ [parsed_part]
      else
        acc_inner
      end
    end)
  end
end

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
  |> Enum.filter(&(&1 != []))

two_d_array
|> Enum.map(fn x ->
  Enum.map(x, fn y -> y end)
  |> Enum.reject(fn [_, _, m] -> m == "." || Regex.match?(~r/\d/, m) end)
  |> Enum.map(fn [x, y, _] -> [x, y] end)
end)
|> List.flatten()
|> Enum.chunk_every(2)
|> Enum.map(fn [x, y] ->
  [x, y]
end)
|> Enum.map(&Helper.check_for_num(&1, word_arrays))
|> Enum.sum()
|> IO.inspect()
