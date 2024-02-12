# frozen_string_literal: true

replacer = BundlerT::Replacer.new
replacer.filename = ".rubocop.yml"
replacer.content = <<~EOS
  require:
    - rubocop-rake
    - rubocop-rspec

  AllCops:
    TargetRubyVersion: #{BundlerT::TargetRubyVersion}
    NewCops: enable

  Layout/EndOfLine:
    Enabled: false

  Layout/LineLength:
    Max: 144

  Naming/HeredocDelimiterNaming:
    Enabled: false

  Style/StringLiterals:
    Enabled: true
    EnforcedStyle: double_quotes

  Style/StringLiteralsInInterpolation:
    Enabled: true
    EnforcedStyle: double_quotes
EOS
