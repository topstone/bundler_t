# frozen_string_literal: true

modifier = BundlerT::Modifier.new
modifier.filename = "spec/__projectname___spec.rb"
modifier.hooks['    expect(false).to be(true)'] = '    # expect(false).to be(true)'
