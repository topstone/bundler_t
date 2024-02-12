# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の内容の編集を担当。
  class Modifier
    attr_accessor :filename, :hooks

    @@modifiers = []
    @@project = nil

    # 登録されている全ての files を変数する。
    def self.modify_all(project: nil)
      @@project = project
      @@modifiers.each(&:modify)
    end

    # 依頼元の project
    def self.project
      @@project
    end

    def initialize
      @hooks = {}
      @@modifiers << self
    end

    # file を編集する。
    def modify
      fname = filename.gsub(/__projectname__/, Modifier.project.name)
      destination = "tmp/origin/#{fname}"
      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.move(fname, destination)
      File.open(destination, "r") do |d|
      File.open(fname, "w") do |f|
        d.each_line do |line|
        hooked = false
        @hooks.each do |rexp, output|
          if line.match?(rexp) then
            f.puts output.gsub("__TargetRubyVersion__", BundlerT::TargetRubyVersion)
            hooked = true
          end
        end
        f.puts line unless hooked
        end
      end
      end
    end
  end
end

# 「replacers」directory に存在する files を全て読み込む
Dir["#{File.dirname(__FILE__)}/modifiers/*.rb"].each { |file| require file }
