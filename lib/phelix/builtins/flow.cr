class Phelix
  defb "if" {
    a, c, v = get Fun, Fun, Bool
    (v ? c : a).as(Fun).evaluate s
  }

  defb "cond" {
    n = get Num
    arms = Array(Tuple(Fun, Fun)).new(n) { get Fun, Fun }
    arms.reverse_each do |fn, cond|
      break fn.evaluate s if cond.evaluate(s.dup).last
    end
  }

  defb "while" {
    body, test = get Fun, Fun
    while test.evaluate(s).pop
      s.replace body.evaluate(s)
    end
  }

  defb "until" {
    body, test = get Fun, Fun
    until test.evaluate(s).pop
      s.replace body.evaluate(s)
    end
  }

  defb "times" {
    n, body = get Num, Fun
    n.times { body.evaluate s }
  }

  defb "call" {
    get(Fun).evaluate s
  }
end
