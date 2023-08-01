# frozen_string_literal: true

require "active_support/inflector"

module BundlerT
  # 引数を作成したり説明を付与したりする。
  class ParameterManager

    attr_reader :name, :description, :default_value, :type

    # 初期化処理。
    def initialize(content)
      # name が見つからなかったら error 発生。
      @name = content["name"].underscore
      raise "parameter name が見つかりません" if @name.nil?

      @description = content["description"]

      @default_value = content["default"]

      @type = content["type"]
    end

    # 説明文を書き出す。
    def write_for_yaml(output_file:)
      unless @type.nil? then
        output_file.puts "    # @param #{@name} [#{@type}] #{@description}"
      end
    end

    # 引数形式で書き出す。
    def write_in_line
      if @default_value.nil? then
        return "#{@name}:"
      elsif @type == "String" then
        return "#{@name}: \"#{@default_value}\""
      else
        return "#{@name}: #{@default_value}"
      end
    end
  end
end
