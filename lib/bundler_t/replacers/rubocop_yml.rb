# frozen_string_literal: true

replacer = BundlerT::Replacer.new
replacer.filename = ".rubocop.yml"
replacer.content = <<EOS
require:
  - rubocop-rake
  - rubocop-rspec

AllCops:
  TargetRubyVersion: 3.3
  NewCops: enable

Naming/HeredocDelimiterNaming:
  Enabled: false

Style/StringLiterals:
  Enabled: true
  EnforcedStyle: double_quotes

Style/StringLiteralsInInterpolation:
  Enabled: true
  EnforcedStyle: double_quotes

Layout/LineLength:
  Max: 144
EOS
