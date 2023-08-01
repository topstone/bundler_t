# frozen_string_literal: true

require_relative "edit_file"

module BundlerT
  # module 全体を表す file の調整を管轄する。
  class ModuleFileManager < EditFile
    # project を最低限調整する。
    def adjust_project(project)
      @target = "#{project.name.underscore}.rb"
      @lines_to_add["module "] = [
        "# #{project.name} の名前空間。",
        "module #{project.name.camelize}",
        "  # 汎用 error class。"]
    end
  end
end
