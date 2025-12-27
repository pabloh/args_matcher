# frozen_string_literal: true

require "pry"

require 'binding_of_caller/mri'

Arguments = Data.define(:args, :kwargs, :block) do
  def self.with(*args, **kwargs, &block)
    Arguments.new(args:, kwargs:, block:).tap do |a|
      #binding.pry
    end
  end

  private def instance_variables_to_inspect = %i[@args @kwargs @block].freeze

  def deconstruct
    #binding.pry
    if args.empty?
      NoArguments
    else
      args
    end
  end
end

class Arguments
  NoArguments = Object.new.freeze

  module Matcher
    def __args__
      caller_env = binding.of_caller(1)
      sender = caller_env.receiver

      caller_method_name = (caller[0][/#([^']*)'/, 1]).to_sym
      params = sender.method(caller_method_name).parameters

      case params
      in [[:rest, arg_rest]]
        caller_env.eval "Arguments.with(#{arg_rest})"
      end
    end

    #alias_method :args, :__args__
  end
end

def Arguments(...)
  Arguments.with(...)
end
