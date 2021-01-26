class Phelix
  dbi "fun?", Val do |val|
    s << (val.class == Fun)
  end

  dbi "map?", Val do |val|
    s << (val.class == Map)
  end

  dbi "num?", Val do |val|
    s << (val.class == Num)
  end

  dbi "str?", Val do |val|
    s << (val.class == Str)
  end

  dbi "vec?", Val do |val|
    s << (val.class == Vec)
  end
end
