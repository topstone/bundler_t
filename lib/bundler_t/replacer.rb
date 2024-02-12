# frozen_string_literal: true

require "fileutils"

module BundlerT
  # file の置き換えを担当。
  class Replacer
    # 登録されている全ての files を置き換える。
    def self.replace_all
#      FileUtils.mkdir_p("tmp/")
#      FileUtils.move(filename, "tmp/#{filename}")
    end
  end
end

p Dir["./replacers/*.rb"]
