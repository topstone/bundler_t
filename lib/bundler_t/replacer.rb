# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の置き換えを担当。
  class Replacer
    attr_accessor :filename, :content

    @@replacers = []
    @@project = nil

    # 登録されている全ての files を置き換える。
    def self.replace_all(project: nil)
      @@project = project
      @@replacers.each(&:replace)
    end

    # 依頼元の project
    def self.project
      @@project
    end

    def initialize
      @@replacers << self
    end

    # file を置き換える。
    def replace
      fname = filename.gsub("__projectname__", Replacer.project.name)
      destination = "tmp/origin/#{fname}"
      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.move(fname, destination)
      File.open(fname, "w") do |f|
        f.puts @content
      end
    end
  end
end

# 「replacers」directory に存在する files を全て読み込む
Dir["#{File.dirname(__FILE__)}/replacers/*.rb"].each { |file| require file }
