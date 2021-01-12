class Phelix
  # inspect [a] => [] + IO
  defb "." { p s.pop }

  defb "eval" {
    Fun.new(Fun.tokenize get Str).evaluate s
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
end
