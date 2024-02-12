# frozen_string_literal: true

replacer = BundlerT::Replacer.new
replacer.filename = "Gemfile"
replacer.content = <<EOS
# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake"
gem "rspec"
gem "rubocop"
EOS
