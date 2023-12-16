defmodule FileParser do
  @doc """
  Reads the contents of the file and returns a list of strings.
  """
  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.trim()
        |> String.split(~r/\R/, trim: true)

      {:error, reason} ->
        IO.puts("Failed to read the file: #{reason}")
        []
    end
  end
end

defmodule Helper do
  def double_n_times(0), do: 0
  def double_n_times(1), do: 1

  def double_n_times(times) when times > 0 do
    2 * double_n_times(times - 1)
  end
end

# Read the contents of the input.txt file
file_path = "day_4/advent_4.txt"

inputs = FileParser.read_file(file_path)

# IO.inspect(inputs)

# split the string into three parts seperated by : or |
# Split again on spaces
# iterate through the list the right side list to reduce a number

inputs
|> Enum.map(fn card ->
  [first, second] =
    String.split(card, ~r{;|:|\|}, trim: true)
    |> Enum.take(-2)
    |> Enum.map(fn parts ->
      String.split(parts, " ", trim: true)
    end)

  second
  |> Enum.filter(fn pos -> Enum.member?(first, pos) end)
  |> length()
  # |> IO.inspect()
  |> Helper.double_n_times()
end)
|> Enum.sum()
|> IO.inspect()
