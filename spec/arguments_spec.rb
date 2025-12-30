# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arguments do
  class Argumentative
    include Arguments::Matcher
  end

  subject(:arg) { Argumentative.new  }

  context "Calling 'case args' on method(...) definition" do
    class Argumentative
      def with_elipsis(...)= case args
      in name: name, opts: Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      in opts: Array => arr
        "an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.with_elipsis(opts: [1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.with_elipsis(name: 'name', opts: [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(**) definition" do
    class Argumentative
      def with_opts(**)= case args
      in name: name, opts: Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      in opts: Array => arr
        "an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.with_opts(opts: [1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.with_opts(name: 'name', opts: [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(name: 'VALUE', opts:) definition" do
    class Argumentative
      def arg_with_optional(opts:, name: 'ASD')= case args
      in name: "ASD", opts: Array => arr
        "a name \"ASD\" and an Array eq #{arr.inspect}"
      in name: name, opts: Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.arg_with_optional(opts: [1,2])).to eq('a name "ASD" and an Array eq [1, 2]')
    end

    it "when called with a name and an Array" do
      expect(arg.arg_with_optional(name: 'name', opts: [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(name: 'VALUE', opts:, **) definition" do
    class Argumentative
      def arg_with_optional_and_rest(opts:, name: 'ASD', **)= case args
      in name: "ASD", opts: Array => arr, qux: 32
        "a name \"ASD\" an Array eq #{arr.inspect} and other"
      in name: name, opts: Array => arr, qux: 32
        "a name #{name.inspect} an Array eq #{arr.inspect} and other"
      end
    end

    it "when called with an Array" do
      expect(arg.arg_with_optional_and_rest(opts: [1,2], qux: 32)).to eq('a name "ASD" an Array eq [1, 2] and other')
    end

    it "when called with a name and an Array" do
      expect(arg.arg_with_optional_and_rest(name: 'name', opts: [1,2], qux: 32)).to eq('a name "name" an Array eq [1, 2] and other')
    end
  end

  context "Calling 'case args' on method(name:, **) definition" do
    class Argumentative
      def arg_with_opts(opts:, **)= case args
      in name: name, opts: Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      in opts: Array => arr
        "an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.arg_with_opts(opts: [1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.arg_with_opts(name: 'name', opts: [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(*) definition" do
    class Argumentative
      def search(*) = case args
      in Array => arr
        "an Array eq #{arr.inspect}"
      in name, Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.search([1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.search("name", [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(a, b=nil) definition" do
    class Argumentative
      def some(a, b=nil) = case args
      in Array => arr, _
        "an Array eq #{arr.inspect}"
      in name, Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.some([1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.some("name", [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(a, b=nil, *) definition" do
    class Argumentative
      def many_and_more(a, b=nil, *) = case args
      in Array => arr, _
        "an Array eq #{arr.inspect}"
      in name, Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.many_and_more([1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.many_and_more("name", [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(a, *) definition" do
    class Argumentative
      def more(a, *) = case args
      in Array => arr
        "an Array eq #{arr.inspect}"
      in name, Array => arr
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.more([1,2])).to eq("an Array eq [1, 2]")
    end

    it "when called with a name and an Array" do
      expect(arg.more("name", [1,2])).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(opts, name: 'VALUE') definition" do
    class Argumentative
      def mixed_args(opts, name: 'ASD')= case args
      in Array => arr, { name: 'ASD' }
        "a name \"ASD\" and an Array eq #{arr.inspect}"
      in Array => arr, { name: name }
        "a name #{name.inspect} and an Array eq #{arr.inspect}"
      end
    end

    it "when called with an Array" do
      expect(arg.mixed_args([1,2])).to eq('a name "ASD" and an Array eq [1, 2]')
    end

    it "when called with a name and an Array" do
      expect(arg.mixed_args([1,2], name: 'name')).to eq('a name "name" and an Array eq [1, 2]')
    end
  end

  context "Calling 'case args' on method(a, &block) definition" do
    class Argumentative
      def with_block(a=nil, &block) = case args
      in Integer => num, Proc => bl
        "a number #{num} and a block with #{bl.call}"
      in nil, Proc => bl
        "only a block and a block with #{bl.call}"
      end
    end

    it "when called with a number and a block" do
      expect(arg.with_block(1) { "block" }).to eq('a number 1 and a block with block')
    end

    it "when called with only a block" do
      expect(arg.with_block { "block" }).to eq("only a block and a block with block")
    end
  end
end
