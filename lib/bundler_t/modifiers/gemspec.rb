# frozen_string_literal: true

modifier = BundlerT::Modifier.new
modifier.filename = "__projectname__.gemspec"
modifier.hooks['  spec.required_ruby_version = ">= '] = '  spec.required_ruby_version = ">= __TargetRubyVersion__.0"'
