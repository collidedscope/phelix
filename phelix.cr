require "phelix"

if file = ARGV.shift?
  abort "no such file: '#{file}'" unless File.exists? file
  Phelix.new(Phelix.tokenize File.read file).evaluate
else
  stack = [] of Phelix::Val
  loop do
    print "λ "
    if expr = STDIN.gets
      p Phelix.new(Phelix.tokenize expr).evaluate stack
    else
      break
    end
  end
end
