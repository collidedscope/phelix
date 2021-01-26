class Phelix
  macro bin_op(op)
    dbi {{op.id.stringify[0..0]}} do
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
    end
  end

  macro chain_op(op)
    dbi {{op.id.stringify[0..0]}} do
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
    end
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
