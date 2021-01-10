require "./spec_helper"

describe Phelix do
  it "does basic arithmetic" do
    run_phelix("17 25 +").should eq [42]
    run_phelix("17 25 -").should eq [-8]
    run_phelix("6 7 *").should eq [42]
    run_phelix("20 3 /").should eq [6]
    run_phelix("20 3 %").should eq [2]
  end

  it "does arithmetic on collections" do
    run_phelix("[1 2 3] +").should eq [6]
  end
end
