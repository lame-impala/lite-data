# frozen_string_literal: true

require_relative 'abstract'

module Lite
  module Data
    module Definer
      module Members
        class Subclass < Abstract
          def self.instance(positional_arguments, keyword_arguments)
            positional_arguments = [*positional_arguments, :*] unless positional_arguments.include? :*

            super(
              positional_arguments,
              keyword_arguments,
              (positional_arguments.reject { _1 == :* } + keyword_arguments)
            )
          end

          attr_reader :positional_arguments, :keyword_arguments, :members

          def interpolated_positional_arguments(replacement)
            positional_arguments.map { _1 == :* ? replacement : _1 }
          end

          def initialize_signature
            [
              *interpolated_positional_arguments('*args'),
              *keyword_arguments.map { "#{_1}:" },
              '**opts'
            ].join(', ')
          end

          def ivars_array
            "[*super, #{members.map { "@#{_1}" }.join(', ')}]"
          end

          def merged_constructor_arguments_signature
            ['identical', members.map { "#{_1}: @#{_1}" }, '**opts'].join(', ')
          end

          def merged_constructor_arguments
            positional = interpolated_positional_arguments('*args').join(', ')
            keyword = [*keyword_arguments.map { "#{_1}: #{_1}" }, '**opts'].join(', ')
            "[#{positional}], { #{keyword} }"
          end

          def hash_fields
            ['**super', *members.map { "#{_1}: @#{_1}" }].join(', ')
          end

          def equality
            ['super', *members.map { "#{_1} == other.#{_1}" }].join(' && ')
          end

          def hash_equality
            ['super', *members.map { "#{_1}.eql?(other.#{_1})" }].join(' && ')
          end
        end
      end
    end
  end
end
