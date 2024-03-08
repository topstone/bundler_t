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

  Lint/EmptyClass:
    Enabled: false

  Naming/HeredocDelimiterNaming:
    Enabled: false

  RSpec/NoExpectationExample:
    Enabled: false

  Style/EmptyMethod:
    Enabled: false

  Style/RedundantInitialize:
    Enabled: false

  Style/StringLiterals:
    Enabled: true
    EnforcedStyle: double_quotes

  Style/StringLiteralsInInterpolation:
    Enabled: true
    EnforcedStyle: double_quotes
EOS
