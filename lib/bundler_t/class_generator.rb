# frozen_string_literal: true

require "active_support/inflector"
require "yaml"

module BundlerT
  # 作成予定の class を表す。
  class ClassGenerator
    attr_reader :name

    # class 作成。
    # 文字列または Hash を受け付ける。
    # @param c  [Object] class 情報。
    def initialize(c)
      if c.instance_of?(String)
        @name = c
      elsif c.instance_of?(Hash)
        raise "class name が不明です" if c["name"].nil?

        @name = c["name"]
      else
        raise "作成予定の class の情報は yaml file 内では String または Hash で書かれている必要があります"
      end
    end
  end
end
