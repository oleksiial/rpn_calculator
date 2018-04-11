defmodule RPNConverter do
  def convert(input) do
    {res, stack} = input_loop(String.graphemes(input), [], [])
    (Enum.filter(res, fn c -> c != '|' end) |> Enum.reverse()) ++ stack
  end

  defp process(h, res, stack) do
    case Integer.parse(h) do
      {n, ""} -> {replace_head(res, n), stack}
      :error -> stack_loop(stack, res, h)
    end
  end

  defp to_num("("), do: 0
  defp to_num("+"), do: 1
  defp to_num("-"), do: 1
  defp to_num("*"), do: 2
  defp to_num("/"), do: 2
  defp to_num("^"), do: 3

  defp stack_loop(stack, res, "("), do: {['|' | res], ["(" | stack]}
  defp stack_loop([], res, c), do: {['|' | res], [c]}
  defp stack_loop([h|t], res, ")") when h == "(", do: {res, t}
  defp stack_loop([h|t], res, ")"), do: stack_loop(t, [h | res], ")")
  defp stack_loop([h|t], res, c) do
    case (to_num(h) >= to_num(c)) do
      true -> stack_loop(t, [h | res], c)
      false -> {['|' | res], [c | [h | t]]}
    end
  end

  defp replace_head([], m), do: [m]
  defp replace_head([h|t], m) when (is_number(h) == false), do: [m | [h | t]]
  defp replace_head([h|t], m), do: [10 * h + m | t]

  defp input_loop([h|[]], res, stack), do: process h, res, stack
  defp input_loop([h|t], res, stack) do
    {res, stack} = process h, res, stack
    input_loop t, res, stack
  end
end
