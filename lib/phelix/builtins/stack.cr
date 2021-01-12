class Phelix
  # duplicate [a] => [a a]
  defb "dup" { s << s[-1].dup }

  defb "2dup" {
    2.times {s << s[-2].dup }
    s
  }

  defb "2swap" {
    s[-4], s[-3], s[-2], s[-1] = s[-2], s[-1], s[-4], s[-3]
    s
  }

  # remove [a] => []
  defb "pop" { s.pop; s }

  # swap [a b] => [b a]
  defb "swap" { s[-1], s[-2] = s[-2], s[-1] ; s}

  # rotate the stack such that [a b c] => [b c a]
  defb "rot" { s[-3], s[-2], s[-1] = s[-2], s[-1], s[-3] ; s}

  defb "\\" {
    get(Vec).each { |e| s << e }
    s
  }
end
