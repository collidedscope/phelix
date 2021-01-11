class Phelix
  @@builtins = {} of String => Proc(Array(Value), Nil)

  macro get(*types)
    {% if types.size > 1 %}
      { {% for t in types %} s.pop.as({{t}}), {% end %} }
    {% else %}
      s.pop.as({{types[0]}})
    {% end %}
  end

  macro bin_op(op)
    @@builtins[{{op.id.stringify[0..0]}}] = -> (s: Array(Value)) {
      case a = s.pop
      when Array
        s << a.reduce { |m, n|
          m.as(BigInt) {{op.id}} n.as(BigInt)
        }
      when BigInt
        s << get(BigInt) {{op.id}} a
      else
        abort "can't #{{{op}}} your #{s}"
      end
    }
  end

  macro chain_op(op)
    @@builtins[{{op.id.stringify[0..0]}}] = -> (s: Array(Value)) {
      case a = s.pop
      when Array
        s << a.each_cons(2).all? { |(m, n)|
          m.as(BigInt) {{op.id}} n.as(BigInt)
        }
      when BigInt
        s << (get(BigInt) {{op.id}} a)
      when String
        s << (get(String) {{op.id}} a)
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
    @@builtins[{{word}}] = -> (s: Array(Value)) {{body}}
  end
end

require "phelix/builtins/*"
