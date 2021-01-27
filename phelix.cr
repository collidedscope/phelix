require "phelix"

{% if flag?(:ocs) %}
  # Generate docs.yaml and exit.
  require "phelix/docs"
  exit
{% end %}

require "fancyline"

# TODO: Follow XDG specification.
HISTFILE = "history"
File.touch HISTFILE

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
    @@fatal = false
    stack = Vec.new

    fancy = Fancyline.new
    hist = fancy.history
    widget = Fancyline::Widget::History.new

    fancy.actions.set Fancyline::Key::Control::CtrlP do |ctx|
      if widget.@history
        widget.show_entry ctx, -1
      else
        ctx.start_widget widget
      end
    end

    fancy.actions.set Fancyline::Key::Control::CtrlN do |ctx|
      if widget.@history
        widget.show_entry ctx, +1
      end
    end

    at_exit { File.open HISTFILE, "w", &->hist.save(IO) }
    File.open HISTFILE, "r", &->hist.load(IO)

    while expr = fancy.readline "⧺ "
      p Phelix[expr].call stack
    end
  rescue Fancyline::Interrupt
    puts
  end
end

Phelix.main
