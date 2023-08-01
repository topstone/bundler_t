# frozen_string_literal: true

module BundlerT
  # file を編集する。
  class EditFile

    # 初期化時の処理。
    def initialize
      # 操作対象。
      @target = nil

      # 削除対象行。
      # この文字列を含む行は削除される。
      @lines_to_remove = []

      # 追加対象行。
      # この key を含む行は value (複数行) に置き換えられる。
      @lines_to_add = {}
    end

    # 編集する。
    def edit
      File.open(@target, "r"){|input_file|
        File.open(@target + ".temp", "w"){|output_file|
          input_file.each_line{|line|
            flag_to_remove = false
            @lines_to_remove.each{|to_remove|
              flag_to_remove ||= line.match?(to_remove)
            }

            # 削除対象行でなければ
            unless flag_to_remove then
              output_string = line
              @lines_to_add.each{|check, addition|
                output_string = addition if line.match?(check)
              }
              output_file.puts output_string
            end
          }
        }
      }

      File.delete(@target)
      File.rename(@target + ".temp", @target)
    end

  end
end
