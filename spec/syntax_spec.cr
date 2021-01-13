require "./spec_helper"

describe Phelix do
  it "supports user-defined words" do
    {
      "double: dup + ;
      21 double" \
      => [42],
    }.tests
  end

  it "has vector literals" do
    {
      "[4 2 0] dup len" \
      => [[4,2,0], 3]
    }.tests
  end

  it "has map literals" do
    {
      "{1 2 3 4}" \
      => [{1=>2, 3=>4}]
    }.tests
  end
end
