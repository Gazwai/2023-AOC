defmodule FileParser do
  @doc """
  Reads the contents of the file and returns a list of strings.
  """
  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.trim()
        |> String.split(~r/,/, trim: true)

      {:error, reason} ->
        IO.puts("Failed to read the file: #{reason}")
        []
    end
  end
end

defmodule Helper do
  def to_ascii(string) when is_binary(string) do
    :binary.first(string)
  end

  def multiply(integer) when is_binary(integer) do
    String.to_integer(integer) |> multiply()
  end

  def multiply(integer) when is_integer(integer) do
    integer * 17
  end
end

# Read the contents of the input.txt file
file_path = "day_15/advent_15.txt"

inputs = FileParser.read_file(file_path)

Enum.reduce(inputs, 0, fn input, res ->
  num =
    String.split(input, "", trim: true)
    |> Enum.reduce(0, fn char, acc ->
      (acc + Helper.to_ascii(char)) |> Helper.multiply() |> rem(256)
    end)

  res + num
end)
|> IO.inspect(label: "input")
