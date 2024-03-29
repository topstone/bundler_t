# frozen_string_literal: true

require "active_support/inflector"
require "yaml"

module BundlerT
  # 作成予定の method を表す。
  class MethodGenerator
    attr_reader :name, :docstring, :content

    # 文字列または Hash を受け付ける。
    # @param m [Object] method 情報。
    def initialize(m)
      if m.instance_of?(String)
        @name = m
      elsif m.instance_of?(Hash)
        raise "method name が不明です" if m["name"].nil?

        @name = m["name"]
        @docstring = m["docstring"].split(/\R+/) unless m["docstring"].nil?
        @content = m["content"].split(/\R+/) unless m["content"].nil?
      else
        raise "作成予定の method の情報は yaml file 内では String または Hash で書かれている必要があります"
      end
    end

    # 個別 method 生成。
    # @return [Array] method code
    def generate
      strings = []
      @docstring&.each do |l|
        strings << "    # #{l}"
      end
      strings << "    def #{@name}"
      @content&.each do |l|
        strings << "      #{l}"
      end
      strings << "    end"
    end
  end
end
