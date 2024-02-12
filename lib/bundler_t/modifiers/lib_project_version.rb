# frozen_string_literal: true

modifier = BundlerT::Modifier.new
modifier.filename = "lib/__projectname__/version.rb"
modifier.hooks['  VERSION = "0.1.0"'] = '  VERSION = "0.1.0" # 版番号。'
