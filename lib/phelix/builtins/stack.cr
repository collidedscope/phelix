class Phelix
  # creates a copy of the value at the top of the stack
  # ( a -- a a )
  defb "dup" { arity 1
    s << s[-1]
  }

  # duplicates the pair at the top of the stack
  # ( a b -- a b a b )
  defb "2dup" { arity 2
    s << s[-2]
    s << s[-2]
  }

  # exchanges the two values at the top of the stack
  # ( a b -- b a )
  defb "swap" { arity 2
    s[-1], s[-2] = s[-2], s[-1]
  }

  # exchanges the two pairs at the top of the stack
  # ( a b c d -- c d a b )
  defb "2swap" { arity 4
    s[-4], s[-3], s[-2], s[-1] = s[-2], s[-1], s[-4], s[-3]
  }

  # exchanges the two values immediately below the top of the stack
  # ( a b c -- b a c )
  defb "swapd" { arity 3
    s[-2], s[-3] = s[-3], s[-2]
  }

  # removes the value at the top of the stack
  # ( a -- )
  defb "drop" { arity 1
    s.pop
  }

  # removes the second-top value of the stack
  # ( a b c -- a c )
  defb "nip" { arity 2
    s.delete_at -2
  }

  # buries a copy of the top value beneath the second-top value
  # ( a b -- b a b )
  defb "tuck" { arity 2
    s.insert -3, s[-1]
  }

  # rotates the stack such that the third value comes to the top
  # ( a b c -- b c a )
  defb "rot" { arity 3
    s[-3], s[-2], s[-1] = s[-2], s[-1], s[-3]
  }

  # places the top value two down in the stack (inverse of rot)
  # ( a b c -- c a b )
  defb "-rot" { arity 3
    s[-3], s[-2], s[-1] = s[-1], s[-3], s[-2]
  }

  # copies the value one under the top of the stack
  # ( a b -- a b a )
  defb "over" { arity 2
    s << s[-2]
  }

  # copies the value two under the top of the stack
  # ( a b c -- a b c a )
  defb "pick" { arity 3
    s << s[-3]
  }

  # clones the value at the top of the stack (relevant for reference types)
  defb "clone" { arity 1
    s << s[-1].dup
  }

  # blows away the entire stack
  defb "clear" {
    s.clear
  }
end
