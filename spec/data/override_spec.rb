# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/lite/data'

module Lite
  module Data
    class OverrideBase
      Data.define(self, args: [:pos_base], kwargs: [:kw_base])
    end

    class OverrideSubclass < OverrideBase
      Data.define(self, args: [:pos_sub], kwargs: [:kw_sub])

      def initialize(pos_sub, *args, kw_sub: 'KWs', **opts)
        @memo = {}

        super(pos_sub.to_sym, *args, kw_sub: kw_sub, **opts)
      end

      attr_accessor :memo
    end

    RSpec.describe Data do
      let(:data) { OverrideSubclass.new('Ps', 1, kw_base: 'KWb') }

      context 'when parameter is transformed in initializer' do
        it 'initializes corresponding ivar with transformed value' do
          expect(data.pos_sub).to eq(:Ps)
        end
      end

      context 'when parameter has default defined in initializer' do
        context 'when parameter is not passed into the constructor' do
          it 'initializes corresponding ivar with the default' do
            expect(data.kw_sub).to eq('KWs')
          end
        end
      end

      describe '#==' do
        context 'when non-significant ivar is defined in initializer' do
          it "doesn't consider non significant ivar" do
            data.memo[:foo] = 'bar'
            clone = data.with(kw_base: 'KWa').with(kw_base: 'KWb')
            expect(data.memo).not_to eq(clone.memo)
            expect(data).to eq(clone)
          end
        end
      end
    end
  end
end
