class Phelix
  defb "s/in" {
    n, h = get String, String
    s << h.includes? n
  }

  defb "s/split" {
    d, t = get String, String
    o = [] of Value
    t.split(d).each { |v| o << v }
    s << o
  }

  defb "s/slice" {
    e, b, t = get Int32, Int32, String
    s << t[b..e]
  }

  defb "s/bytes" {
    t = get String
    s << t.bytes.map { |x| x.to_i32.as Value }
  }
end
