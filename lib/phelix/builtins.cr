class Phelix
  @@builtins = {} of Str => Proc(Vec, Nil)

  macro get(*types)
    {% if types.size > 1 %}
      { {% for t in types %} s.pop.as {{t}}, {% end %} }
    {% else %}
      s.pop.as {{types[0]}}
    {% end %}
  end

  macro bin_op(op)
    @@builtins[{{op.id.stringify[0..0]}}] = -> (s: Vec) {
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
    @@builtins[{{op.id.stringify[0..0]}}] = -> (s: Vec) {
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

  macro defb(word, &body)
    @@builtins[{{word}}] = -> (s: Vec) {{body}}
  end
end

require "phelix/builtins/*"
