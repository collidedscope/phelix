class Phelix
  # duplicate [a] => [a a]
  defb "dup" { s << s[-1].dup }

  # remove [a] => []
  defb "pop" { s.pop }

  # swap [a b] => [b a]
  defb "swap" { s[-1], s[-2] = s[-2], s[-1] }

  # rotate the stack such that [a b c] => [b c a]
  defb "rot" { s[-3], s[-2], s[-1] = s[-2], s[-1], s[-3] }

  defb "\\" {
    get(Array).each { |e| s << e }
  }
end
