# frozen_string_literal: true

require "active_support/inflector"
require "fileutils"
require "yaml"

module BundlerT
  # 作成予定の file を表す。
  class ExeGenerator
    attr_reader :name

    @@exes = []

    # Hash を受け付ける。
    # @param e [Object] file 情報。
    def initialize(e)
      raise "作成予定の exe の情報は yaml file 内では Hash で書かれている必要があります" unless e.instance_of?(Hash)
      raise "exe name が不明です" if e["name"].nil?

      @name = e["name"]
      raise "exe の内容 (content) が不明です" if f["content"].nil?

      @content = f["content"].split(/\R+/)



      @@exes << self
    end

    # 全 exes 生成。
    # @param project [Project]
    def self.generate_all(project:)
      @@exes.each do |e|
        e.generate(project:)
      end
    end

    # 個別 exe 生成。
    # @param project [Project]
    def generate(project:)
      File.open("exe/#{@name}", "w") do |f|
        @content.each do |l|
          f.puts l
        end
      end
    end
  end
end
