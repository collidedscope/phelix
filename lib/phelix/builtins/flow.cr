class Phelix
  dbi "if", Val, Fun, Fun do |val, yes, no|
    (val ? yes : no).call s
  end

  dbi "cond", Vec do |vec|
    vec.each_slice 2 do |arm|
      if arm[1]?
        cond, fn = arm.map &.as Fun
        break fn.call s if cond.call(s.dup).last
      else
        break arm[0].as(Fun).call s
      end
    end
  end

  dbi "while", Fun, Fun do |test, body|
    while test.call(s).pop
      s.replace body.call(s)
    end
  end

  dbi "until", Fun, Fun do |test, body|
    until test.call(s).pop
      s.replace body.call(s)
    end
  end

  dbi "times", Fun, Num do |fn, n|
    n.times { fn.call s }
  end

  dbi "each", Vec, Fun do |vec, fn|
    vec.each { |e| fn.call s << e }
  end

  dbi "each/i", Vec, Fun do |vec, fn|
    vec.each_with_index { |e, i| fn.call s << i.to_big_i << e }
  end

  dbi "call", Fun do |fn|
    fn.call s
  end

  dbi "exit" {
    exit
  }
end
