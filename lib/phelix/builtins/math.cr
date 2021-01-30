class Phelix
  CMP = [Num, Str]

  macro bin_op(op)
    dbi {{op[0..0]}}, Num, Num do |a, b|
      s << a {{op.id}} b
    end

    dbi {{op[0..0]}}, Vec do |v|
      s << v.reduce { |a, b| a.as(Num) {{op.id}} b.as(Num) }
    end
  end

  macro chain_op(op)
    {% for t in CMP %}
      dbi {{op[0..0]}}, {{t}}, {{t}} do |a, b|
        s << (a {{op.id}} b)
      end
    {% end %}

    dbi {{op[0..0]}}, Vec do |v|
      s << v.each_cons(2).all? { |(a, b)| a.as(Num) {{op.id}} b.as(Num) }
    end
  end

  bin_op("+")
  bin_op("-")
  bin_op("*")
  bin_op("//")
  bin_op("%")

  chain_op("<")
  chain_op(">")
  chain_op("==")
end
