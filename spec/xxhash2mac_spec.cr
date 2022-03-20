require "./spec_helper"

describe Xxhash2mac do
  it "is able to derive a MAC address from arbitrary input string" do
    input_string = "Anything_here"
    Xxhash2mac.gen(input_string).hex.should eq("cf:8d:24:fc:ae:3c")
  end
end
