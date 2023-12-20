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
  def increment_winning_copies(copies_map, []), do: copies_map

  def increment_winning_copies(copies_map, [id | remaining_ids]) do
    Map.update(copies_map, id, 1, fn previous -> previous + 1 end)
    |> increment_winning_copies(remaining_ids)
  end

  def format_id(id) do
    id
    |> String.trim()
    |> String.to_integer()
  end
end

defmodule CardProcessor do
  def process(cards) do
    processed_cards = process_cards(cards)
    dupe_cards = dupe_cards(processed_cards)
    total_cards = total_cards(cards)

    process(processed_cards, dupe_cards, total_cards)
  end

  def process(processed_cards, dupe_cards, total_cards) do
    Enum.reduce(processed_cards, dupe_cards, fn card, acc ->
      {id, winning_numbers, my_numbers} = card

      winners =
        my_numbers |> Enum.filter(fn pos -> Enum.member?(winning_numbers, pos) end) |> length()

      case winners do
        0 ->
          acc

        num_winners ->
          additional_copies = Map.get(acc, id)

          ids_to_increment =
            (id + 1)..min(id + num_winners, total_cards)
            |> Enum.to_list()
            |> List.duplicate(additional_copies + 1)
            |> List.flatten()

          Helper.increment_winning_copies(acc, ids_to_increment)
      end
    end)
    |> Enum.map(fn {key, value} -> {key, value + 1} end)
    |> Map.new()
  end

  defp process_cards(cards) do
    Enum.map(cards, fn card ->
      [card_id, winning_numbers, my_numbers] =
        String.split(card, ~r{card |;|:|\|}, trim: true)
        |> Enum.map(fn parts ->
          String.split(parts, " ", trim: true)
        end)

      id = List.last(card_id) |> Helper.format_id()

      {id, winning_numbers, my_numbers}
    end)
  end

  defp dupe_cards(processed_cards) do
    Enum.map(processed_cards, fn {id, _, _} -> {id, 0} end)
    |> Enum.into(%{})
  end

  defp total_cards(cards), do: length(cards)
end

# Read the contents of the input.txt file
file_path = "day_4/advent_4.txt"
cards = FileParser.read_file(file_path)

CardProcessor.process(cards)
|> Map.values()
|> Enum.sum()
|> IO.inspect()
