defmodule RPNConverter do
  def convert(input) do
    {res, stack} =
      input                         # "(42+3)/5"
      |> String.graphemes()         # ["(", "4", "2", "+", "3", ")", "/", "5"]
      |> Enum.chunk_by(fn c ->      # [["("], ["4", "2"], ["+"], ["3"], [")", "/"], ["5"]]
           is_operator(c) or c == "(" or c == ")"
         end)
      |> Enum.map(&Enum.join &1)    # ["(", "42", "+", "3", ")/", "5"]
      |> Enum.map(&parse &1)        # ["(", 42, "+", 3, [")", "/"], 5]
      |> List.flatten()             # ["(", 42, "+", 3, ")", "/", 5]
      |> input_loop([], [])
    (Enum.filter(res, fn c -> c != '|' end) |> Enum.reverse()) ++ stack
  end

  defp is_operator(c), do: String.contains?("+-*/^", c)
  defp parse(c) do
    case Integer.parse(c) do
      {n, ""} -> n
      _ -> case Float.parse(c)   do
        {n, ""} -> n
        _ -> String.graphemes(c)
      end
    end
  end

  defp process(h, res, stack) when is_number(h), do: {[h | res], stack}
  defp process(h, res, stack), do: stack_loop(stack, res, h)

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

  defp input_loop([h|[]], res, stack), do: process h, res, stack
  defp input_loop([h|t], res, stack) do
    {res, stack} = process h, res, stack
    input_loop t, res, stack
  end
end
