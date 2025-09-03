# frozen_string_literal: true

require 'spec_helper'

require_relative '../support/readme_helper'
require_relative '../../lib/lite/data'

module Lite
  module Data
    describe 'README' do
      # rubocop:disable Security/Eval
      context 'when describing class definition' do
        it 'describes the process correctly' do # rubocop:disable RSpec/NoExpectationExample
          eval(ReadmeHelper.snippet!(:definition_superclass))
          eval(ReadmeHelper.snippet!(:definition_subclass))
          eval(ReadmeHelper.snippet!(:definition_argument_positioning))
          eval(ReadmeHelper.snippet!(:introspection_deconstruct))
        end
      end
      # rubocop:enable Security/Eval
    end
  end
end
