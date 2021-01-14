require "./spec_helper"

describe Phelix do
  it "can construct vectors from the stack" do
    {
      "4 2 0 3 []" \
      => [[4,2,0]]
    }.tests
  end

  it "supports vector replication" do
    {
      "[1 2] 3 v*" \
      => [[1,2,1,2,1,2]],
    }.tests
  end
end
