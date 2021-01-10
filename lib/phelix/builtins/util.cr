class Phelix
  # inspect [a] => [] + IO
  defb "." { p s.pop }

  defb "len" {
    case v = s.pop
    when Array, String
      s << v.size
    else
      abort "can't len your thing"
    end
  }

  # range [a b] => [a a+1 ... b]
  defb ".." {
    n, m = get Int32, Int32
    if m < n
      s << Range.new(m, n).map &.as Value
    else
      tmp = Array(Value).new m - n + 1
      m.downto(n) { |e| tmp << e }
      s << tmp
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
    s << ARGV.map &.as Value
  }

  defb "f/read" {
    s << File.read get String
  }
end
