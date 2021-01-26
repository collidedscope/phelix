class Phelix
  dbi "even?", Num do |n|
    s << n.even?
  end

  dbi "odd?", Num do |n|
    s << n.odd?
  end
end
