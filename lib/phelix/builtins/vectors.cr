class Phelix
  # vectorize the top N elements of the stack
  # [ e1 ... en N ] => [ [e1 ... en] ]
  dbi "->vec", Num do |n|
    arity n
    s << s.pop n.to_i
  end

  dbi "pop", Vec do |v|
    s << v.pop
  end

  dbi "insert", Vec, Num, Val do |vec, i, v|
    s << vec.insert i, v
  end

  dbi "\\", Vec do |v|
    v.each { |e| s << e }
  end

  dbi "<<", Vec, Val do |vec, v|
    s << (vec << v)
  end

  dbi ">>", Val, Vec do |v, vec|
    s << (vec << v)
  end

  dbi "sort", Vec do |vec|
    tmp = Vec.new vec.size

    if vec.all? &.class.== Str
      vec.map(&.as Str).sort.each { |e| tmp << e }
    elsif vec.all? &.class.== Num
      vec.map(&.as Num).sort.each { |e| tmp << e }
    else
      raise "can't sort heterogeneous vector"
    end

    s << tmp
  end

  macro vecfun(name, body)
    dbi {{name}}, Vec, Fun do |vec, fn| {{body}} end
    dbi {{name}}, Fun, Vec do |fn, vec| {{body}} end
  end

  vecfun "map",    s << vec.map    { |e| fn.call(s << e).pop.as Val }
  vecfun "select", s << vec.select { |e| fn.call(s << e).pop }
  vecfun "reject", s << vec.reject { |e| fn.call(s << e).pop }
  vecfun "count",  s << vec.count  { |e| fn.call(s << e).pop }.to_big_i
  vecfun "maxby",  s << vec.max_by { |e| fn.call(s << e).pop.as Num }

  dbi "zip", Vec, Vec do |a, b|
    raise "(zip) length mismatch" unless a.size == b.size

    tmp = Vec.new a.size
    a.zip(b) { |c, d| tmp << [c.as Val, d.as Val] }
    s << tmp
  end

  dbi "uniq", Vec do |v|
    s << v.to_set.map &.as Val
  end

  dbi "v*", Vec, Num do |vec, n|
    tmp = Vec.new vec.size * n
    n.times { tmp.concat vec }
    s << tmp
  end

  dbi "/i", Vec do |vec|
    tmp = Vec.new vec.size
    vec.each_with_index { |e, i| tmp << [e, i.to_big_i.as Val] }
    s << tmp
  end

  dbi "-", Vec, Val do |vec, v|
    vec.delete v
  end

  dbi "choose", Vec do |v|
    s << v.sample
  end

  dbi "choose", Vec, Num do |v, n|
    s << v.sample n
  end
end
