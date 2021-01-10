class Phelix
  defb "juxt" {
    fns = get Array
    s << fns.map { |f| f.as(Phelix).evaluate(s.dup).last.as Value }
  }
end
