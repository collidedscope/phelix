require "./spec_helper"

describe Phelix do
  it "does basic arithmetic" do
    {
      "17 25 +" \
      => [42],
      "17 25 -" \
      => [-8],
      "6 7 *" \
      => [42],
      "20 3 /" \
      => [6],
      "20 3 %" \
      => [2]
    }.tests
  end

  it "does arithmetic on collections" do
    {
      "[1 2 3] +" \
      => [6],
      "[0 1 2 3] -" \
      => [-6],
      "[1 2 3 4] *" \
      => [24],
      "[20 5 2] /" \
      => [2],
      "[20 11 5] %" \
      => [4]
    }.tests
  end

  it "can construct 'ranges'" do
    {
      "2 5 .." \
      => [[2,3,4,5]],
      "5 2 .." \
      => [[5,4,3,2]]
    }.tests
  end

  it "can branch conditionally" do
    {
      %(4 2 % 0 = ("even") ("odd") if) \
      => ["even"],
      %(13 2 % 0 = ("even") ("odd") if) \
      => ["odd"],
    }.tests
  end

  it "can do many-armed conditionals" do
    {
      %(sign: [(0 <) ("neg")
               (0 >) ("pos")
               ("zero")] cond nip ;
        [1 0 -1] 'sign map) \
      => [["pos", "zero", "neg"]]
    }.tests
  end
end
