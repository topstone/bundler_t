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
      destination = "tmp/" + filename
      FileUtils.mkdir_p(File.dirname(desination))
      FileUtils.move(filename, destination)
    end
  end
end

# 「replacers」directory に存在する files を全て読み込む
Dir[File.dirname(__FILE__) + "/replacers/*.rb"].each {|file| require file }
