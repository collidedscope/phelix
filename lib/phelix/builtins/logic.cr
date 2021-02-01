class Phelix
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

  chain_op("<")
  chain_op("<=")
  chain_op(">")
  chain_op(">=")
  chain_op("=", :==)

  dbi "=", Bool, Bool do |a, b|
    s << (a == b)
  end

  dbi "=", Str, Char do |str, c|
    s << (str[0] == c)
  end

  dbi "=", Char, Str do |c, str|
    s << (str[0] == c)
  end

  dbi "true" do
    s << true
  end

  dbi "false" do
    s << false
  end

  dbi "not", Val do |b|
    s << !b
  end

  dbi "and", Val, Val do |a, b|
    s << (a && b)
  end

  dbi "or", Val, Val do |a, b|
    s << (a || b)
  end

  dbi "xor", Bool, Bool do |a, b|
    s << (a != b)
  end

  dbi "eq", Bool, Bool do |a, b|
    s << (a == b)
  end
end
