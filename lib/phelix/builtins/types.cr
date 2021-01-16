class Phelix
  defb "fun?" { arity 1
    s << (get(Val).class == Fun)
  }

  defb "map?" { arity 1
    s << (get(Val).class == Map)
  }

  defb "num?" { arity 1
    s << (get(Val).class == Num)
  }

  defb "str?" { arity 1
    s << (get(Val).class == Str)
  }

  defb "vec?" { arity 1
    s << (get(Val).class == Vec)
  }
end
