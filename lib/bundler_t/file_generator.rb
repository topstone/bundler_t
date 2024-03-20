# frozen_string_literal: true

require "active_support/inflector"
require "fileutils"
require "yaml"

module BundlerT
  # 作成予定の file を表す。
  class FileGenerator
    attr_reader :name

    @@files = []

    # Hash を受け付ける。
    # @param f [Object] file 情報。
    def initialize(f)
      raise "作成予定の file の情報は yaml file 内では Hash で書かれている必要があります" unless f.instance_of?(Hash)
      raise "file name が不明です" if f["name"].nil?

      @name = f["name"]
      raise "file の内容 (content) が不明です" if f["content"].nil?

      @content = f["content"].split(/\R+/)



      @@files << self
    end

    # 全 files 生成。
    # @param project [Project]
    def self.generate_all(project:)
      @@files.each do |f|
        f.generate(project:)
      end
    end

    # 個別 file 生成。
    # @param project [Project]
    def generate(project:)
      File.open("spec/#{@name}", "w") do |f|
        @content.each do |l|
          f.puts l
        end
      end
    end
  end
end
