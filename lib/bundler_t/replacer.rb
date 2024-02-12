# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の置き換えを担当。
  class Replacer

    attr_accessor :filename, :content

    @@replacers = []

    # 登録されている全ての files を置き換える。
    def self.replace_all
      @@replacers.each do |replacer|
        replacer.replace
      end
    end

    def initialize
      @@replacers << self
    end

    def replace
      destination = "tmp/origin/" + filename
      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.move(filename, destination)
      File.open(filename, "w") do |f|
        f.puts @content
      end
    end
  end
end

# 「replacers」directory に存在する files を全て読み込む
Dir[File.dirname(__FILE__) + "/replacers/*.rb"].each {|file| require file }
