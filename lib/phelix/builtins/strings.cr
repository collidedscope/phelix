class Phelix
  defb "s/in" {
    n, h = get String, String
    s << h.includes? n
  }

  defb "s/up" {
    s << get(String).upcase
  }

  defb "s/dn" {
    s << get(String).downcase
  }

  defb "s/split" {
    d, t = get String, String
    o = [] of Value
    t.split(d).each { |v| o << v }
    s << o
  }

  defb "s/slice" {
    e, b, t = get BigInt, BigInt, String
    s << t[b..e]
  }

  defb "s/bytes" {
    t = get String
    s << t.bytes.map { |x| x.to_big_i.as Value }
  }
end
