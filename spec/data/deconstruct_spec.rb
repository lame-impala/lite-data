# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/test_classes'

module Lite
  module Data
    RSpec.describe Data do
      let(:data) { TestClassA.new(1, :BAX, bar: 'BAR', qox: '5') }

      describe '.members' do
        it 'returns array of members' do
          expect(TestClassA.members).to eq(%i[foo bar bax qox])
        end
      end

      describe '#deconstruct' do
        it 'returns member values in order of definition' do
          expect(data.deconstruct).to eq([1, 'BAR', :BAX, '5'])
        end

        it 'is usable for pattern matching' do
          result = case data
                   in _foo, 'BAR', _bax, qox then qox
          end

          expect(result).to eq('5')
        end
      end

      describe '#deconstruct_keys' do
        context 'with nil parameter' do
          it 'returns hash of members' do
            expect(data.deconstruct_keys(nil)).to eq({ foo: 1, bar: 'BAR', bax: :BAX, qox: '5' })
          end
        end

        context 'with list of names as a parameter' do
          it 'returns hash of members' do
            expect(data.deconstruct_keys(%i[foo bax])).to eq({ foo: 1, bax: :BAX })
          end
        end

        it 'is usable for pattern matching' do
          result = case data
                   in foo:, bar: 'BAX' then foo
                   in bar: 'BAR', qox: then qox
          end

          expect(result).to eq('5')
        end
      end

      describe '#to_h' do
        it 'returns hash of members' do
          expect(data.to_h).to eq({ foo: 1, bar: 'BAR', bax: :BAX, qox: '5' })
        end
      end
    end
  end
end
