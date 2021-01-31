EXCLUDE = %w[
  + - * / % , . << >> .. <= < = > >= <- []
  true false if unless when when* cond
  sleep gets get put invert merge
  while while* until times each each/i forever return
]

def clean(words)
  (words - EXCLUDE).reject(/^[fs]\//).sort
end

require "phelix"
builtin = clean Phelix.env.keys

pre = File.read File.expand_path "../prelude.phx", __DIR__
Phelix.env.clear
Phelix[pre].call
prelude = clean Phelix.env.keys

puts "syn keyword phxBuiltin #{builtin.join ' '}"
puts "syn keyword phxPrelude #{prelude.join ' '}"
