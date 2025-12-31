# frozen_string_literal: true

require "binding_of_caller/mri"
require "args_matcher/version"

module ArgsMatcher
  def self.args(...) = PassedArguments.for(...)

  PassedArguments = Data.define(:args, :kwargs, :block) do
    def self.for(*args, **kwargs, &block)
      new(args:, kwargs:, block:)
    end

    def first = args.first || kwargs.first || block
    def empty? = args.empty? && kwargs.empty? && block.nil?
    def only_kw? = args.empty? && kwargs.any? && block.nil?
    def single_value? = args.size == 1 && kwargs.empty? && block.nil?

    def matcher
      if empty?
        NoArguments
      elsif single_value?
        first
      elsif only_kw?
        Keywords[kwargs]
      else
        Arguments[args, kwargs.first && Keywords[kwargs], block]
      end
    end
  end

  Keywords = Data.define(:kwargs) do
    def deconstruct_keys(_)= kwargs
  end

  Arguments = Data.define(:args, :kwargs, :block) do
    def deconstruct
      args + [kwargs, block].compact
    end
  end

  NoArguments = Object.new.freeze

  module Matcher
    def args
      caller_env = binding.of_caller(1)
      sender = caller_env.receiver

      caller_method_name = (caller[0][/[#\.]([^']*)'$/, 1]).to_sym #Horrible hack
      params = sender.method(caller_method_name).parameters

      args = (begin caller_env.eval "::ArgsMatcher.args(...)"; rescue SyntaxError; nil end) ||
        params
          .map { |type, sym| (type in :keyreq|:key) ?  "#{sym}:" : sym }
          .join(', ')
          .then { caller_env.eval "::ArgsMatcher.args(#{it})"}

      args.matcher
    end
  end
end