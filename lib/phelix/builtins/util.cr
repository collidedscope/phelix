class Phelix
  # pops the top of the stack and displays it in a user-friendly way
  defb "." { arity 1
    p s.pop
  }

  # displays the entire stack (non-destructive)
  defb "," {
    p s
  }

  defb "eval" { arity 1
    Phelix[get Str].call s
  }

  defb "len" { arity 1
    case v = s.pop
    when Vec, Str
      s << v.size.to_big_i
    else
      raise "expected Str | Vec for len, got #{v.inspect}"
    end
  }

  # range [a b] => [a a+1 ... b]
  defb ".." { arity 2
    n, m = get Num, Num
    tmp = Vec.new (m - n).abs + 1
    if m < n
      m.upto(n) { |e| tmp << e }
    else
      m.downto(n) { |e| tmp << e }
    end
    s << tmp
  }

  defb "++" { arity 2
    b, a = get Str | Vec, Str | Vec
    case a
    when Str
      s << a.as Str + b.as Str
    else
      s << a.as Vec + b.as Vec
    end
  }

  defb "getb" {
    s << ((b = STDIN.read_byte) ? b.to_big_i : false)
  }

  defb "getc" {
    s << ((c = STDIN.read_char) ? c.to_s : false)
  }

  defb "gets" {
    if t = gets
      s << t
    else
      s << false
    end
  }

  defb "puts" { arity 1
    puts s.pop
  }

  defb "print" { arity 1
    print s.pop
  }

  defb "argv" {
    s << ARGV.map &.as Val
  }

  defb "f/read" { arity 1
    s << File.read get Str
  }

  defb "rand" { arity 1
    s << rand get Num
  }

  defb "<-" { arity 1
    scope = @@scope.dup
    vars = get Vec
    arity vars.size

    vars.reverse_each do |id|
      @@locals[scope] ||= {} of String => Val
      @@locals[scope][id.as Str] = s.pop
    end
  }

  # removes all errors from the stack
  defb "e" {
    s.reject! Err
  }

  defb "source" { arity 1
    fn = get Fun
    return s << @@sources[env.key_for fn] if fn.is_a? Proc

    s << fn.@insns.map { |i|
      (i.t == Type::Word ? env.fetch(i.v, i.v) : i.v).as Val
    }
  }
end
