# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/test_classes'

module Lite
  module Data
    RSpec.describe Data do
      let(:data) { TestClassA.new(1, :BAX, bar: 'BAR', qox: '5') }
      let(:expected_string) { '#<data Lite::Data::TestClassA foo=1, bar="BAR", bax=:BAX, qox="5">' }

      describe '#inpect' do
        it 'returns a string representation of self' do
          expect(data.inspect).to eq(expected_string)
        end
      end

      describe '#to_s' do
        it 'returns a string representation of self' do
          expect(data.to_s).to eq(expected_string)
        end
      end
    end
  end
end
