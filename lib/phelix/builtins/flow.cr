class Phelix
  defb "if" {
    a, c, v = get Phelix, Phelix, Bool
    s.replace (v ? c : a).as(Phelix).evaluate(s)
  }

  defb "cond" {
    n = get BigInt
    arms = Array(Tuple(Phelix, Phelix)).new(n) { get Phelix, Phelix }
    arms.reverse_each do |fn, cond|
      break fn.evaluate s if cond.evaluate(s.dup).last
    end
  }

  defb "while" {
    body, test = get Phelix, Phelix
    while test.evaluate(s).pop
      s.replace body.evaluate(s)
    end
  }

  defb "until" {
    body, test = get Phelix, Phelix
    until test.evaluate(s).pop
      s.replace body.evaluate(s)
    end
  }

  defb "call" {
    get(Phelix).evaluate s
  }
end
