# frozen_string_literal: true

require "active_support/inflector"
require "fileutils"
require "yaml"

module BundlerT
  # 作成予定の spec を表す。
  class SpecGenerator
    attr_reader :name

    @@specs = []

    # Hash を受け付ける。
    # @param s [Object] spec 情報。
    def initialize(s)
      raise "作成予定の spec の情報は yaml file 内では Hash で書かれている必要があります" unless s.instance_of?(Hash)
      raise "spec name が不明です" if s["name"].nil?

      @name = s["name"]
      raise "spec の内容 (content) が不明です" if s["content"].nil?

      @content = s["content"].split(/\R+/)



      @@specs << self
    end

    # 全 specs 生成。
    # @param project [Project]
    def self.generate_all(project:)
      @@specs.each do |s|
        s.generate(project:)
      end
    end

    # 個別 spec 生成。
    # @param project [Project]
    def generate(project:)
      File.open("spec/#{@name.underscore}_spec.rb", "w") do |f|
        f.puts "# frozen_string_literal: true"
        f.puts ""
        f.puts "RSpec.describe #{project.name.camelize} do"
        f.puts "  describe '#{@name}' do"
        @content.each do |l|
          f.puts "    #{l}"
        end
        f.puts "  end"
        f.puts "end"
      end
    end
  end
end
