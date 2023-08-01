# frozen_string_literal: true

require_relative "edit_file"

module BundlerT
  # gemspec 向けの調整を管轄する。
  class GemSpecManager < EditFile
    # gemspec を最低限調整する。
    def adjust_project_minimum(project)
      @target = "#{project.name}.gemspec"

      @lines_to_add["spec.required_ruby_version"] = [
        "  spec.required_ruby_version = \">= #{DEFAULT_RUBY_VERSION}\""]

      @lines_to_add['  spec.description = "TODO: Write a longer description or delete this line."'] = '  # spec.description = "TODO: Write a longer description or delete this line."'

      @lines_to_add['  spec.homepage = "TODO: Put your gem'] = "  # spec.homepage = \"TODO: Put your gem's website or public repo URL here.\""

      @lines_to_add["  spec\.metadata\\\[\"allowed_push_host"] = "  # spec.metadata[\"allowed_push_host\"] = \"TODO: Set to your gem server 'https://example.com'\""

      @lines_to_add["  spec\.metadata\\\[\"homepage_uri"] = '  # spec.metadata["homepage_uri"] = spec.homepage'

      @lines_to_add["  spec\.metadata\\\[\"source_code_uri"] = "  # spec.metadata[\"source_code_uri\"] = \"TODO: Put your gem's public repo URL here.\""

      @lines_to_add["  spec\.metadata\\\[\"changelog_uri"] = "  # spec.metadata[\"changelog_uri\"] = \"TODO: Put your gem's CHANGELOG.md URL here.\""

      # summary が設定されている場合
      @lines_to_add['  spec.summary = '] = "  spec.summary = \"#{project.summary}\"" unless project.summary.nil?

    end
  end
end
