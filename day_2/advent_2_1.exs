defmodule Helper do
  def under_max?(list, max_blocks) do
    if length(list) > 2 do
      [first, second, third | _] = list
      number = String.to_integer(first <> second)

      number <= max_blocks[third]
    else
      [first, second | _] = list
      number = String.to_integer(first)

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

# Split the string into the game ID, and the three respective times
# Get the Game ID from the Array

#  Splice for the remaining three rounds
# In each round split by the "," and then get the color and number
#  Compare the number to the Max amount

max_blocks = %{"red" => 12, "green" => 13, "blue" => 14}

reg = ~r/(?=(\d|blue|red|green))/

inputs
|> Enum.map(fn input ->
  game_id =
    input
    |> String.split(~r{;|:}, trim: true)
    |> List.first()
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()

  # games
  games =
    input
    |> String.split(~r{;|:}, trim: true)
    |> Enum.slice(1..-1)
    |> Enum.map(fn round ->
      String.split(round, ",") |> List.flatten()
    end)
    |> List.flatten()

  list_of_games =
    games
    |> Enum.map(fn g ->
      Regex.scan(reg, g)
      |> List.flatten()
      |> Enum.filter(fn x -> x != "" end)
      |> Helper.under_max?(max_blocks)
    end)

  if Enum.all?(list_of_games), do: game_id
end)
|> Enum.reject(fn ele -> is_nil(ele) end)
|> Enum.sum()
|> IO.inspect()
