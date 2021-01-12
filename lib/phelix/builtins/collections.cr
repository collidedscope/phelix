class Phelix
  # arrayify the top N elements of the stack
  # [e1 ... en N] => [[e1 ... en]]
  defb "[]" { s << s.pop get(Num).to_i32 }

  defb "<<" {
    n, e = get Val, Vec
    s << (e.as(Vec) << n)
  }

  defb ">>" {
    e, n = get Vec, Val
    s << (e.as(Vec) << n)
  }

  defb "sort" {
    enu = get Vec
    tmp = Vec.new enu.size
    if enu.all? &.class.== Str
      enu.map(&.as Str).sort.each { |e| tmp << e }
    elsif enu.all? &.class.== Num
      enu.map(&.as Num).sort.each { |e| tmp << e }
    else
      abort "can't sort heterogeneous array"
    end

    s << tmp
  }

  defb "map" {
    fn = get Fun
    s[-1].as(Vec).map! { |e| fn.evaluate([e]).last }
  }

  defb "select" {
    fn = get Fun
    s[-1].as(Vec).select! { |e| fn.evaluate([e]).last }
  }

  defb "reject" {
    fn = get Fun
    s[-1].as(Vec).reject! { |e| fn.evaluate([e]).last }
  }

  defb "maxby" {
    fn, enu = get Fun,Vec
    s << enu.max_by { |e| fn.evaluate([e]).last.as Num }
  }

  defb "zip" {
    b, a = get Vec, Vec
    abort "(zip) length mismatch" unless a.size == b.size
    tmp = Vec.new a.size
    a.zip(b) { |c, d| tmp << [c.as Val, d.as Val] }
    s << tmp
  }

  defb "uniq" {
    s << get(Vec).to_set.map &.as Val
  }
end
