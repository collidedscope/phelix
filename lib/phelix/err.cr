require "colorize"

class Phelix
  struct Err
    def initialize(@message : String)
    end

    def inspect(io)
      io << @message.colorize :light_red
    end
  end
end
