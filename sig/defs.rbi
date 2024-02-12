# typed: strong
# Bundler_T 関連。
module BundlerT
  VERSION = T.let("0.1.0", T.untyped)
  TargetRubyVersion = T.let("3.3", T.untyped)

  # 汎用 error。
  class Error < StandardError
  end

  # project を表す。
  class Project
    sig { void }
    def initialize; end

    # sord omit - no YARD return type given, using untyped
    # command line を解析する
    # 「-」で始まる引数は全て bundler へ渡す
    # 
    # _@param_ `argv` — 引数。
    sig { params(argv: T::Array[T.untyped]).returns(T.untyped) }
    def parse(argv); end

    # sord omit - no YARD return type given, using untyped
    # yaml file を読み込む
    sig { returns(T.untyped) }
    def load_yaml; end

    # sord omit - no YARD return type given, using untyped
    # testing framework を調べて @test に代入する
    sig { returns(T.untyped) }
    def check_testing_framework; end

    # sord omit - no YARD return type given, using untyped
    # linter を調べて @linter に代入する
    sig { returns(T.untyped) }
    def check_linter; end

    # sord omit - no YARD return type given, using untyped
    # 実作業前に設定詳細を表示する
    sig { returns(T.untyped) }
    def display; end

    # sord omit - no YARD return type given, using untyped
    # bundle gem を実行する
    sig { returns(T.untyped) }
    def bundlegem; end

    # sord omit - no YARD type given for :name, using untyped
    # Returns the value of attribute name.
    sig { returns(T.untyped) }
    attr_reader :name

    # sord omit - no YARD type given for :classes, using untyped
    # Returns the value of attribute classes.
    sig { returns(T.untyped) }
    attr_reader :classes

    # sord omit - no YARD type given for :description, using untyped
    # Returns the value of attribute description.
    sig { returns(T.untyped) }
    attr_reader :description

    # sord omit - no YARD type given for :summary, using untyped
    # Returns the value of attribute summary.
    sig { returns(T.untyped) }
    attr_reader :summary

    # sord omit - no YARD type given for :yaml_file, using untyped
    # Returns the value of attribute yaml_file.
    sig { returns(T.untyped) }
    attr_reader :yaml_file

    # sord omit - no YARD type given for :bundler_options, using untyped
    # Returns the value of attribute bundler_options.
    sig { returns(T.untyped) }
    attr_reader :bundler_options

    # sord omit - no YARD type given for :test, using untyped
    # Returns the value of attribute test.
    sig { returns(T.untyped) }
    attr_reader :test

    # sord omit - no YARD type given for :linter, using untyped
    # Returns the value of attribute linter.
    sig { returns(T.untyped) }
    attr_reader :linter
  end

  # file の内容の編集を担当。
  class Modifier
    # sord omit - no YARD return type given, using untyped
    # 登録されている全ての files を変数する。
    # 
    # _@param_ `project` — 作成されるべき project
    sig { params(project: T.nilable(Project)).returns(T.untyped) }
    def self.modify_all(project: nil); end

    # 依頼元の project
    # 
    # _@return_ — 依頼元の project。
    sig { returns(Project) }
    def self.project; end

    sig { void }
    def initialize; end

    # sord omit - no YARD return type given, using untyped
    # file を編集する。
    sig { returns(T.untyped) }
    def modify; end

    # Returns the value of attribute filename.
    sig { returns(T.untyped) }
    attr_accessor :filename

    # Returns the value of attribute hooks.
    sig { returns(T.untyped) }
    attr_accessor :hooks
  end

  # file の置き換えを担当。
  class Replacer
    # sord omit - no YARD type given for "project:", using untyped
    # sord omit - no YARD return type given, using untyped
    # 登録されている全ての files を置き換える。
    sig { params(project: T.untyped).returns(T.untyped) }
    def self.replace_all(project: nil); end

    # sord omit - no YARD return type given, using untyped
    # 依頼元の project
    sig { returns(T.untyped) }
    def self.project; end

    sig { void }
    def initialize; end

    # sord omit - no YARD return type given, using untyped
    # file を置き換える。
    sig { returns(T.untyped) }
    def replace; end

    # Returns the value of attribute filename.
    sig { returns(T.untyped) }
    attr_accessor :filename

    # Returns the value of attribute content.
    sig { returns(T.untyped) }
    attr_accessor :content
  end

  # 作成予定の class を表す。
  class ClassGenerator
    # class 作成。
    # 文字列または Hash を受け付ける。
    # 
    # _@param_ `c` — class 情報。
    sig { params(c: Object).void }
    def initialize(c); end

    # sord omit - no YARD type given for :name, using untyped
    # Returns the value of attribute name.
    sig { returns(T.untyped) }
    attr_reader :name
  end
end
