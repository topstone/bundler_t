# frozen_string_literal: true

replacer = BundlerT::Modifier.new
puts "********#{BundlerT::Modifier.project.name}"
replacer.filename = "#{BundlerT::Modifier.project.name}.gemspec"
replacer.content = <<~EOS
  require:
    - rubocop-rake
    - rubocop-rspec

  AllCops:
    TargetRubyVersion: 3.3
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
