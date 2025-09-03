# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/test_classes'

module Lite
  module Data
    RSpec.describe Data do
      describe '#with' do
        let(:original) { TestClassBaseA.new(1, bar: 'BAR') }

        context 'when no parameters are passed in' do
          it 'returns original object' do
            clone = original.with
            expect(clone.equal?(original)).to be(true)
          end
        end

        context 'when parameters identical to current values are passed in' do
          it 'returns original object' do
            clone = original.with(foo: 1, bar: 'BAR')
            expect(clone.equal?(original)).to be(true)
          end
        end

        context 'when parameters different from current values are passed in' do
          it 'updates given parameters' do
            expect(original.with(foo: 2)).to have_attributes(foo: 2, bar: 'BAR')
            expect(original.with(bar: 'bar')).to have_attributes(foo: 1, bar: 'bar')
            expect(original.with(foo: 2, bar: 'bar')).to have_attributes(foo: 2, bar: 'bar')
          end
        end
      end
    end
  end
end
