class Phelix
  # vectorize the top N elements of the stack
  # [ e1 ... en N ] => [ [e1 ... en] ]
  defb "[]" {
    n = get Num
    arity n
    s << s.pop n.to_i
  }

  defb "nth" { arity 2
    n, v = get Num, Vec
    s << v[n]
  }

  defb "pop" { arity 1
    s << peek(Vec).pop
  }

  defb "\\" { arity 1
    get(Vec).each { |e| s << e }
  }

  # mapify the top 2N elements of the stack
  # [ k1 v1 ... kn vn N ] => [ {k1 v1 ... kn vn} ]
  defb "{}" {
    m = Map.new false
    n = get Num
    arity n * 2
    n.times {
      k, v = s.pop 2
      m[k] = v
    }
    s << m
  }

  defb "get" { arity 2
    k, m = get Val, Map
    s << m[k]
  }

  defb "put" { arity 3
    v, k, m = get Val, Val, Map
    m[k] = v
    s << m
  }

  defb "invert" { arity 1
    s << get(Map).invert
  }

  defb "merge" { arity 2
    s << get(Map).merge get(Map)
  }

  defb "<<" { arity 2
    n, e = get Val, Vec
    s << (e.as(Vec) << n)
  }

  defb ">>" { arity 2
    e, n = get Vec, Val
    s << (e.as(Vec) << n)
  }

  defb "in" { arity 2
    haystack, needle = get Str | Vec, Val
    s << case haystack
         when Str; haystack.includes? needle.as Str
         else haystack.includes? needle
         end
  }

  defb "sort" { arity 1
    enu = get Vec
    tmp = Vec.new enu.size

    if enu.all? &.class.== Str
      enu.map(&.as Str).sort.each { |e| tmp << e }
    elsif enu.all? &.class.== Num
      enu.map(&.as Num).sort.each { |e| tmp << e }
    else
      abort "can't sort heterogeneous array"
    end

    s << tmp
  }

  defb "map" { arity 2
    fn, vec = get Fun, Vec
    s << vec.map { |e| fn.call([e]).last.as Val }
  }

  defb "select" { arity 2
    fn, vec = get Fun, Vec
    s << vec.select { |e| fn.call([e]).last.as Val }
  }

  defb "reject" { arity 2
    fn, vec = get Fun, Vec
    s << vec.reject { |e| fn.call([e]).last.as Val }
  }

  defb "maxby" { arity 2
    fn, enu = get Fun, Vec
    s << enu.max_by { |e| fn.call([e]).last.as Num }
  }

  defb "zip" { arity 2
    b, a = get Vec, Vec
    abort "(zip) length mismatch" unless a.size == b.size

    tmp = Vec.new a.size
    a.zip(b) { |c, d| tmp << [c.as Val, d.as Val] }
    s << tmp
  }

  defb "uniq" { arity 1
    s << get(Vec).to_set.map &.as Val
  }

  defb "v*" { arity 2
    n, v = get Num, Vec
    tmp = Vec.new
    n.times { tmp.concat v }
    s << tmp
  }
end
