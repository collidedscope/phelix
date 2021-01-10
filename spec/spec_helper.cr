require "spec"
require "phelix"

def run_phelix(src)
  phx = Phelix.new(Phelix.tokenize src)
  phx.evaluate
  phx.stack
end
