# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/lite/data'

module Lite
  module Data
    class TestBase
      Data.define(self, args: [:pos_base], kwargs: [:kw_base])
    end

    class TestSubclassPosOnly < TestBase
      Data.define(self, args: [:pos_sub])
    end

    class TestSubclassKwOnly < TestBase
      Data.define(self, kwargs: [:kw_sub])
    end

    class TestSubclassPosreorder < TestBase
      Data.define(self, args: %i[pos_sub1 * pos_sub2], kwargs: [:kw_sub])
    end

    RSpec.describe Data do
      context 'when subclass redefines existing member' do
        it 'raises error' do
          expect { Class.new(TestBase) { Data.define(self, args: [:pos_base]) } }
            .to raise_error(Error, 'Members already declared: :pos_base')
        end
      end

      context 'when subclass defines only positional argument' do
        let(:data) { TestSubclassPosOnly.new('ps', 'pb', kw_base: 'kwb') }

        describe '#to_h' do
          it 'returns correct hash' do
            expect(data.to_h).to eq({ pos_base: 'pb', kw_base: 'kwb', pos_sub: 'ps' })
          end
        end

        describe '#with' do
          it 'returns updated object' do
            expect(data.with(pos_sub: 'ps1', kw_base: 'kwb1'))
              .to have_attributes(pos_base: 'pb', kw_base: 'kwb1', pos_sub: 'ps1')
          end
        end
      end

      context 'when subclass defines only keyword argument' do
        let(:data) { TestSubclassKwOnly.new('pb', kw_base: 'kwb', kw_sub: 'kws') }

        describe '#to_h' do
          it 'returns correct hash' do
            expect(data.to_h).to eq({ pos_base: 'pb', kw_base: 'kwb', kw_sub: 'kws' })
          end
        end

        describe '#with' do
          it 'returns updated object' do
            expect(data.with(pos_base: 'pb1', kw_sub: 'kws1'))
              .to have_attributes(pos_base: 'pb1', kw_base: 'kwb', kw_sub: 'kws1')
          end
        end
      end

      context 'when subclass puts existing positional arguments between new ones' do
        let(:data) { TestSubclassPosreorder.new('ps1', 'pb', 'ps2', kw_base: 'kwb', kw_sub: 'kws') }

        describe '#to_h' do
          it 'returns correct hash' do
            expect(data.to_h)
              .to eq({ pos_base: 'pb', kw_base: 'kwb', pos_sub1: 'ps1', pos_sub2: 'ps2', kw_sub: 'kws' })
          end
        end

        describe '#with' do
          context 'when updating subclass attributes' do
            it 'returns object with correctly updated attributes' do
              expect(data.with(pos_sub1: 'PS1', pos_sub2: 'PS2', kw_sub: 'KWS'))
                .to have_attributes(pos_base: 'pb', kw_base: 'kwb', pos_sub1: 'PS1', pos_sub2: 'PS2', kw_sub: 'KWS')
            end
          end

          context 'when updating superclass attributes' do
            it 'returns object with correctly updated attributes' do
              expect(data.with(pos_base: 'PB', kw_base: 'KWB'))
                .to have_attributes(pos_base: 'PB', kw_base: 'KWB', pos_sub1: 'ps1', pos_sub2: 'ps2', kw_sub: 'kws')
            end
          end

          context 'when updating all attributes' do
            it 'returns object with correctly updated attributes' do
              expect(data.with(pos_base: 'PB', kw_base: 'KWB', pos_sub1: 'PS1', pos_sub2: 'PS2', kw_sub: 'KWS'))
                .to have_attributes(pos_base: 'PB', kw_base: 'KWB', pos_sub1: 'PS1', pos_sub2: 'PS2', kw_sub: 'KWS')
            end
          end

          context 'when parameters identical to current values are passed in' do
            it 'returns original object' do
              clone = data.with(pos_base: 'pb', kw_base: 'kwb', pos_sub1: 'ps1', pos_sub2: 'ps2', kw_sub: 'kws')
              expect(clone.equal?(data)).to be(true)
            end
          end
        end
      end
    end
  end
end
