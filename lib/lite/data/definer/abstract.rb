# frozen_string_literal: true

require_relative '../marker'

module Lite
  module Data
    module Definer
      module Abstract
        def define(members)
          Module.new do
            extend Marker

            attr_reader(*members.members)

            class_eval <<~RUBY, __FILE__, __LINE__ + 1
              def self.members
                [#{members.members.map { ":#{_1}" }.join(', ')}]
              end

              def deconstruct
                #{members.ivars_array}
              end

              def to_h
                { #{members.hash_fields} }
              end
            RUBY
          end
        end
      end
    end
  end
end
