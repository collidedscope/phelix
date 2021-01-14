require "phelix"

{% if flag?(:ocs) %}
  by_file = Phelix.docs.group_by(&.[1][0]).transform_values { |val|
    val.map { |v| {v[0], v[1][1] } }
  }
  p by_file
  exit
{% end %}

Phelix.new(Phelix.tokenize File.read "prelude.phx").call

if file = ARGV.shift?
  abort "no such file: '#{file}'" unless File.exists? file
  Phelix.new(Phelix.tokenize File.read file).call
else
  stack = [] of Phelix::Val
  loop do
    print "⧺ "
    if expr = STDIN.gets
      p Phelix.new(Phelix.tokenize expr).call stack
    else
      break
    end
  end
end
