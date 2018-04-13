defmodule ValidatorTest do
  use ExUnit.Case
  doctest Validator

  test "validate" do
    assert Validator.validate("3+4")
    assert Validator.validate("3.2+4.4")
    assert Validator.validate("3+4*2")
    assert Validator.validate("((3+1)*2)^2")
    assert Validator.validate("((3+1)*2)/2")
    assert Validator.validate("(30-100)/2+35")
    assert Validator.validate("((30+105-(5+35))/5)^(4/2-2)")

    refute Validator.validate("3.2+4..4")
    refute Validator.validate("3.2+4.4.")
    refute Validator.validate(".+4.4")
    refute Validator.validate("3+4+")
    refute Validator.validate("+3+4")
    refute Validator.validate("((3+1)*2))/2")
    refute Validator.validate("((30-100)/2+35")
    refute Validator.validate("((30+105--(5+35))/5)^(4/2-2)")
  end
end
