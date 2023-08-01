# frozen_string_literal: true

require "fileutils"
require "yaml"
require_relative "class_manager"
require_relative "rubocop_manager"
require_relative "gemspec_manager"
require_relative "module_file_manager"
require_relative "version_file_manager"

module BundlerT
  # project 全体を管轄する。
  class ProjectManager
    attr_reader :content, :name, :summary, :classes

    # 最初に変数を初期化する。
    def initialize
      @classes = []
    end

    # YAML 形式 file を読み込む。
    def load_yaml(filename)
      yaml_file = open(filename)
      yaml = YAML.load(yaml_file)

      # project が見つからなかったら error 発生。
      @content = yaml["project"]
      raise "project が見つかりません" if @content.nil?

      # name が見つからなかったら error 発生。
      @name = content["name"]
      raise "project name が見つかりません" if @name.nil?

      # name に「/」が含まれていたら error 発生。
      raise "project name に「/」が含まれています" unless @name.match(%r{/}).nil?

      # name に空白が含まれていたら error 発生。
      raise "project name に空白が含まれています" unless @name.match(/ /).nil?

      @summary = content["summary"]

      # classes が定義されていたら設定する
      # TODO: class の形もいずれ追加したい
      # TODO: class_Cabc の形もいずれ追加したい
      unless content["classes"].nil? then
        classes = content["classes"]
        if classes.class == Array then
          classes.each{|cl|
            @classes << ClassManager.new(cl)
          }
        else
          raise "classes は配列型以外は未実装"
        end
      end
    end

    # bundle gem を実行する。
    # 実行出来たら true を返す。
    # 実行前に当該 directory が存在していたら false を返す。
    def bundlegem
      return false if FileTest.exist?(@name)

      system("bundle gem #{@name} --test=rspec --linter=rubocop --exe")
      true
    end

    # RuboCop 向けに files を調整する。
    def adjust_for_rubocop
      @rubocop_minimum = RuboCopManager.new
      @rubocop_minimum.adjust_project_minimum
      @rubocop_minimum.edit
    end

    # gemspec 向けに files を調整する。
    def adjust_for_gemspec
      @gemspec_minimum = GemSpecManager.new
      @gemspec_minimum.adjust_project_minimum(self)
      @gemspec_minimum.edit
    end

    # module 全体を表す file を調整する。
    def adjust_module_file
      Dir.chdir("lib/") do
        @module_file = ModuleFileManager.new
        @module_file.adjust_project(self)
        @module_file.edit
      end
    end

    # version.rb を調整する。
    def adjust_version_file
      Dir.chdir("lib/#{@name.underscore}") do
        @version_file = VersionFileManager.new
        @version_file.adjust_version
        @version_file.edit
      end
    end

    # class file を全て lib へ書き出す。
    def write_classes_to_lib
      Dir.chdir("lib/#{@name.underscore}/") do
        @classes.each {|cl|
          cl.write_to_lib(project_name: @name)
        }
      end
    end

    # 全ての class について spec の雛型を書き出す。
    def write_classes_to_spec
      FileUtils.makedirs("spec/#{@name.underscore}/")
      Dir.chdir("spec/#{@name.underscore}/") do
        @classes.each {|cl|
          cl.write_to_spec(project_name: @name)
        }
      end
    end
  end
end
