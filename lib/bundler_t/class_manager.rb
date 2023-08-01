# frozen_string_literal: true

require "active_support/inflector"
require_relative "method_manager"

module BundlerT
  # class を作成したり説明を付与したりする。
  class ClassManager

    attr_reader :name, :description, :methods

    # 初期化処理。
    def initialize(content)
      @methods = []

      # name が見つからなかったら error 発生。
      @name = content["name"].camelize
      raise "class name が見つかりません" if @name.nil?

      @description = content["description"]

      # methods が定義されていたら設定する
      # TODO: method の形もいずれ追加したい
      # TODO: method_mabc の形もいずれ追加したい
      unless content["methods"].nil? then
        methods = content["methods"]
        if methods.class == Array then
          methods.each{|method|
            @methods << MethodManager.new(method)
          }
        else
          raise "methods は配列型以外は未実装"
        end
      end
    end

    # lib へ書き出し。
    def write_to_lib(project_name:)
      raise "#{@name}.rb は既に存在します" if FileTest.exist?("#{@name}.rb")

      File.open("#{@name.underscore}.rb", "w"){|output_file|
        output_file.puts "# frozen_string_literal: true"
        output_file.puts ""
        output_file.puts "module #{project_name.camelize}"
        output_file.puts "  # #{@description}" unless @description.nil?
        output_file.puts "  class #{@name.camelize}"

        @methods.each{|method|
          method.write_to_lib(output_file: output_file)
        }

        output_file.puts "  end"
        output_file.puts "end"
      }
    end

    # spec へ雛型を書き出し。
    def write_to_spec(project_name:)
      raise "#{@name}_spec.rb は既に存在します" if FileTest.exist?("#{@name}_spec.rb")

      File.open("#{@name.underscore}_spec.rb", "w"){|output_file|
        output_file.puts "# frozen_string_literal: true"
        output_file.puts ""
        output_file.puts "RSpec.describe #{project_name.camelize}::#{@name} do"
        output_file.puts "  # example '説明文' do"
        output_file.puts "  #   確認したい内容"
        output_file.puts "  # end"
        output_file.puts ""
        output_file.puts "  # example \"TheClassThatDoesNotExist does not exist\" do"
        output_file.puts "  #   expect { TheClassThatDoesNotExist.new }.to raise_error(NameError)"
        output_file.puts "  # end"

        output_file.puts "end"
      }
    end
  end
end
