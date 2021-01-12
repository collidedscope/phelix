class Phelix
  defb "if" {
    a, c, v = get Fun, Fun, Bool
    (v ? c : a).as(Fun).call s
  }

  defb "cond" {
    n = get Num
    arms = Array(Tuple(Fun, Fun)).new(n) { get Fun, Fun }
    arms.reverse_each do |fn, cond|
      break fn.call s if cond.call(s.dup).last
    end
    s
  }

  defb "while" {
    body, test = get Fun, Fun
    while test.call(s).pop
      s.replace body.call(s)
    end
    s
  }

  defb "until" {
    body, test = get Fun, Fun
    until test.call(s).pop
      s.replace body.call(s)
    end
    s
  }

  defb "times" {
    n, body = get Num, Fun
    n.times { body.call s }
    s
  }

  defb "call" {
    get(Fun).call s
  }
end
