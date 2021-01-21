class Phelix
  defb "s/up" { arity 1
    s << get(Str).upcase
  }

  defb "s/dn" { arity 1
    s << get(Str).downcase
  }

  defb "s/split" { arity 2
    t, d = get Str, Str
    o = Vec.new
    t.split(d).each { |v| o << v }
    s << o
  }

  defb "s/slice" { arity 3
    t, b, e = get Str, Num, Num
    s << t[b..e]
  }

  defb "s/bytes" { arity 1
    s << get(Str).bytes.map &.to_big_i.as Val
  }

  defb "s/chars" { arity 1
    s << get(Str).chars.map &.to_s.as Val
  }

  defb "chr" { arity 1
    s << get(Num).to_i.chr.to_s
  }
end
