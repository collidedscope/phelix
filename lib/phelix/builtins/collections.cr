class Phelix
  dbi "nth", Str | Vec, Num do |v, n|
    if n >= v.size || n < -v.size
      raise "index #{n} out of bounds for nth"
    end
    s << v[n]
  end

  dbi "nth", Num, Str | Vec do |n, v|
    if n >= v.size || n < -v.size
      raise "index #{n} out of bounds for nth"
    end
    s << v[n]
  end

  dbi "len", (Map | Str | Vec) do |val|
    s << val.size.to_big_i
  end

  dbi "in", Val, Str | Vec do |needle, haystack|
    s << case haystack
         when Str; haystack.includes? needle.as Str
         else haystack.includes? needle
         end
  end

  dbi "rev", Str | Vec do |val|
    s << val.reverse
  end

  dbi "++", Str | Vec, Str | Vec do |a, b|
    case a
    when Str
      s << a.as Str + b.as Str
    else
      s << a.as Vec + b.as Vec
    end
  end
end
