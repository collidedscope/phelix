require "phelix"

if file = ARGV.shift?
  abort "no such file: '#{file}'" unless File.exists? file
  Phelix.new(Phelix.tokenize File.read file).evaluate
else
  abort "usage: phelix FILE [ARGS]"
end
