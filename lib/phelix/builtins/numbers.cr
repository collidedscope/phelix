class Phelix
  dbi "even?", Num do |n|
    s << n.even?
  end

  dbi "odd?", Num do |n|
    s << n.odd?
  end

  dbi "digits", Num do |n|
    s << n.digits.map &.to_big_i.as Val
  end

  dbi "digits/b", Num, Num do |n, b|
    s << n.digits(b).map &.to_big_i.as Val
  end
end
