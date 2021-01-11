class Phelix
  # arrayify the top N elements of the stack
  # [e1 ... en N] => [[e1 ... en]]
  defb "[]" { s << s.pop get(BigInt).to_i32 }

  defb "<<" {
    n, e = get BigInt, Array
    s << (e.as(Array) << n)
  }

  defb ">>" {
    e, n = get Array, BigInt
    s << (e.as(Array) << n)
  }

  defb "sort" {
    enu = get Array
    tmp = Array(Value).new enu.size
    if enu.all? &.class.== String
      enu.map(&.as String).sort.each { |e| tmp << e }
    elsif enu.all? &.class.== BigInt
      enu.map(&.as BigInt).sort.each { |e| tmp << e }
    else
      abort "can't sort heterogeneous array"
    end

    s << tmp
  }

  defb "map" {
    fn = get Phelix
    s[-1].as(Array).map! { |e| fn.evaluate([e]).last }
  }

  defb "select" {
    fn = get Phelix
    s[-1].as(Array).select! { |e| fn.evaluate([e]).last }
  }

  defb "reject" {
    fn = get Phelix
    s[-1].as(Array).reject! { |e| fn.evaluate([e]).last }
  }

  defb "maxby" {
    fn, enu = get Phelix, Array
    s << enu.max_by { |e| fn.evaluate([e]).last.as BigInt }
  }

  defb "zip" {
    b, a = get Array, Array
    abort "(zip) length mismatch" unless a.size == b.size
    tmp = Array(Value).new a.size
    a.zip(b) { |c, d| tmp << [c.as Value, d.as Value] }
    s << tmp
  }

  defb "uniq" {
    s << get(Array).to_set.map &.as Value
  }
end
