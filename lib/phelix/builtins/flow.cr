class Phelix
  defb "if" {
    a, c, v = get Fun, Fun, Val
    (v ? c : a).as(Fun).call s
  }

  defb "cond" {
    n = get Num
    arms = Array(Tuple(Fun, Fun)).new(n) { get Fun, Fun }
    arms.reverse_each do |fn, cond|
      break fn.call s if cond.call(s.dup).last
    end
  }

  defb "while" {
    body, test = get Fun, Fun
    while test.call(s).pop
      s.replace body.call(s)
    end
  }

  defb "until" {
    body, test = get Fun, Fun
    until test.call(s).pop
      s.replace body.call(s)
    end
  }

  defb "times" {
    n, body = get Num, Fun
    n.times { body.call s }
  }

  defb "each" {
    fn = get Fun
    get(Vec).each { |e| fn.call s << e }
  }

  defb "call" {
    get(Fun).call s
  }
end
