defmodule Helper do
  def under_max?(list, max_blocks) do
    if length(list) > 2 do
      [first, second, third | _] = list
      number = Integer.parse(first <> second) |> elem(0)

      number <= max_blocks[third]
    else
      [first, second | _] = list
      number = Integer.parse(first) |> elem(0)

      number <= max_blocks[second]
    end
  end
end

# Read the contents of the input.txt file
file_path = "day_2/advent_2.txt"

inputs =
  case File.read(file_path) do
    {:ok, content} ->
      content
      |> String.trim()
      |> String.split(~r/\R/, trim: true)

    {:error, reason} ->
      IO.inspect("Failed to read the file: #{reason}")
  end

reg = ~r/(?=(\d|blue|red|green))/

inputs
|> Enum.map(fn input ->
  games =
    input
    |> String.split(~r{;|:}, trim: true)
    |> Enum.slice(1..-1)
    |> Enum.map(fn round ->
      String.split(round, ",") |> List.flatten()
    end)
    |> List.flatten()

  game =
    games
    |> Enum.map(fn g ->
      Regex.scan(reg, g)
      |> List.flatten()
      |> Enum.filter(fn x -> x != "" end)
    end)

  blue =
    game
    |> Enum.map(fn g ->
      if length(g) > 2 do
        [first, second, color] = g
        number = Integer.parse(first <> second) |> elem(0)

        if color == "blue", do: number
      else
        [num, color] = g

        if color == "blue", do: Integer.parse(num) |> elem(0)
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.max()

  red =
    game
    |> Enum.map(fn g ->
      if length(g) > 2 do
        [first, second, color] = g
        number = Integer.parse(first <> second) |> elem(0)

        if color == "red", do: number
      else
        [num, color] = g

        if color == "red", do: Integer.parse(num) |> elem(0)
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.max()

  green =
    game
    |> Enum.map(fn g ->
      if length(g) > 2 do
        [first, second, color] = g
        number = Integer.parse(first <> second) |> elem(0)

        if color == "green", do: number
      else
        [num, color] = g

        if color == "green", do: Integer.parse(num) |> elem(0)
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.max()

  Enum.reduce([green, blue, red], 1, fn number, acc -> acc * number end)
end)
|> Enum.sum()
|> IO.inspect()
