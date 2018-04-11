defmodule Calculator do
  def calculate(input) do
    if (Validator.validate(input)) do
      loop(RPNConverter.convert(input), [])
    end
  end

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
