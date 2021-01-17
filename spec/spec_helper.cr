require "spec"
require "phelix"

def run_phelix(src)
  Phelix[src].call
end

class Hash
  def tests
    each do |code, expected|
      run_phelix(code).should eq expected
    end
  end
end
