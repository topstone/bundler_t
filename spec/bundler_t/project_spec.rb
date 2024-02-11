# frozen_string_literal: true

RSpec.describe BundlerT::Project do
  it 'class "Project" が存在する' do
    expect(BundlerT::Project.class).to be Class
  end
end
