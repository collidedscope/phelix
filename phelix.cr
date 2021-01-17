require "phelix"

{% if flag?(:ocs) %}
  by_file = Phelix.docs.group_by(&.[1][0]).transform_values { |val|
    val.map { |v| {v[0], v[1][1] } }
  }
  p by_file
  exit
{% end %}

pre = File.read File.expand_path "prelude.phx", __DIR__
Phelix[pre].call

class Phelix
  def self.main
    if file = ARGV.shift?
      abort "no such file: '#{file}'" unless File.exists? file
      Phelix[File.read file].call
    else
      repl
    end
  end

  def self.repl
    stack = Vec.new
    loop do
      print "⧺ "
      if expr = STDIN.gets
        p Phelix[expr].call stack
      else
        break
      end
    end
  end
end

Phelix.main
