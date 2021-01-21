class Phelix
  macro raise(message)
    e = Err.new {{message}}
    if @@fatal
      abort e
    else
      return s << e
    end
  end

  macro fail(wanted, got)
    raise "wanted #{alias_for {{wanted}}} for #{@@now}, got #{{{got}}.inspect}"
  end

  macro check(val, type)
    begin
      {{val}}.as {{type}}
    rescue TypeCastError
      fail {{type}}, {{val}}
    end
  end

  macro arity(need)
    if s.size < {{need}}
      raise "need at least #{{{need}}} values for #{@@now}, have #{s.size}"
    end
  end

  macro get(type)
    val = s.pop
    check val, {{type}}
  end

  macro get(*types)
    vals = s.pop {{types.size}}
    {
      {% for t in types %}
        (v = vals.shift; check(v, {{t}})),
      {% end %}
    }
  end

  @@docs = {} of String => {String, Int32}
  @@sources = {} of String => String

  macro defb(word, &body)
    {% if flag?(:ocs) %}
      @@docs[{{word}}] = {__FILE__, __LINE__}
    {% else %}
      @@env[{{word}}] = -> (s: Vec) { -> {{body}}.call; s }
      @@sources[{{word}}] = {{body.stringify}}
    {% end %}
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

  # pops the top two values and pushes their sum unless the top value is a
  # vector, in which case the result is the vector's reduction over addition
  bin_op(:+)
  # pops the top two values and pushes their difference unless the top value is a
  # vector, in which case the result is the vector's reduction over subtraction
  bin_op(:-)
  # pops the top two values and pushes their product unless the top value is a
  # vector, in which case the result is the vector's reduction over multiplication
  bin_op(:*)
  # pops the top two values and pushes their quotient unless the top value is a
  # vector, in which case the result is the vector's reduction over division
  bin_op(://)
  # pops the top two values and pushes their modulus unless the top value is a
  # vector, in which case the result is the vector's reduction over modulation
  bin_op(:%)

  # pops the top two values and pushes whether the first is less than the second
  chain_op(:<)
  # pops the top two values and pushes whether the first is greater than the second
  chain_op(:>)
  # pops the top two values and pushes whether they're equal
  chain_op(:==)
end

require "phelix/builtins/*"
