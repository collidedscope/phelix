class Hash
  def dup
    Hash(K, V).new(@block).tap &.initialize_dup self
  end
end
