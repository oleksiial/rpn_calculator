defmodule RPNConverterTest do
  use ExUnit.Case
  doctest RPNConverter

  test "convert" do
    assert RPNConverter.convert("3+4") == [3, 4, "+"]
    assert RPNConverter.convert("3+(-4)") == [3, 0, 4, "-", "+"]
    assert RPNConverter.convert("-3+4") == [0, 3, "-", 4, "+"]
    assert RPNConverter.convert("3.5+4.2") == [3.5, 4.2, "+"]
    assert RPNConverter.convert("404+50/2*3+2^16") == [404, 50, 2, "/", 3, "*", "+", 2, 16, "^", "+"]
    assert RPNConverter.convert("0-2") == [0, 2, "-"]
    assert RPNConverter.convert("(3+4)*2") == [3, 4, "+", 2, "*"]
    assert RPNConverter.convert("(3+4)*2+3/(5-2)^2") == [3, 4, "+", 2, "*", 3, 5, 2, "-", 2, "^", "/", "+"]
    assert RPNConverter.convert("10+(50-20)") == [10, 50, 20, "-", "+"]
    assert RPNConverter.convert("10+50-20") == [10, 50, "+", 20, "-"]
    assert RPNConverter.convert("((3+1)*2)^2") == [3, 1, "+", 2, "*", 2, "^"]
  end
end
