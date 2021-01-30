class Phelix
  macro bin_op(word, op = nil)
    dbi {{word}}, Num, Num do |a, b|
      s << a {{(op || word).id}} b
    end

    dbi {{word}}, Vec do |v|
      s << v.reduce { |a, b| a.as(Num) {{(op || word).id}} b.as(Num) }
    end
  end

  CMP = [Char, Num, Str]

  macro chain_op(word, op = nil)
    {% for t in CMP %}
      dbi {{word}}, {{t}}, {{t}} do |a, b|
        s << (a {{(op || word).id}} b)
      end
    {% end %}

    dbi {{word}}, Vec do |v|
      s << v.each_cons(2).all? { |(a, b)| a.as(Num) {{(op || word).id}} b.as(Num) }
    end
  end

  bin_op("+")
  bin_op("-")
  bin_op("*")
  bin_op("/", ://)
  bin_op("%")

  chain_op("<")
  chain_op("<=")
  chain_op(">")
  chain_op(">=")
  chain_op("=", :==)
end
