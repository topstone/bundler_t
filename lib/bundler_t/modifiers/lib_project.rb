# frozen_string_literal: true

modifier = BundlerT::Modifier.new
modifier.filename = "lib/__projectname__.rb"
modifier.hooks["module __projectname__"] = ["# __projectname__ 関係。", "module __projectname__", "  # 汎用 error class。"]
modifier.hooks["require_relative "] = "__requires__"
