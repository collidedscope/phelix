class Phelix
  dbi "s/up", Str do |str|
    s << str.upcase
  end

  dbi "s/dn", Str do |str|
    s << str.downcase
  end

  dbi "s/split", Str, Char | Str do |str, delim|
    o = Vec.new
    str.split(delim) { |v| o << v }
    s << o
  end

  dbi "s/join", Vec, Char | Str do |v, sep|
    s << v.join sep
  end

  dbi "s/slice", Str, Num, Num do |str, i, j|
    s << str[i..j]
  end

  dbi "s/bytes", Str do |str|
    s << str.bytes.map &.to_big_i
  end

  dbi "s/chars", Str do |str|
    s << str.chars
  end

  dbi "chr", Num do |n|
    s << n.to_i.chr
  end
end
