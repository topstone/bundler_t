# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の内容の編集を担当。
  class Modifier
    attr_accessor :filename, :hooks

    @@modifiers = []
    @@project = nil

    # 登録されている全ての files を変数する。
    # @param project [Project] 作成されるべき project
    # @param requires [Array] lib 直下向け require_relative の複数文字列。
    def self.modify_all(project: nil, requires: [])
      @@project = project
      @@modifiers.each do |modifier|
        modifier.modify(requires: requires)
      end
    end

    # 依頼元の project
    # @return [Project] 依頼元の project。
    def self.project
      @@project
    end

    def initialize
      @hooks = {}
      @@modifiers << self
    end

    # file を編集する。
    # @param requires [Array] lib 直下向け require_relative の複数文字列。
    def modify(requires: [])
      fname = filename.gsub("__projectname__", Modifier.project.name)
      destination = "tmp/origin/#{fname}"
      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.move(fname, destination)
      File.open(destination, "r") do |d|
        File.open(fname, "w") do |f|
          d.each_line do |line|
            hooked = false
            @hooks.each do |rexp, output|
              next unless line.match?(rexp.gsub("__projectname__", Modifier.project.name.camelize))

              case output
              when "__requires__"
                f.puts "require_relative \"#{Modifier.project.name.underscore}/version\""
                requires.each do |r|
                  f.puts r
                end
              when String
                f.puts output.gsub("__projectname__", Modifier.project.name.camelize).gsub("__projectsummary__", Modifier.project.summary).gsub("__projectdescription__", Modifier.project.description).gsub(
                  "__TargetRubyVersion__", BundlerT::TargetRubyVersion
                )
              when Array
                output.each do |l|
                  f.puts l.gsub("__projectname__", Modifier.project.name.camelize).gsub("__projectsummary__", Modifier.project.summary).gsub("__projectdescription__", Modifier.project.description).gsub(
                    "__TargetRubyVersion__", BundlerT::TargetRubyVersion
                  )
                end
              end
              hooked = true
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
