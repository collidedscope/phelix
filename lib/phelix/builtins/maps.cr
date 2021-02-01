class Phelix
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
end
