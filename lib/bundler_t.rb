# frozen_string_literal: true

require_relative "bundler_t/version"
require_relative "bundler_t/class_generator"
require_relative "bundler_t/method_generator"
require_relative "bundler_t/project"
require_relative "bundler_t/replacer"

# Bundler_T 関連。
module BundlerT
  # 汎用 error。
  class Error < StandardError; end
  # Your code goes here...
end
