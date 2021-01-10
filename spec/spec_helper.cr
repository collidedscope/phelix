require "spec"
require "phelix"

def run_phelix(src)
  phx = Phelix.new(Phelix.tokenize src)
  phx.evaluate
  phx.stack
end

class Hash
  def tests
    each do |code, expected|
      run_phelix(code).should eq [expected]
    end
  end
end
