# frozen_string_literal: true

require "binding_of_caller/mri"
require "arguments/version"

module Arguments
  PassedArguments = Data.define(:args, :kwargs, :block) do
    def self.with(*args, **kwargs, &block)
      new(args:, kwargs:, block:)
    end

    def empty?
      args.empty? && kwargs.empty? && block.nil?
    end

    def first
      args.first || kwargs.first || block
    end

    def single_value?
      args.size == 1 && kwargs.empty? && block.nil?
    end
      
    def only_kw?
      args.empty? && kwargs.any? && block.nil?
    end

    def matcher
      if empty?
        NoArguments
      elsif single_value?
        first
      elsif only_kw?
        KwArguments[kwargs]
      else
        MixedArguments[args, kwargs.first && KwArguments[kwargs], block]
      end
    end
  end

  KwArguments = Data.define(:kwargs) do
    def deconstruct_keys(_)= kwargs
  end

  MixedArguments = Data.define(:args, :kwargs, :block) do
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

      unless args = (begin caller_env.eval "Arguments(...)"; rescue SyntaxError; nil end)
        arg_names = params
          .map { |type, sym| (type in :keyreq|:key) ?  "#{sym}:" : sym }
          .join(', ')

        args = caller_env.eval "Arguments(#{arg_names})"
      end

      args.matcher
    end
  end
end

def Arguments(...)
  Arguments::PassedArguments.with(...)
end