# frozen_string_literal: true

require_relative 'data/definer/base'
require_relative 'data/definer/subclass'

module Lite
  module Data
    private_constant :Definer

    def self.define(base, args: [], kwargs: [])
      supermod = base.ancestors.find { |klass| klass.is_a?(Marker) }
      prevent_conflicts!(base, args, kwargs) if supermod

      definer = supermod ? Definer::Subclass : Definer::Base
      mod = definer.define(args, kwargs)
      definer.define_class_methods(base, mod)
      base.include(mod)
      nil
    end

    def self.prevent_conflicts!(klass, args, kwargs)
      duplicates = klass.members & (args + kwargs)
      raise Error, "Members already declared: #{duplicates.map(&:inspect).join(', ')}" unless duplicates.empty?
    end
  end
end
