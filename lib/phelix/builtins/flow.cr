class Phelix
  defb "if" {
    a, c, v = get Phelix, Phelix, Bool
    s.replace (v ? c : a).as(Phelix).evaluate(s)
  }

  defb "until" {
    body, test = s.pop.as(Phelix), s.pop.as(Phelix)

    until test.evaluate(s).pop
      s.replace body.evaluate(s)
    end
  }
end
