defmodule Calculator do
  def calculate(input), do: print_result(input, Validator.validate(input))
  defp print_result(input, true), do: RPNConverter.convert(input) |> loop([])
  defp print_result(_input, false), do: "wrong input"

  defp loop([], [h|_]), do: h
  defp loop([h|t], stack) when is_number(h), do: loop(t, [h | stack])
  defp loop([h|t], stack) do
    {rhs, lhs, stack} = pop2(stack)
    loop(t, [evaluate(lhs, rhs, h) | stack])
  end

  defp pop2([h|[l|t]]), do: {h, l, t}
  defp evaluate(a, b, "+"), do: a + b
  defp evaluate(a, b, "-"), do: a - b
  defp evaluate(a, b, "*"), do: a * b
  defp evaluate(a, b, "/"), do: a / b
  defp evaluate(a, b, "^"), do: Kernel.trunc(:math.pow(a, b))
end
