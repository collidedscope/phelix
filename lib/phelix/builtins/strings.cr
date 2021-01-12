class Phelix
  defb "s/up" {
    s << get(Str).upcase
  }

  defb "s/dn" {
    s << get(Str).downcase
  }

  defb "s/split" {
    d, t = get Str, Str
    o = Vec.new
    t.split(d).each { |v| o << v }
    s << o
  }

  defb "s/slice" {
    e, b, t = get Num, Num, Str
    s << t[b..e]
  }

  defb "s/bytes" {
    s << get(Str).bytes.map &.to_big_i.as Val
  }

  defb "s/chars" {
    s << get(Str).chars.map &.to_s.as Val
  }
end
