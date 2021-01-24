class Phelix
  # vectorize the top N elements of the stack
  # [ e1 ... en N ] => [ [e1 ... en] ]
  defb "->vec" {
    n = get Num
    arity n
    s << s.pop n.to_i
  }

  defb "nth" { arity 2
    v, n = get Vec, Num
    if n >= v.size || n < -v.size
      raise "index #{n} out of bounds for nth"
    end
    s << v[n]
  }

  defb "pop" { arity 1
    s << get(Vec).pop
  }

  defb "\\" { arity 1
    get(Vec).each { |e| s << e }
  }

  # mapify the top 2N elements of the stack
  # [ k1 v1 ... kn vn N ] => [ {k1 v1 ... kn vn} ]
  defb "->map" {
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
    m, k = get Map, Val
    begin
      s << m[k]
    rescue KeyError
      raise "no such key '#{k}' for get"
    end
  }

  defb "put" { arity 3
    m, k, v = get Map, Val, Val
    m[k] = v
    s << m
  }

  defb "invert" { arity 1
    s << get(Map).invert
  }

  defb "merge" { arity 2
    a, b = get Map, Map
    s << a.merge b
  }

  defb "<<" { arity 2
    vec, v = get Vec, Val
    s << (vec << v)
  }

  defb ">>" { arity 2
    v, vec = get Val, Vec
    s << (vec << v)
  }

  defb "in" { arity 2
    needle, haystack = get Val, Str | Vec
    s << case haystack
         when Str; haystack.includes? needle.as Str
         else haystack.includes? needle
         end
  }

  defb "sort" { arity 1
    vec = get Vec
    tmp = Vec.new vec.size

    if vec.all? &.class.== Str
      vec.map(&.as Str).sort.each { |e| tmp << e }
    elsif vec.all? &.class.== Num
      vec.map(&.as Num).sort.each { |e| tmp << e }
    else
      raise "can't sort heterogeneous array"
    end

    s << tmp
  }

  defb "map" { arity 2
    vec, fn = get Vec, Fun
    s << vec.map { |e| fn.call(s << e).pop.as Val }
  }

  defb "select" { arity 2
    vec, fn = get Vec, Fun
    s << vec.select { |e| fn.call(s << e).pop.as Val }
  }

  defb "reject" { arity 2
    vec, fn = get Vec, Fun
    s << vec.reject { |e| fn.call(s << e).pop.as Val }
  }

  defb "maxby" { arity 2
    vec, fn = get Vec, Fun
    s << vec.max_by { |e| fn.call(s << e).pop.as Num }
  }

  defb "zip" { arity 2
    a, b = get Vec, Vec
    raise "(zip) length mismatch" unless a.size == b.size

    tmp = Vec.new a.size
    a.zip(b) { |c, d| tmp << [c.as Val, d.as Val] }
    s << tmp
  }

  defb "uniq" { arity 1
    s << get(Vec).to_set.map &.as Val
  }

  defb "rev" { arity 1
    s << get(Str | Vec).reverse
  }

  defb "v*" { arity 2
    vec, n = get Vec, Num
    tmp = Vec.new
    n.times { tmp.concat vec }
    s << tmp
  }
end
