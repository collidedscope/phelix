class Hash
  def dup
    if @block
      Hash(K, V).new @block
    else
      Hash(K, V).new
    end.tap &.initialize_dup self
  end
end
