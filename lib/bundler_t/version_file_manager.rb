# frozen_string_literal: true

require_relative "edit_file"

module BundlerT
  # version.rb の調整を管轄する。
  class VersionFileManager < EditFile
    # project を最低限調整する。
    def adjust_version
      @target = "version.rb"
      @lines_to_add["  VERSION = "] = "  VERSION = \"0.1.0\" # 版番号。"
    end
  end
end
