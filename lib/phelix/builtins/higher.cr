class Phelix
  # applies the word at the top of the stack, preserving the second-top value
  # ( a f -- a )
  defb "dip" {
    fn = get Fun
    top = s.pop
    fn.call s
    s << top
  }
end
