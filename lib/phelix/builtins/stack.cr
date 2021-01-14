class Phelix
  # creates a copy of the value at the top of the stack
  # ( a -- a a )
  defb "dup" {
    s << s[-1]
  }

  # duplicates the pair at the top of the stack
  # ( a b -- a b a b )
  defb "2dup" {
    s << s[-2]
    s << s[-2]
  }

  # swaps the values at the top of the stack
  # ( a b -- b a )
  defb "swap" {
    s[-1], s[-2] = s[-2], s[-1]
    s
  }

  # swaps the pairs at the top of the stack
  # ( a b c d -- c d a b )
  defb "2swap" {
    s[-4], s[-3], s[-2], s[-1] = s[-2], s[-1], s[-4], s[-3]
    s
  }

  # removes the value at the top of the stack
  # ( a -- )
  defb "pop" {
    s.pop
    s
  }

  # removes the second-top value of the stack
  # ( a b c -- a c )
  defb "nip" {
    s.delete_at -2
    s
  }

  # places the top value two down in the stack (inverse of rot)
  # ( a b c -- c a b )
  defb "tuck" {
    s[-3], s[-2], s[-1] = s[-1], s[-3], s[-2]
    s
  }

  # rotates the stack such that the third element comes to the top
  # ( a b c -- b c a )
  defb "rot" {
    s[-3], s[-2], s[-1] = s[-2], s[-1], s[-3]
    s
  }

  # copies the value one under the top of the stack
  # ( a b -- a b a )
  defb "over" {
    s << s[-2]
  }

  # clones the value at the top of the stack (relevant for reference types)
  defb "clone" {
    s << s[-1].dup
  }
end
