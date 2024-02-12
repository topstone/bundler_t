# frozen_string_literal: true

require "active_support/inflector"
require "digest/sha2"
require "fileutils"
require "yaml"

module BundlerT
  # 作成予定の class を表す。
  class ClassGenerator
    attr_reader :name, :methods

    @@classes = [] # project.rb の classes と重複するので後で修正予定

    # 文字列または Hash を受け付ける。
    # @param c [Object] class 情報。
    def initialize(c)
      @methods = []
      if c.instance_of?(String)
        @name = c
      elsif c.instance_of?(Hash)
        raise "class name が不明です" if c["name"].nil?
        @name = c["name"]
        unless c["docstring"].nil?
          @docstring = c["docstring"].split(/\R+/)
        end
        unless c["beginning"].nil?
          @beginning = c["beginning"].split(/\R+/)
        end
        unless c["methods"].nil?
          c["methods"].each do |m|
            @methods << MethodGenerator.new(m)
          end
        end
      else
        raise "作成予定の class の情報は yaml file 内では String または Hash で書かれている必要があります"
      end
      @@classes << self
    end

    # 全 classes 生成。
    # @param project [Project]
    # @return [Array] lib 直下向け require_relative の複数文字列。
    def self.generate_all(project:)
      requires = []
      @@classes.each do |c|
        requires << c.generate(project:)
      end
      requires
    end

    # 個別 class 生成。
    # @param project [Project]
    # @return [String] lib 直下向け require_relative の文字列。
    def generate(project:)
      File.open("lib/#{project.name.underscore}/#{name.underscore}.rb", "w") do |f|
        f.puts "# frozen_string_literal: true"
        f.puts ""
        f.puts "module #{project.name.camelize}"
        unless @docstring.nil?
          @docstring.each do |l|
            f.puts "  # #{l}"
          end
        end
        f.puts "  class #{name.camelize}"
        f.puts ""
        unless @beginnin.nil?
          @beginning.each do |l|
            f.puts "    #{l}"
          end
        end
        f.puts ""
        unless @methods.empty?
          @methods.each do |m|
            m.generate.each do |l|
              f.puts l
            end
          end
        end
        f.puts "  end"
        f.puts "end"
      end

      FileUtils.mkdir_p("spec/#{project.name.underscore}")
      File.open("spec/#{project.name.underscore}/#{name.underscore}_spec.rb", "w") do |f|
        ghost_class = name.camelize + (Digest::SHA512.new.update(name).to_s)[0..8]
        f.puts "# frozen_string_literal: true"
        f.puts ""
        f.puts "RSpec.describe #{project.name.camelize}::#{name.camelize} do"
        f.puts "  it \"「#{name.camelize}」class が存在すること\" do"
        f.puts "    expect(described_class).to be_a(Object)"
        f.puts "  end"
        f.puts ""
        f.puts "  it \"「#{ghost_class}」class が存在しないこと\" do"
        f.puts "    expect{ #{ghost_class} }.to raise_error NameError"
        f.puts "  end"
        f.puts "end"
      end

      "require_relative \"#{project.name.underscore}/#{name.underscore}\""
    end
  end
end
