# frozen_string_literal: true

module BundlerT
  # file の置き換えを担当。
  class Replacer

    # file を置き換える。
    def replace(filename)
      FileUtils.mkdir_p("tmp/")
    end
  end
end
