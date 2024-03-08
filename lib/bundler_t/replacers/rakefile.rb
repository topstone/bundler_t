# frozen_string_literal: true

replacer = BundlerT::Replacer.new
replacer.filename = "Rakefile"
replacer.content = <<~EOS
  # frozen_string_literal: true

  require "bundler/gem_tasks"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  require "rubocop/rake_task"

  RuboCop::RakeTask.new

  desc "1st time RuboCop"
  task :rubocop1st do
    puts `rubocop --enable-pending-cops --auto-gen-config ./exe/**/* ./lib/**/*.rb ./spec/**/*.rb ./*.gemspec ./Gemfile ./Rakefile`
  end

  desc "do YARD"
  task :yard do
    puts `yard doc ./lib/**/*.rb`
  end


  task default: %i[rubocop yard spec]
EOS
