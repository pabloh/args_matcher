# frozen_string_literal: true

RSpec.describe Arguments do
  context "Calling 'case args' on a method(*) definition"
  class Argumentative
    include Arguments::Matcher

    def search(*) = case __args__
      in [Array => arr,]
        "an Array eq #{arr.inspect}"
      in name, Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
    end
  end

  subject(:arg) { Argumentative.new  }

  it "when called with an Array" do
    expect(arg.search([1,2])).to eq("an Array eq [1, 2]")
  end

  it "when called with a name and an Array" do
    expect(arg.search("name", [1,2])).to eq('a name "name" and an Array eq [1, 2]')
  end
end
