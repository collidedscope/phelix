struct Proc
  def inspect(io)
    io << Phelix.env.key_for self
  end
end
