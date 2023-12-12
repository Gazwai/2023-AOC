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

defmodule NumberConverter do
  @doc """
  Converts number words to their corresponding numeric strings otherwise returns the input.
  """
  def convert_word_to_num(word_or_num) do
    map_of_num = %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    Map.get(map_of_num, word_or_num, word_or_num)
  end
end

defmodule Main do
  import NumberConverter

  @doc """
  Processes each line to find the first and last number or number word,
  converts them to integers, and sums them.
  """
  def process_lines(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      {first, last} = extract_first_and_last_numbers(line)
      acc + String.to_integer(first <> last)
    end)
  end

  defp extract_first_and_last_numbers(line) do
    reg = ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/

    numbers =
      Regex.scan(reg, line)
      |> List.flatten()
      |> Enum.filter(fn x -> x != "" end)

    {List.first(numbers) |> convert_word_to_num(), List.last(numbers) |> convert_word_to_num()}
  end
end

# # Main script execution
file_path = "day_1/advent_1.txt"
inputs = FileParser.read_file(file_path)
result = Main.process_lines(inputs)
IO.inspect(result)
