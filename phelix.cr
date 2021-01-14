require "phelix"

{% if flag?(:ocs) %}
  exit
{% end %}

Phelix.new(Phelix.tokenize File.read "prelude.phx").call

if file = ARGV.shift?
  abort "no such file: '#{file}'" unless File.exists? file
  Phelix.new(Phelix.tokenize File.read file).call
else
  stack = [] of Phelix::Val
  loop do
    print "λ "
    if expr = STDIN.gets
      p Phelix.new(Phelix.tokenize expr).call stack
    else
      break
    end
  end
end
