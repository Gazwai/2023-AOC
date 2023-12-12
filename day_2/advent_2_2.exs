# defmodule Helper do
#   @doc """
#   Parses a string containing a number and a color and returns a tuple with the number (as integer) and the color.

#   ## Examples

#       iex> Helper.parse_number_and_color("12 red")
#       {12, "red"}
#   """
#   def parse_number_and_color(str) do
#     [num_str, color] = Regex.scan(~r/\d+|[a-z]+/, str) |> List.flatten()
#     {String.to_integer(num_str), color}
#   end

#   @doc """
#   Returns the maximum value for a specified color within a list of {number, color} tuples.

#   ## Examples

#       iex> Helper.max_color_value([{12, "red"}, {7, "blue"}, {10, "red"}], "red")
#       12
#   """
#   def max_color_value(game, color) do
#     game
#     |> Enum.filter(fn {_, c} -> c == color end)
#     |> Enum.map(&elem(&1, 0))
#     |> Enum.max()
#   end
# end

# defmodule GameProcessor do
#   alias Helper

#   @doc """
#   Processes game data from a file. Reads the file, splits the content into games, and processes each game.

#   ## Examples

#       iex> GameProcessor.process_game_data("path/to/file.txt")
#       Total Score: 123
#   """
#   def process_game_data(file_path) do
#     case File.read(file_path) do
#       {:ok, content} ->
#         process_content(content)

#       {:error, reason} ->
#         IO.inspect("Failed to read the file: #{reason}")
#     end
#   end

#   @doc false
#   defp process_content(content) do
#     content
#     |> String.trim()
#     |> String.split(~r/\R/)
#     |> Enum.map(&process_game/1)
#     |> Enum.sum()
#     |> IO.inspect(label: "Total Score")
#   end

#   @doc false
#   defp process_game(input) do
#     [game_data | rounds] = String.split(input, ~r{;|:})
#     game_id = extract_game_id(game_data)
#     max_blocks = %{"red" => 12, "green" => 13, "blue" => 14}

#     rounds
#     |> Enum.map(&String.split(&1, ","))
#     |> List.flatten()
#     |> Enum.map(&Helper.parse_number_and_color/1)
#     |> calculate_score()
#   end

#   @doc false
#   defp extract_game_id(game_data) do
#     game_data
#     |> String.split(" ")
#     |> List.last()
#     |> String.to_integer()
#   end

#   @doc false
#   defp calculate_score(game) do
#     colors = ["blue", "red", "green"]
#     Enum.reduce(colors, 1, fn color, acc ->
#       max_value = Helper.max_color_value(game, color)
#       acc * max_value
#     end)
#   end
# end

# # Example usage:
# GameProcessor.process_game_data("day_2/advent_2.txt")

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
    |> Integer.parse()
    |> elem(0)

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
