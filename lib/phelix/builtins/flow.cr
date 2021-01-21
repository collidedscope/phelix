class Phelix
  defb "if" { arity 3
    v, yes, no = get Val, Fun, Fun
    (v ? yes : no).call s
  }

  defb "cond" { arity 1
    get(Vec).each_slice 2 do |arm|
      if arm[1]?
        cond, fn = arm.map &.as Fun
        break fn.call s if cond.call(s.dup).last
      else
        break arm[0].as(Fun).call s
      end
    end
  }

  defb "while" { arity 2
    test, body = get Fun, Fun
    while test.call(s).pop
      s.replace body.call(s)
    end
  }

  defb "until" { arity 2
    test, body = get Fun, Fun
    until test.call(s).pop
      s.replace body.call(s)
    end
  }

  defb "times" { arity 2
    fn, n = get Fun, Num
    n.times { fn.call s }
  }

  defb "each" { arity 2
    vec, fn = get Vec, Fun
    vec.each { |e| fn.call s << e }
  }

  defb "each/i" { arity 2
    vec, fn = get Vec, Fun
    vec.each_with_index { |e, i| fn.call s << i.to_big_i << e }
  }

  defb "call" { arity 1
    get(Fun).call s
  }

  defb "exit" {
    exit
  }
end
