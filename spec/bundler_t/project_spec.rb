# frozen_string_literal: true

RSpec.describe BundlerT::Project do
  context 'with 引数は "aa d:new_program bb -cc -dd"' do
    project1 = described_class.new
    project1.parse(["aa", "d:new_program", "bb", "-cc", "-dd"])

    it 'bundler_options は ["-cc", "-dd"]' do
      expect(project1.bundler_options).to eq ["-cc", "-dd"]
    end

    it 'description は "new_program"' do
      expect(project1.description).to eq "new_program"
    end
  end

  context 'with 引数は "aa y:config.yaml"' do
    project2 = described_class.new
    project2.parse(["aa", "y:config.yaml"])

    it 'yaml は "config.yaml"' do
      expect(project2.yaml).to eq "config.yaml"
    end
  end
end
