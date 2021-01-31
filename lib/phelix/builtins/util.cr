class Phelix
  # pops the top of the stack and displays it in a user-friendly way
  dbi ".", Val do |val|
    p val
  end

  # displays the entire stack (non-destructive)
  dbi "," {
    p s
  }

  dbi "len", (Map | Str | Vec) do |val|
    s << val.size.to_big_i
  end

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

  dbi "++", Str | Vec, Str | Vec do |a, b|
    case a
    when Str
      s << a.as Str + b.as Str
    else
      s << a.as Vec + b.as Vec
    end
  end

  dbi "getb" do
    s << (STDIN.read_byte || -1).to_big_i
  end

  dbi "getc" do
    s << ((c = STDIN.read_char) ? c.to_s : false)
  end

  dbi "gets" do
    s << (gets || false)
  end

  dbi "puts", Val do |val|
    puts val
  end

  dbi "print", Val do |val|
    print val
  end

  dbi "argv" do
    s << ARGV.map &.as Val
  end

  dbi "f/read", Str do |path|
    s << File.read path
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
