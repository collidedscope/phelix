class Phelix
  # creates a copy of the value at the top of the stack
  # ( a -- a a )
  dbi "dup" do
    arity 1
    s << s[-1]
  end

  # duplicates the pair at the top of the stack
  # ( a b -- a b a b )
  dbi "2dup" do
    arity 2
    s << s[-2]
    s << s[-2]
  end

  # duplicates the value one under the top of the stack
  # ( a b -- a a b )
  dbi "dupd" do
    arity 2
    s.insert -2, s[-2]
  end

  # exchanges the two values at the top of the stack
  # ( a b -- b a )
  dbi "swap" do
    arity 2
    s[-1], s[-2] = s[-2], s[-1]
  end

  # exchanges the two pairs at the top of the stack
  # ( a b c d -- c d a b )
  dbi "2swap" do
    arity 4
    s[-4], s[-3], s[-2], s[-1] = s[-2], s[-1], s[-4], s[-3]
  end

  # exchanges the two values immediately below the top of the stack
  # ( a b c -- b a c )
  dbi "swapd" do
    arity 3
    s[-2], s[-3] = s[-3], s[-2]
  end

  # removes the value at the top of the stack
  # ( a -- )
  dbi "drop" do
    arity 1
    s.pop
  end

  # removes the second-top value of the stack
  # ( a b c -- a c )
  dbi "nip" do
    arity 2
    s.delete_at -2
  end

  # removes the second- and third-top values of the stack
  # ( a b c -- c )
  dbi "2nip" do
    arity 3
    s.delete_at -3, 2
  end

  # buries a copy of the top value beneath the second-top value
  # ( a b -- b a b )
  dbi "tuck" do
    arity 2
    s.insert -3, s[-1]
  end

  # rotates the stack such that the third value comes to the top
  # ( a b c -- b c a )
  dbi "rot" do
    arity 3
    s[-3], s[-2], s[-1] = s[-2], s[-1], s[-3]
  end

  # places the top value two down in the stack (inverse of rot)
  # ( a b c -- c a b )
  dbi "-rot" do
    arity 3
    s[-3], s[-2], s[-1] = s[-1], s[-3], s[-2]
  end

  # copies the value one under the top of the stack
  # ( a b -- a b a )
  dbi "over" do
    arity 2
    s << s[-2]
  end

  # copies the value two under the top of the stack
  # ( a b c -- a b c a )
  dbi "pick" do
    arity 3
    s << s[-3]
  end

  # clones the value at the top of the stack (relevant for reference types)
  dbi "clone" do
    arity 1
    s << s[-1].dup
  end

  # blows away the entire stack
  dbi "clear" do
    s.clear
  end
end
