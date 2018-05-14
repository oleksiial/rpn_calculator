defmodule Validator do
  def validate(input) do
    {state, stack} = loop(:start, transform(String.graphemes(input)), [0])
    (state == :number or state == :right or state == :float) and stack == [0]
  end

  defp transform(grapfemes) do
    Enum.map(grapfemes, fn g ->
      cond do
        g >= "0" and g <= "9" -> :number
        g == "-" -> :minus
        g == "+" or g == "*" or g == "/" or g == "^" -> :op
        g == "(" -> :left
        g == ")" -> :right
        g == "." -> :dot
      end
    end)
  end

  defp next_state(state, sym) do
    trasitisions_table = [
      start:  [op: :error,  number: :number,  left: :left,  right: :error,  dot: :error,  minus: :minus],
      number: [op: :op,     number: :number,  left: :error, right: :right,  dot: :dot,    minus: :op],
      op:     [op: :error,  number: :number,  left: :left,  right: :error,  dot: :error,  minus: :error],
      left:   [op: :error,  number: :number,  left: :left,  right: :error,  dot: :error,  minus: :minus],
      right:  [op: :op,     number: :error,   left: :error, right: :right,  dot: :error,  minus: :op],
      dot:    [op: :error,  number: :float,   left: :error, right: :error,  dot: :error,  minus: :error],
      float:  [op: :op,     number: :float,   left: :error, right: :right,  dot: :error,  minus: :op],
      minus:  [op: :error,  number: :number,  left: :left,  right: :error,  dot: :error,  minus: :error]
    ]
    trasitisions_table |> Keyword.get(state) |> Keyword.get(sym)
  end

  defp loop(:error, _, _), do: {:error, []}
  defp loop(q, [:left|[]], stack), do: {next_state(q, :left), [1 | stack]}
  defp loop(q, [:left|t], stack), do: loop(next_state(q, :left), t, [1 | stack])
  defp loop(q, [:right|[]], [_|stack]), do: {next_state(q, :right), stack}
  defp loop(q, [:right|t], [_|stack]), do: loop(next_state(q, :right), t, stack)
  defp loop(q, [h|[]], stack), do: { next_state(q, h), stack}
  defp loop(q, [h|t], stack), do: loop(next_state(q, h), t, stack)
end
