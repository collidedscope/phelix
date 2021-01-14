class Phelix
  # applies the word at the top of the stack, preserving the second-top value
  # ( a f -- a )
  defb "dip" {
    fn = get Fun
    top = s.pop
    fn.call s
    s << top
  }

  # partially applies f to a, leaving the new function at the top of the stack
  # ( a f -- f )
  defb "curry" {
    fn, val = get Fun, Val
    s << -> (t: Vec) { fn.call t << val }
  }
end
