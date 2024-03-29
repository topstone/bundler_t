# frozen_string_literal: true

require "active_support/inflector"
require "fileutils"
require "yaml"
require_relative "class_generator"
require_relative "spec_generator"
require_relative "file_generator"
require_relative "exe_generator"
require_relative "modifier"
require_relative "replacer"

module BundlerT
  # project を表す。
  class Project
    attr_reader :name, :classes, :description, :summary, :yaml_file, :bundler_options, :test, :linter, :specs

    def initialize
      @classes = []
      @specs = []
      @files = []
      @exes = []
      @bundler_options = []
    end

    # command line を解析する
    # 「-」で始まる引数は全て bundler へ渡す
    # @param argv [Array] 引数。
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
      check_testing_framework
      check_linter
      display
    end

    # yaml file を読み込む
    def load_yaml
      @yaml = YAML.load_file(@yaml_file)
      @name = @yaml["name"] unless @yaml["name"].nil?
      @summary = @yaml["summary"] unless @yaml["summary"].nil?
      @description = @yaml["description"] unless @yaml["description"].nil?
      @test = @yaml["test"] unless @yaml["test"].nil?
      @linter = @yaml["linter"] unless @yaml["linter"].nil?
      unless @yaml["classes"].nil?

        classes = @yaml["classes"]
        raise "classes が配列以外です" unless classes.instance_of?(Array)

        classes.each do |c|
          @classes << ClassGenerator.new(c)
        end
      end

      unless @yaml["specs"].nil?

        specs = @yaml["specs"]
        raise "specs が配列以外です" unless specs.instance_of?(Array)

        specs.each do |s|
          @specs << SpecGenerator.new(s)
        end
      end

      unless @yaml["exes"].nil?

        exes = @yaml["exes"]
        raise "exes が配列以外です" unless exes.instance_of?(Array)

        exes.each do |e|
          @exes << ExeGenerator.new(e)
        end
      end

      return if @yaml["files"].nil?


      files = @yaml["files"]
      raise "files が配列以外です" unless files.instance_of?(Array)

      files.each do |f|
        @files << FileGenerator.new(f)
      end
    end

    # testing framework を調べて @test に代入する
    def check_testing_framework
      test_option_exist = false
      @bundler_options.each do |o|
        if o[0..6] == "--test="
          test_option_exist = true
          @test = o[7..]
        end
      end
      @test ||= "rspec"
      @bundler_options << "--test=#{@test}" unless test_option_exist
    end

    # linter を調べて @linter に代入する
    def check_linter
      linter_option_exist = false
      @bundler_options.each do |o|
        if o[0..8] == "--linter="
          linter_option_exist = true
          @linter = o[9..]
        end
      end
      @linter ||= "rubocop"
      @bundler_options << "--linter=#{@linter}" unless linter_option_exist
    end

    # 実作業前に設定詳細を表示する
    def display
      puts "************************************************************"
      puts "* your settings"
      puts "************************************************************"
      puts "* project_name  : #{@name}"
      puts "* summary       : #{@summary}"
      puts "* description   : #{@description}"
      @bundler_options.each do |o|
        puts "* bundler_option: #{o}"
      end
      @classes.each do |c|
        puts "* class         : #{c.name}"
        next if c.methods.nil?

        c.methods.each do |m|
          puts "*   method      : #{m.name}"
        end
      end
      @specs.each do |s|
        puts "* spec          : #{s.name}"
      end
      @files.each do |f|
        puts "* file          : #{f.name}"
      end
      @exes.each do |e|
        puts "* exe           : #{e.name}"
      end
    end

    # bundle gem を実行する
    def bundlegem
      options = @bundler_options.join(" ")
      puts "************************************************************"
      puts "* bundle gem #{name} #{options}"
      `bundle gem #{name} #{options}`
      Dir.chdir(name) do
        requires = ClassGenerator.generate_all(project: self)
        SpecGenerator.generate_all(project: self)
        ExeGenerator.generate_all(project: self)
        FileGenerator.generate_all(project: self)
        Replacer.replace_all(project: self)
        Modifier.modify_all(project: self, requires:)
        puts "* bundle install"
        puts `bundle install`
        puts "* rubocop --autocorrect-all"
        puts `rubocop --autocorrect-all`
        puts "* rake spec"
        puts `rake spec`
        FileUtils.mkdir_p("sig")
      end
    end

    # bundle gem simple を実行する
    def bundlegemsimple(project_name)
      @name = project_name
      puts "************************************************************"
      puts "* bundle gem #{@name} --test=rspec --linter=rubocop"
      `bundle gem #{@name} --test=rspec --linter=rubocop`
      Dir.chdir(name) do
        File.open("lib/my_code.rb", "w") do |f|
          f.puts "# frozen_string_literal: true"
        end
        Dir.mkdir("exe")
        File.open("exe/#{@name}", "w") do |f|
          f.puts "#!/usr/bin/env ruby"
          f.puts "# frozen_string_literal: true"
          f.puts ""
          f.puts "require \"#{@name}\""
          f.puts ""
          f.puts "require_relative \"../lib/my_code.rb\""
        end
        Replacer.replace_all(project: self)
        Modifier.modify_all(project: self)
        puts "* bundle install"
        puts `bundle install`
        puts "* rubocop --autocorrect-all"
        puts `rubocop --autocorrect-all`
        puts "* rake spec"
        puts `rake spec`
        puts "* git add ."
        puts `git add .`
        FileUtils.mkdir_p("sig")
      end
    end
  end
end
