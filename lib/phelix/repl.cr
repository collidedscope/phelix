require "fancyline"

CACHE = ENV["XDG_CACHE_HOME"]? || File.join ENV["HOME"], ".cache"
HISTFILE = File.join CACHE, "phelix", "phelix_history"

Dir.mkdir_p File.dirname HISTFILE
File.touch HISTFILE

class Phelix
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
