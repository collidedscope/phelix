class Phelix
  @@bench_warn = true

  dbi "bench", Fun do |fn|
    {% unless flag? :release %}
      if @@bench_warn
        STDERR.puts Err.new "benchmarking with unoptimized interpreter"
        @@bench_warn = false
      end
    {% end %}

    n = 10
    ts = [] of Time::Span
    n.times { ts << Time.measure { fn.call s.dup } }

    ts.sort!
    min, max = ts.shift, ts.pop
    avg = ts.sum / (n - 2)

    p fn
    puts "  min: #{min.total_milliseconds} ms"
    puts "  max: #{max.total_milliseconds} ms"
    puts "  avg: #{avg.total_milliseconds} ms"
  end
end
