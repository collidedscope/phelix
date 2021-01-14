class Phelix
  # inspect [a] => [] + IO
  defb "." { p s.pop; s }

  defb "eval" {
    new(tokenize get Str).call s
  }

  defb "," { p s }

  defb "len" {
    case v = s.pop
    when Vec, Str
      s << v.size.to_big_i
    else
      abort "can't len your thing"
    end
  }

  # range [a b] => [a a+1 ... b]
  defb ".." {
    n, m = get Num, Num
    tmp = Vec.new (m - n).abs + 1
    if m < n
      m.upto(n) { |e| tmp << e }
    else
      m.downto(n) { |e| tmp << e }
    end
    s << tmp
  }

  defb "++" {
    b, a = get Str | Vec, Str | Vec
    case a
    when Str
      s << a.as Str + b.as Str
    else
      s << a.as Vec + b.as Vec
    end
  }

  defb "gets" {
    if t = gets
      s << t
    else
      s << false
    end
  }

  defb "argv" {
    s << ARGV.map &.as Val
  }

  defb "f/read" {
    s << File.read get Str
  }

  defb "<-" {
    scope = @@scope.dup
    get(Vec).reverse_each do |id|
      @@locals[scope] ||= {} of String => Val
      @@locals[scope][id.as Str] = s.pop
    end
    s
  }
end
