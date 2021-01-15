class Phelix
  defb "even?" { arity 1
    s << get(Num).even?
  }

  defb "odd?" { arity 1
    s << get(Num).odd?
  }
end
