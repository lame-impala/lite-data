# frozen_string_literal: true

require_relative '../../lib/lite/data'

module Lite
  module Data
    class TestClassBaseA
      Lite::Data.define(self, args: [:foo], kwargs: [:bar])
    end

    class TestClassA < TestClassBaseA
      Lite::Data.define(self, args: %i[* bax], kwargs: %i[qox])
    end

    class TestClassB
      Lite::Data.define(self, args: %i[foo bax], kwargs: %i[bar qox])
    end
  end
end
