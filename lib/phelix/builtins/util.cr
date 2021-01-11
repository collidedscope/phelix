class Phelix
  # inspect [a] => [] + IO
  defb "." { p s.pop }

  defb "len" {
    case v = s.pop
    when Array, String
      s << v.size.to_big_i
    else
      abort "can't len your thing"
    end
  }

  # range [a b] => [a a+1 ... b]
  defb ".." {
    n, m = get BigInt, BigInt
    tmp = Array(Value).new (m - n).abs + 1
    if m < n
      m.upto(n) { |e| tmp << e }
    else
      m.downto(n) { |e| tmp << e }
    end
    s << tmp
  }

  defb "gets" {
    if t = gets
      s << t
    else
      s << false
    end
  }

  defb "argv" {
    s << ARGV.map &.as Value
  }

  defb "f/read" {
    s << File.read get String
  }
end
