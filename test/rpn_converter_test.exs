defmodule RPNConverterTest do
  use ExUnit.Case
  doctest RPNConverter

  test "convert" do
    assert Enum.join(RPNConverter.convert("3+4"), " ") == "3 4 +"
    assert Enum.join(RPNConverter.convert("3.5+4.2"), " ") == "3.5 4.2 +"
    assert Enum.join(RPNConverter.convert("404+50/2*3+2^16"), " ") == "404 50 2 / 3 * + 2 16 ^ +"
    assert Enum.join(RPNConverter.convert("0-2"), " ") == "0 2 -"
    assert Enum.join(RPNConverter.convert("(3+4)*2"), " ") == "3 4 + 2 *"
    assert Enum.join(RPNConverter.convert("(3+4)*2+3/(5-2)^2"), " ") == "3 4 + 2 * 3 5 2 - 2 ^ / +"
    assert Enum.join(RPNConverter.convert("10+(50-20)"), " ") == "10 50 20 - +"
    assert Enum.join(RPNConverter.convert("10+50-20"), " ") == "10 50 + 20 -"
    assert Enum.join(RPNConverter.convert("((3+1)*2)^2"), " ") == "3 1 + 2 * 2 ^"
  end
end
