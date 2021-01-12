class Phelix
  defb "juxt" {
    fns = get Vec
    s << fns.map { |f| f.as(Fun).evaluate(s.dup).last.as Val }
  }
end
