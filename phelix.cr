require "phelix"

{% if flag?(:ocs) %}
  # Generate docs.yaml and exit.
  require "phelix/docs"
  exit
{% end %}

require "phelix/repl"

pre = File.read File.expand_path "prelude.phx", __DIR__
Phelix[pre].call

if file = ARGV.shift?
  abort "no such file: '#{file}'" unless File.exists? file
  Phelix[File.read file].call
else
  Phelix.repl
end
