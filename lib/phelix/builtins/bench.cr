class Phelix
  defb "bench" { arity 1
    {% unless flag? :release %}
      STDERR.puts Err.new "benchmarking with unoptimized interprter"
    {% end %}

    n = 10
    fn = get Fun
    ts = [] of Time::Span
    n.times { ts << Time.measure { fn.call s.dup } }

    ts.sort!
    min, max = ts.shift, ts.pop
    avg = ts.sum / (n - 2)

    p fn
    puts "  min: #{min.total_milliseconds} ms"
    puts "  max: #{max.total_milliseconds} ms"
    puts "  avg: #{avg.total_milliseconds} ms"
  }
end
