# frozen_string_literal: true

require 'benchmark'
require 'byebug'

require_relative '../lib/lite/data'

module Lite
  module Data
    module Benchmark
      module Comparative
        module Abstract
          def instantiate(opts)
            self::Data.new(**opts)
          end

          def clone(original, opts)
            original.with(**opts.compact)
          end
        end

        module RubyBase
          extend Abstract

          Data = ::Data.define(:foo, :bar, :bax, :qox)
        end

        module LiteBase
          extend Abstract

          class Data
            Lite::Data.define(self, kwargs: %i[foo bar bax qox])
          end
        end

        module LiteSubclass
          extend Abstract

          class Super
            Lite::Data.define(self, kwargs: %i[foo bar])
          end

          class Data < Super
            Lite::Data.define(self, kwargs: %i[bax qox])
          end
        end

        SYMBOLS = %i[a b c d e f g h i j].freeze

        def self.run(n, duplicity: 0) # rubocop:disable Naming/MethodParameterName, Metrics/AbcSize
          subjects = [RubyBase, LiteBase, LiteSubclass]

          original_opts = opts
          idata = 10_000.times.map { Random.rand < duplicity ? original_opts : opts }
          cdata = idata.map(&:compact)

          subjects.to_a.each do |subject|
            result = ::Benchmark.measure do
              n.times { |idx| subject.instantiate(idata[idx % idata.length]) }
            end
            puts "#{subject.name} NEW: #{result}"

            original = subject.instantiate(original_opts)
            result = ::Benchmark.measure do
              n.times do |idx|
                subject.clone(original, cdata[idx % cdata.length])
              end
            end
            puts "#{subject.name} CLONE: #{result}"
          end
        end

        def self.opts
          { foo: rand, bar: rand, bax: rand, qox: rand }
        end

        def self.rand
          SYMBOLS[Random.rand(11)]
        end
      end
    end
  end
end

Lite::Data::Benchmark::Comparative.run(100_000, duplicity: 0.1)
