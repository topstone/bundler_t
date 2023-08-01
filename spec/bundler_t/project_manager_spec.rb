# frozen_string_literal: true

require "fileutils"

RSpec.describe BundlerT::ProjectManager do
  # 開始前処理
  before :all do
    @pabc01 = described_class.new
    Dir.chdir("spec/sandbox/") do
      @pabc01.load_yaml("pabc01.yaml")
      FileUtils.remove_entry_secure(@pabc01.name) if FileTest.exist?(@pabc01.name)
      @pabc01.bundlegem
      Dir.chdir("pabc01/") do
        @pabc01.adjust_for_rubocop
        @pabc01.adjust_for_gemspec
        @pabc01.write_classes_to_lib
        @pabc01.write_classes_to_spec
        @pabc01.adjust_module_file
        @pabc01.adjust_version_file
      end
    end
  end

  # 判定

  it 'method "load_yaml" で pabc01.yaml を読み込んだら @name が設定される' do
    Dir.chdir("spec/sandbox/") do
      expect(@pabc01.name).to eq("pabc01")
    end
  end

  it "bundle gem を実行したら .gemspec が生成される" do
    Dir.chdir("spec/sandbox/") do
      expect(FileTest.exist?("#{@pabc01.name}/#{@pabc01.name}.gemspec")).to be_truthy
    end
  end

  # 終了後処理
  after :all do
    Dir.chdir("spec/sandbox/") do
      FileUtils.remove_entry_secure("#{@pabc01.name}/spec") if FileTest.exist?("#{@pabc01.name}/spec")
    end
  end
end
