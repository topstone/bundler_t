# frozen_string_literal: true

require "active_support/inflector"
require "yaml"

module BundlerT
  # project を表す。
  class Project
    attr_reader :name, :classes, :description, :summary, :yaml_file, :bundler_options

    def initialize
      @classes = []
      @bundler_options = []
    end

    # command line を解析する
    # 「-」で始まる引数は全て bundler へ渡す
    def parse(argv)
      argv = [argv] if argv.instance_of?(String) # 全て配列型に揃える
      argv.each do |arg|
        if arg[0] == "-"
          @bundler_options << arg
        elsif arg[0..1] == "d:"
          @description = arg[2..]
        elsif arg[0..1] == "s:"
          @summary = arg[2..]
        elsif arg[0..1] == "y:"
          @yaml_file = arg[2..]
        elsif @name.nil?
          @name = arg
        else
          @classes << ClassGenerator.new(arg)
        end
      end
      load_yaml unless @yaml_file.nil?
      display
    end

    # yaml file を読み込む
    def load_yaml
      @yaml = YAML.load_file(@yaml_file)
      @name = @yaml["name"] unless @yaml["name"].nil?
      @summary = @yaml["summary"] unless @yaml["summary"].nil?
      @description = @yaml["description"] unless @yaml["description"].nil?
      return if @yaml["classes"].nil?

      classes = @yaml["classes"]
      raise "classes が配列以外です" unless classes.instance_of?(Array)

      classes.each do |c|
        @classes << ClassGenerator.new(c)
      end
    end

    # 実作業前に設定詳細を表示する
    def display
      puts "************************************************************"
      puts "* your settings"
      puts "************************************************************"
      puts "* project_name  : #{@name}"
      puts "* summary       : #{@summary}"
      puts "* description   : #{@description}"
      @classes.each do |c|
        puts "* class         : #{c.name}"
      end
      @bundler_options.each do |o|
        puts "* bundler_option: #{o}"
      end
      puts "************************************************************"
    end
  end
end
