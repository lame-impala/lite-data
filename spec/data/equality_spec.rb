# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/test_classes'

module Lite
  module Data
    RSpec.describe Data do
      describe '#==, #eql?, #hash' do
        let(:lhs) { TestClassA.new(1, :BAX, bar: 'BAR', qox: 7) }

        context 'when object is compared to self' do
          context 'with equal significant values' do
            let(:rhs) { lhs }

            it 'is equal' do
              expect(lhs).to eq(rhs)
            end

            it 'is equal hash key' do
              expect(lhs.eql?(rhs)).to be(true)
            end

            it 'is has identical hash' do
              expect(lhs.hash).to eq(rhs.hash)
            end
          end
        end

        context 'when compared object is of a different class' do
          context 'with equal significant values' do
            let(:rhs) { TestClassB.new(1, :BAX, bar: 'BAR', qox: 7) }

            it 'is not equal' do
              expect(lhs).not_to eq(rhs)
            end

            it 'is not equal hash key' do
              expect(lhs.eql?(rhs)).to be(false)
            end

            it 'is has different hash' do
              expect(lhs.hash).not_to eq(rhs.hash)
            end
          end

          context 'with different definition' do
            let(:rhs) { TestClassBaseA.new(1, bar: 'BAR') }

            it 'is not equal' do
              expect(lhs).not_to eq(rhs)
            end

            it 'is not equal hash key' do
              expect(lhs.eql?(rhs)).to be(false)
            end

            it 'is has different hash' do
              expect(lhs.hash).not_to eq(rhs.hash)
            end
          end
        end

        context 'when compared object is the same class' do
          context 'with equal significant values' do
            let(:rhs) { TestClassA.new(1, :BAX, bar: 'BAR', qox: 7) }

            it 'is equal' do
              expect(lhs).to eq(rhs)
            end

            it 'is equal hash key' do
              expect(lhs.eql?(rhs)).to be(true)
            end

            it 'is has identical hash' do
              expect(lhs.hash).to eq(rhs.hash)
            end
          end

          context 'with significant values that are equal after conversion' do
            context 'when attributes defined in superclass are of different type' do
              let(:rhs) { TestClassA.new(1.0, :BAX, bar: 'BAR', qox: 7) }

              it 'is equal' do
                expect(lhs).to eq(rhs)
              end

              it 'is not equal hash key' do
                expect(lhs.eql?(rhs)).to be(false)
              end

              it 'is has different hash' do
                expect(lhs.hash).not_to eq(rhs.hash)
              end
            end

            context 'when attributes defined in subclass are of different type' do
              let(:rhs) { TestClassA.new(1, :BAX, bar: 'BAR', qox: 7.0) }

              it 'is equal' do
                expect(lhs).to eq(rhs)
              end

              it 'is not equal hash key' do
                expect(lhs.eql?(rhs)).to be(false)
              end

              it 'is has different hash' do
                expect(lhs.hash).not_to eq(rhs.hash)
              end
            end
          end

          context 'with different significant values' do
            context 'when attributes defined in superclass are different' do
              let(:rhs) { TestClassA.new(2, :BAX, bar: 'BAR', qox: 7) }

              it 'is not equal' do
                expect(lhs).not_to eq(rhs)
              end

              it 'is not equal hash key' do
                expect(lhs.eql?(rhs)).to be(false)
              end

              it 'is has different hash' do
                expect(lhs.hash).not_to eq(rhs.hash)
              end
            end

            context 'when attributes defined in subclass are different' do
              let(:rhs) { TestClassA.new(1, :BAX, bar: 'BAR', qox: 8) }

              it 'is not equal' do
                expect(lhs).not_to eq(rhs)
              end

              it 'is not equal hash key' do
                expect(lhs.eql?(rhs)).to be(false)
              end

              it 'is has different hash' do
                expect(lhs.hash).not_to eq(rhs.hash)
              end
            end
          end
        end
      end
    end
  end
end
