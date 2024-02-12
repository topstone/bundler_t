# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の内容の編集を担当。
  class Modifier
    attr_accessor :filename, :content

    @@modifiers = []

    # 登録されている全ての files を変数する。
    def self.modify_all(project)
      @@project = project
      @@modifiers.each(&:modify)
    end

    def initialize
      @@modifiers << self
    end

    # file を編集する。
    def modify
      destination = "tmp/origin/#{filename}"
      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.move(filename, destination)
#      File.open(filename, "w") do |f|
#        f.puts @content
#      end
    end
  end
end

# 「replacers」directory に存在する files を全て読み込む
Dir["#{File.dirname(__FILE__)}/modifiers/*.rb"].each { |file| require file }
