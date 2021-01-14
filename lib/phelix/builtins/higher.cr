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
    fn, val = get Phelix, Val
    # TODO: just stringifying the value to be curried is
    # super-brittle, but it suffices for very simple cases
    s << Phelix.new fn.@tokens.unshift val.to_s
  }
end
