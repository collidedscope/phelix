class Phelix
  # vectorize the top N elements of the stack
  # [ e1 ... en N ] => [ [e1 ... en] ]
  dbi "->vec", Num do |n|
    arity n
    s << s.pop n.to_i
  end

  dbi "nth", Vec, Num do |v, n|
    if n >= v.size || n < -v.size
      raise "index #{n} out of bounds for nth"
    end
    s << v[n]
  end

  dbi "pop", Vec do |v|
    s << v.pop
  end

  dbi "\\", Vec do |v|
    v.each { |e| s << e }
  end

  # mapify the top 2N elements of the stack
  # [ k1 v1 ... kn vn N ] => [ {k1 v1 ... kn vn} ]
  dbi "->map", Num do |n|
    arity n * 2
    m = Map.new false
    n.times {
      k, v = s.pop 2
      m[k] = v
    }
    s << m
  end

  dbi "get", Map, Val do |m, k|
    begin
      s << m[k]
    rescue KeyError
      raise "no such key '#{k}' for get"
    end
  end

  dbi "put", Map, Val, Val do |m, k, v|
    m[k] = v
    s << m
  end

  dbi "invert", Map do |m|
    s << m.invert
  end

  dbi "merge", Map, Map do |a, b|
    s << a.merge b
  end

  dbi "<<", Vec, Val do |vec, v|
    s << (vec << v)
  end

  dbi ">>", Val, Vec do |v, vec|
    s << (vec << v)
  end

  dbi "in", Val, Str | Vec do |needle, haystack|
    s << case haystack
         when Str; haystack.includes? needle.as Str
         else haystack.includes? needle
         end
  end

  dbi "sort", Vec do |vec|
    tmp = Vec.new vec.size

    if vec.all? &.class.== Str
      vec.map(&.as Str).sort.each { |e| tmp << e }
    elsif vec.all? &.class.== Num
      vec.map(&.as Num).sort.each { |e| tmp << e }
    else
      raise "can't sort heterogeneous array"
    end

    s << tmp
  end

  dbi "map", Vec, Fun do |vec, fn|
    s << vec.map { |e| fn.call(s << e).pop.as Val }
  end

  dbi "select", Vec, Fun do |vec, fn|
    s << vec.select { |e| fn.call(s << e).pop.as Val }
  end

  dbi "reject", Vec, Fun do |vec, fn|
    s << vec.reject { |e| fn.call(s << e).pop.as Val }
  end

  dbi "maxby", Vec, Fun do |vec, fn|
    s << vec.max_by { |e| fn.call(s << e).pop.as Num }
  end

  dbi "zip", Vec, Vec do |a, b|
    raise "(zip) length mismatch" unless a.size == b.size

    tmp = Vec.new a.size
    a.zip(b) { |c, d| tmp << [c.as Val, d.as Val] }
    s << tmp
  end

  dbi "uniq", Vec do |v|
    s << v.to_set.map &.as Val
  end

  dbi "rev", Str | Vec do |val|
    s << val.reverse
  end

  dbi "v*", Vec, Num do |vec, n|
    tmp = Vec.new
    n.times { tmp.concat vec }
    s << tmp
  end
end
