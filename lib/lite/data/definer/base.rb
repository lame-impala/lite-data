# frozen_string_literal: true

require_relative 'abstract'
require_relative 'members/base'

module Lite
  module Data
    module Definer
      module Base
        extend Abstract

        module InstanceMethods
          def deconstruct_keys(members)
            case members
            when nil then to_h
            else to_h.slice(*members)
            end
          end

          def inspect
            "#<data #{self.class.name} #{to_h.map { |k, v| "#{k}=#{v.inspect}" }.join(', ')}>"
          end

          def to_s
            inspect
          end
        end

        def self.define(positional_arguments, keyword_arguments) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          members = Members::Base.instance(positional_arguments, keyword_arguments)
          mod = super(members)

          mod.include InstanceMethods

          mod.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            def initialize(#{members.initialize_signature})
              #{members.initialize_ivars}
              freeze
            end

            def ==(other)
              return true if self.equal?(other)
              return false unless self.class == other.class

              #{members.equality}
            end

            def eql?(other)
              return true if self.equal?(other)
              return false unless self.class == other.class

              #{members.hash_equality}
            end

            def hash
              [#{['self.class', *members.members].join(', ')}].hash
            end

            def with(#{members.keyword_signature_defaults})
              return self if #{members.variables_equal_attributes}

              self.class.send(#{[':new', *members.constructor_arguments].join(', ')})
            end

            private

            def merged_constructor_arguments(#{members.merged_constructor_arguments_signature})
              identical &&= #{members.variables_equal_attributes}
              return identical if identical

              [false, #{members.merged_constructor_arguments}]
            end
          RUBY

          mod
        end

        def self.define_class_methods(base, mod)
          base.define_singleton_method(:members) { mod.members }
        end
      end
    end
  end
end
