print('開けるファイル名を
')
cy = gets
cy.chomp!
File.open("#{cy}", "r") do |f|
    puts f.read.count('
')
end

linenum = 1
p = File.open("new.txt", "w")
File.open("#{cy}", "r") do |f|
    f.each_line { |line|
        if 5 == linenum % 11
            line = line.to_i 
            line = line + 0.5
               p.puts("#{line}")
        else
                p.puts("#{line}")
        end
        linenum = linenum + 1
    }
end