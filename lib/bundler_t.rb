# frozen_string_literal: true

require_relative "bundler_t/version"
require_relative "bundler_t/project_manager"
require_relative "bundler_t/class_manager"
require_relative "bundler_t/method_manager"

# 簡単に gem の初期設定を済ませる tools。
module BundlerT
  # 汎用 error。
  class Error < StandardError; end
  # Your code goes here...

  # default Ruby version
  DEFAULT_RUBY_VERSION = 3.2
end
