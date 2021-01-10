class Phelix
  defb "if" {
    a, c, v = get Phelix, Phelix, Bool
    s.replace (v ? c : a).as(Phelix).evaluate(s)
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
end
