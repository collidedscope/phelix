class Phelix
  # range [a b] => [a a+1 ... b]
  dbi "..", Num, Num do |m, n|
    tmp = Vec.new (m - n).abs + 1
    if m < n
      m.upto(n) { |e| tmp << e }
    else
      m.downto(n) { |e| tmp << e }
    end
    s << tmp
  end

  dbi "argv" do
    s << ARGV.map &.as Val
  end

  dbi "rand", Num do |n|
    s << rand n
  end

  dbi "<-", Vec do |vars|
    arity vars.size
    scope = @@scope.dup

    vars.reverse_each do |id|
      @@locals[scope] ||= {} of String => Val
      @@locals[scope][id.as Str] = s.pop
    end
  end

  # removes all errors from the stack
  dbi "e" do
    s.reject! Err
  end

  dbi "source", Fun do |fn|
    return s << sources[env.key_for fn] if fn.is_a? Proc

    s << fn.@insns.map { |i|
      (i.t == Type::Word ? env.fetch(i.v, i.v) : i.v).as Val
    }
  end

  dbi "num->str", Num do |n|
    s << n.to_s
  end

  dbi "str->num", Str do |str|
    s << str.to_big_i
  end

  dbi "sleep", Num do |n|
    sleep n.milliseconds
  end
end
