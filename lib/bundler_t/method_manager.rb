# frozen_string_literal: true

require "active_support/inflector"
require_relative "parameter_manager"

module BundlerT
  # method を作成したり説明を付与したりする。
  class MethodManager

    attr_reader :name, :description

    # 初期化処理。
    def initialize(content)
      @parameters = []

      # name が見つからなかったら error 発生。
      @name = content["name"].underscore
      raise "method name が見つかりません" if @name.nil?

      @description = content["description"]

      # parameters が定義されていたら設定する
      # TODO: parameter の形もいずれ追加したい
      # TODO: parameter_rabc の形もいずれ追加したい
      unless content["parameters"].nil? then
        parameters = content["parameters"]
        if parameters.class == Array then
          parameters.each{|parameter|
            @parameters << ParameterManager.new(parameter)
          }
        else
          raise "parameters は配列型以外は未実装"
        end
      end
    end

    # lib へ書き出し。
    def write_to_lib(output_file:)
      # 全ての引数を1行に
      in_line = []
      @parameters.each{|parameter|
        in_line << parameter.write_in_line
      }

      output_file.puts ""
      output_file.puts "    # #{@description}" unless @description.nil?

      @parameters.each{|parameter|
        parameter.write_for_yaml(output_file: output_file)
      }

      if in_line == [] then
        output_file.puts "    def #{@name}"
      else
        output_file.puts "    def #{@name}(#{in_line.join(", ")})"
      end
      output_file.puts "    end"
    end
  end
end
