class Phelix
  # pops the top of the stack and displays it in a user-friendly way
  dbi ".", Val do |val|
    p val
  end

  # displays the entire stack (non-destructive)
  dbi "," {
    p s
  }

  dbi "getb" do
    s << (STDIN.read_byte || -1).to_big_i
  end

  dbi "getc" do
    s << ((c = STDIN.read_char) ? c.to_s : false)
  end

  dbi "gets" do
    s << (gets || false)
  end

  dbi "puts", Val do |val|
    puts val
  end

  dbi "print", Val do |val|
    print val
  end

  dbi "f/read", Str do |path|
    s << File.read path
  end
end
