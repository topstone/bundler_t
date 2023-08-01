# frozen_string_literal: true

require_relative "edit_file"

module BundlerT
  # RuboCop 向けの調整を管轄する。
  class RuboCopManager < EditFile
    # project を最低限調整する。
    def adjust_project_minimum
      @target = ".rubocop.yml"
      @lines_to_remove << "TargetRubyVersion:"
      @lines_to_remove << "  Max: 120"
      @lines_to_add["AllCops:"] = [
        "AllCops:",
        "  TargetRubyVersion: #{DEFAULT_RUBY_VERSION}",
        "  NewCops: enable"]
      @lines_to_add["Layout/LineLength:"] = [
        "Layout/LineLength:",
        "  Max: 144",
        "",
        "Layout/EndOfLine:",
        "  Enabled: false",
        "",
        "Lint/EmptyBlock:",
        "  Enabled: false",
        "",
        "Lint/UnusedMethodArgument:",
        "  Enabled: false",
        "",
        "Style/AsciiComments:",
        "  Enabled: false",
        "",
        "Style/EmptyMethod:",
        "  Enabled: false"]
    end
  end
end
