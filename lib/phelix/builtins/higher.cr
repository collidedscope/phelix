class Phelix
  # applies the word at the top of the stack, preserving the second-top value
  # ( a f -- a )
  defb "dip" { arity 2
    fn = get Fun
    top = s.pop
    fn.call s
    s << top
  }

  # partially applies f to a, leaving the new function at the top of the stack
  # ( a f -- f )
  defb "curry" { arity 2
    fn, val = get Fun, Val
    s << -> (t: Vec) { fn.call t << val }
  }
end
