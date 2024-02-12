# frozen_string_literal: true

modifier = BundlerT::Modifier.new
modifier.filename = "__projectname__.gemspec"
modifier.hooks['  spec\.required_ruby_version = ">= '] = '  spec.required_ruby_version = ">= __TargetRubyVersion__.0"'
modifier.hooks['  spec\.summary = '] = '  spec.summary = "__projectsummary__"'
modifier.hooks['  spec\.description = '] = '  spec.description = "__projectdescription__"'
modifier.hooks['  spec\.homepage = '] = "  # spec.homepage = \"TODO: Put your gem's website or public repo URL here.\""
modifier.hooks['  spec\.metadata\["allowed_push_host"\] = '] = "  # spec.metadata[\"allowed_push_host\"] = \"TODO: Set to your gem server 'https://example.com'\""
modifier.hooks['  spec\.metadata\["homepage_uri"\] = '] = '  # spec.metadata["homepage_uri"] = spec.homepage'
modifier.hooks['  spec.metadata\["source_code_uri"\] = '] = "  # spec.metadata[\"source_code_uri\"] = \"TODO: Put your gem's public repo URL here.\""
modifier.hooks['  spec\.metadata\["changelog_uri"\] = '] = "  # spec.metadata[\"changelog_uri\"] = \"TODO: Put your gem's CHANGELOG.md URL here.\""
modifier.hooks['  # spec\.add_dependency \"example-gem'] = ['  # spec.add_dependency "example-gem", "~> 1.0"', '  spec.add_dependency "bundler"', '  spec.add_dependency "bundler"', '  spec.add_dependency "rspec"', '  spec.add_dependency "rubocop-rake"', '  spec.add_dependency "rubocop-rspec"', '  spec.add_dependency "sord"', '  spec.add_dependency "yard"']
