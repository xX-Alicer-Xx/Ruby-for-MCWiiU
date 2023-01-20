print('開けるファイル名を入力してください
')

loop{
cy = gets
cy.chomp!
neo = File.exist?("#{cy}")
if cy == "new.txt"
    print("[エラー]ファイル名を変更してください　ファイルが消失する恐れがあります\n")
elsif true == neo
    print("ファイル行数:")
    File.open("#{cy}", "r") do |f|
        puts f.read.count('
')
    end
    loop{
        print("回転の向きをxかyかz(半角)で入力してください\n[左右反転]=>x, [上下反転]=>y, [前後反転]=>z\n")
        ns = gets
        ns.chomp!
        if "x" == ns
            linenum = 1
            p = File.open("new.txt", "w")
            File.open("#{cy}", "r") do |f|
                f.each_line { |line|
                    if 4 == linenum % 11
                        line = line.to_i 
                        line = line * -1 - 1
                        p.puts("#{line}")
                    else
                            p.puts("#{line}")
                    end
                    linenum = linenum + 1
                }
            end
            break
        elsif "y" == ns
            linenum = 1
            p = File.open("new.txt", "w")
            File.open("#{cy}", "r") do |f|
                f.each_line { |line|
                    if 5 == linenum % 11
                        line = line.to_i 
                        line = line * -1 - 1
                        p.puts("#{line}")
                    else
                            p.puts("#{line}")
                    end
                    linenum = linenum + 1
                }
            end
            break
        elsif "z" == ns
            linenum = 1
            p = File.open("new.txt", "w")
            File.open("#{cy}", "r") do |f|
                f.each_line { |line|
                    if 6 == linenum % 11
                        line = line.to_i 
                        line = line * -1 - 1
                        p.puts("#{line}")
                    else
                        p.puts("#{line}")
                    end
                    linenum = linenum + 1
                }
            end
            break
        else
            print("[エラー]xかyかz(半角)を入力してください\n")
        end
    }
    break
else
    print("[エラー]ファイルが存在しません　存在するファイル名を入力してください\n")
end
}
print("new.txtに反転されたcsmが生成されました")