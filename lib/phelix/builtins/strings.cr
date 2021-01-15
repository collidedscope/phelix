class Phelix
  defb "s/up" { arity 1
    s << get(Str).upcase
  }

  defb "s/dn" { arity 1
    s << get(Str).downcase
  }

  defb "s/split" { arity 2
    d, t = get Str, Str
    o = Vec.new
    t.split(d).each { |v| o << v }
    s << o
  }

  defb "s/slice" { arity 3
    e, b, t = get Num, Num, Str
    s << t[b..e]
  }

  defb "s/bytes" { arity 1
    s << get(Str).bytes.map &.to_big_i.as Val
  }

  defb "s/chars" { arity 1
    s << get(Str).chars.map &.to_s.as Val
  }
end
