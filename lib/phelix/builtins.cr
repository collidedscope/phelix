class Phelix
  macro get(*types)
    {% if types.size > 1 %}
      { {% for t in types %} s.pop.as {{t}}, {% end %} }
    {% else %}
      s.pop.as {{types[0]}}
    {% end %}
  end

  @@sources = {} of String => String

  macro defb(word, &body)
    @@env[{{word}}] = -> (s: Vec) {{body}}
    @@sources[{{word}}] = {{body.stringify}}
  end

  macro bin_op(op)
    defb {{op.id.stringify[0..0]}} {
      case a = s.pop
      when Vec
        s << a.reduce { |m, n|
          m.as(Num) {{op.id}} n.as(Num)
        }
      when Num
        s << get(Num) {{op.id}} a
      else
        abort "can't #{{{op}}} your #{s}"
      end
    }
  end

  macro chain_op(op)
    defb {{op.id.stringify[0..0]}} {
      case a = s.pop
      when Vec
        s << a.each_cons(2).all? { |(m, n)|
          m.as(Num) {{op.id}} n.as(Num)
        }
      when Num
        s << (get(Num) {{op.id}} a)
      when Str
        s << (get(Str) {{op.id}} a)
      else
        abort "can't #{{{op}}} your #{s}"
      end
    }
  end

  bin_op(:+)
  bin_op(:-)
  bin_op(:*)
  bin_op(://)
  bin_op(:%)

  chain_op(:<)
  chain_op(:>)
  chain_op(:==)
end

require "phelix/builtins/*"
