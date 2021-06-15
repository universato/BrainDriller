# 最初に、冒頭部分を削除する。

# .gsub(/令和 . 年第.回短答式.+\n/, "") # [令和 ２ 年第Ⅱ回短答式企業法] # 全角の数字
# .gsub(/Ｍ\d―\d+\n/, "") # Ｍは、全角。何を意味してるのか謎。
# .gsub("1．アイ 2．アウ 3．アエ 4．イウ 5．イエ 6．ウエ\n", "") # 定型文なので削除する。
# .gsub(/問題\s?(\d+)\n.+\n/){ |s| "問題#{ ($1.to_i + 1)}\n" } 問題番号を増やす

# text = readlines.join
# text = File.read("cpa/pdf_copy_texts/R2-02.txt")
text = File.read("lib/scripts/cpa/pdf_copy_texts/R2-02.txt") # コマンドを打った場所を起点にするので注意。
# text = File.read("./cpa")

texts = text
        .gsub(/令和 . 年第.回短答式.+\n/, "")
        .gsub(/Ｍ\d―\d+\n/, "")
        .gsub("1．アイ 2．アウ 3．アエ 4．イウ 5．イエ 6．ウエ\n", "")
        .gsub("1．アイ　 2．アウ　 3．アエ　 4．イウ　 5．イエ　 6．ウエ\n", "")
        .gsub(/問題\s?(\d+)\n.+\n/){ "問題#{$1.to_i + 1}\n" }
        .split("\n")

texts.map! do |text|
  if text.start_with?(/[アイウエ]．/) # ||  #|| text.end_with?("（ 5 点）")
    "\n" + text
  elsif text.start_with?(/問題\d+/)
    "\n" + text + "\n"
  else
    text
  end
end

# text = "問題1\n" + texts.join
text = texts.join
p text.split(/問題\d+\n/).size

# p text.scan(/問題\d+\n.+/)
