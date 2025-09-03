# frozen_string_literal: true

require_relative '../../error'

module Lite
  module Data
    module Definer
      module Members
        class Abstract
          def self.instance(positional_arguments, keyword_arguments, members)
            ensure_members_valid!(members)
            new positional_arguments, keyword_arguments, members
          end

          def self.ensure_members_valid!(members)
            raise Error, 'Members must not be empty' if members.empty?

            invalid = members.reject { _1.is_a?(Symbol) }
            raise Error, "Array of symbols expected, got: #{invalid.map(&:inspect).join(', ')}" unless invalid.empty?

            uniq = members.uniq
            raise Error, 'Member names must be unique' unless uniq.length == members.length
          end

          def initialize(positional_arguments, keyword_arguments, members)
            @positional_arguments = positional_arguments.freeze
            @keyword_arguments = keyword_arguments.freeze
            @members = members.freeze
            freeze
          end

          attr_reader :positional_arguments, :keyword_arguments, :members

          def initialize_ivars
            members.map { "@#{_1} = #{_1}" }.join(';')
          end

          def variables_equal_attributes
            members.map { "#{_1} == @#{_1}" }.join(' && ')
          end
        end
      end
    end
  end
end
