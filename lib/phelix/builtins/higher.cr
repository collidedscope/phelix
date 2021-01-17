class Phelix
  def self.as_insn(val)
    # the magic sauce that lets us treat builtins as ordinary values
    return Insn.new Type::Word, @@env.key_for val if val.is_a? Proc

    type = case val
    when Fun; Type::Fun
    when Map; Type::Map
    when Num; Type::Num
    when Str; Type::Str
    when Vec; Type::Vec
    else Type::Word
    end

    Insn.new type, val
  end

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
    base = fn.is_a?(Phelix) ? fn.@insns : [as_insn fn]
    s << new insns: [as_insn val] + base
  }

  # takes two functions f and g and returns a function that calls f then g
  # ( f g -- (f g) )
  defb "compose" { arity 2
    g, f = get Fun, Fun
    f = f.is_a?(Phelix) ? f.@insns : [as_insn f]
    g = g.is_a?(Phelix) ? g.@insns : [as_insn g]
    s << new insns: f + g
  }
end
