# frozen_string_literal: true

require_relative 'abstract'

module Lite
  module Data
    module Definer
      module Members
        class Base < Abstract
          def self.instance(positional_arguments, keyword_arguments)
            super(
              positional_arguments,
              keyword_arguments,
              positional_arguments + keyword_arguments
            )
          end

          def initialize_signature
            (positional_arguments + keyword_arguments.map { "#{_1}:" }).join(', ')
          end

          def keyword_signature_defaults
            members.map { "#{_1}: @#{_1}" }.join(', ')
          end

          def constructor_arguments
            (positional_arguments + keyword_arguments.map { "#{_1}: #{_1}" }).join(', ')
          end

          def ivars_array
            "[#{members.map { " @#{_1}" }.join(', ')}]"
          end

          def positional_arguments_array
            "[#{positional_arguments.join(', ')}]"
          end

          def keyword_arguments_hash
            "{ #{keyword_arguments.map { "#{_1}: #{_1}" }.join(', ')} }"
          end

          def merged_constructor_arguments_signature
            ['identical', members.map { "#{_1}: @#{_1}" }].join(', ')
          end

          def merged_constructor_arguments
            "#{positional_arguments_array}, #{keyword_arguments_hash}"
          end

          def hash_fields
            members.map { "#{_1}: @#{_1}" }.join(', ')
          end

          def equality
            members.map { "#{_1} == other.#{_1}" }.join(' && ')
          end

          def hash_equality
            members.map { "#{_1}.eql?(other.#{_1})" }.join(' && ')
          end
        end
      end
    end
  end
end
