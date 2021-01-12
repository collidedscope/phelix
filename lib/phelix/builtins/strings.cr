class Phelix
  defb "s/in" {
    n, h = get Str, Str
    s << h.includes? n
  }

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
    t = get Str
    s << t.bytes.map { |x| x.to_big_i.as Val }
  }
end
