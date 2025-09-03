# frozen_string_literal: true

require_relative 'abstract'
require_relative 'members/subclass'

module Lite
  module Data
    module Definer
      module Subclass
        extend Abstract

        module InstanceMethods
          def with(**opts)
            return self if opts.empty?

            identical, args, opts = merged_constructor_arguments(true, **opts)
            return self if identical

            self.class.send(:new, *args, **opts)
          end
        end

        def self.define(positional_arguments, keyword_arguments) # rubocop:disable Metrics/MethodLength
          members = Members::Subclass.instance(positional_arguments, keyword_arguments)
          mod = super(members)

          mod.include InstanceMethods

          mod.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            def initialize(#{members.initialize_signature})
              #{members.initialize_ivars}
              super *args, **opts
            end

            def ==(other)
              #{members.equality}
            end

            def eql?(other)
              #{members.hash_equality}
            end

            def hash
              [#{['super', *members.members].join(', ')}].hash
            end

            private

            def merged_constructor_arguments(#{members.merged_constructor_arguments_signature})
              identical &&= #{members.variables_equal_attributes}

              return true if identical && opts.empty?
              identical, args, opts = super(identical, **opts)
              return true if identical

              [false, #{members.merged_constructor_arguments}]
            end
          RUBY

          mod
        end

        def self.define_class_methods(base, mod)
          base.define_singleton_method(:members) { super() + mod.members }
        end
      end
    end
  end
end
