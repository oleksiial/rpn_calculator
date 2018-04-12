defmodule Validator do
  @trasitisions_table [
    start:    [operator: :error,    number: :number, left: :left,  right: :error],
    number:   [operator: :operator, number: :number, left: :error, right: :right],
    operator: [operator: :error,    number: :number, left: :left,  right: :error],
    left:     [operator: :error,    number: :number, left: :left,  right: :error],
    right:    [operator: :operator, number: :error,  left: :error, right: :right]
  ]

  def validate(input) do
    g = String.graphemes(input)
    if count_brackets(g, 0) != 0 do
      false
    else
      res = loop(:start, transform(g))
      res == :number or res == :right
    end
  end

  def do_count(h, count) do
    cond do
      h == "(" -> count + 1
      h == ")" -> count - 1
      true -> count
    end
  end

  def count_brackets([h|[]], count), do: do_count(h, count)
  def count_brackets([h|t], count), do: count_brackets(t, do_count(h, count))

  def transform(grapfemes) do
    Enum.map(grapfemes, fn g ->
      cond do
        g >= "0" and g <= "9" -> :number
        g == "+" or g == "-" or g == "*" or g == "/" or g == "^" -> :operator
        g == "(" -> :left
        g == ")" -> :right
      end
    end)
  end

  def loop(:error, _), do: :error
  def loop(q, [h|[]]), do: @trasitisions_table |> Keyword.get(q) |> Keyword.get(h)
  def loop(q, [h|t]), do: loop(@trasitisions_table |> Keyword.get(q) |> Keyword.get(h), t)
end
