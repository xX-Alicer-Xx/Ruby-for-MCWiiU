print("開けるファイル名を入力してな \n")
loop{
    filename = gets.chomp! #ファイルの名前の取得
    existance = File.exist?("#{filename}") #ファイルが存在するか確認
    if true == existance
        print("ファイル文字数:")
        File.open("#{filename}", "r") do |f|
            puts f.read.length #ファイルの長さをlengthで求める
        end	
        fi = File.open("#{filename}")
        text = fi.read.delete_prefix("0a000107070006426c6f636b7300020000").chop.chop  # 全て読み込む先頭の文字列削除
        fi.close
        monoris = text.scan(/.{1,#{1024}}/) #ブロックデータをxz座標ごとにArray化
        def monorisshooting(monoris, searchdata)
            dcount = 0 #試行回数
            misscount = 0 #xz内にブロックがなかった回数
            monoris.each do |resolve| #xz座標ごとに存在を確認していく
                blocknumbers = resolve.scan("#{searchdata}") #xz座標に存在している個数を配列で抽出して確認
                if 0 != blocknumbers.count #存在していた場合
                    ycount = 0 #y座標を求めた回数
                    ypoint = 0 #ブロックがresolveの何番目にあるか
                    ymiss = 0 #4桁ごとの区切りでなかった(ブロックではなかった)回数
                    loop{
                    if blocknumbers.count >= ycount #存在する個数に到達するまでy座標を求めさせる
                        ypoint = resolve.index("#{searchdata}", ypoint + 1)
                        if nil == ypoint #存在しなかったとき"%"の文がバグるので
                            break
                        else
                            if 0 == ypoint % 4 #4桁ごとに分けられてるか(ブロックとして認識しうるか)を確認
                                print("[x:#{dcount / 16},y:#{ypoint / 4},z:#{dcount % 16}]に発見！\n")
                            else
                                ymiss = ymiss + 1
                            end
                            ycount = ycount + 1
                        end
                    elsif blocknumbers.count <= ycount
                        if ymiss == ycount #xz座標内の存在していたものがすべてブロックでなかったとき
                            misscount = misscount + 1
                        end
                        break
                    end 
                    }
                elsif 255 == misscount  && 0 == blocknumbers.count #ブロックチャンク内になかったとき
                    print("\nこのチャンクには存在してへんみたいやな\n")    
                elsif 0 == blocknumbers.count #そもそもブロックがxz内に確認できなかったとき
                    misscount = misscount + 1
                end
                dcount = dcount + 1
            end
        end
        print("何したいん？半角で入力たのむで\n1:座標からブロックデータ取得\n2:ブロックデータの座標検索\n0:終了\n")
        loop{
            command1 =gets.chomp!
            if "1" == command1
                print("知りたい場所のワールド内の座標を([x座標], [z座標])の形で入力してな\n")
                loop{
                    pointxz = gets.chomp!
                    pointxz.delete!("() ")
                    if nil == pointxz.index(",") then #正しく入力されなかったらもう一度入力してもらう
                        p(',(カンマ)で区切ってくれへん？')
                    else
                        pointxzAry = pointxz.split(",")
                        px = pointxzAry[0].to_i
                        pz = pointxzAry[1].to_i
                        print("x=#{px} ,z=#{pz}のデータを表示\n")
                        if 0 > px then #座標が-+それぞれの時のチャンク内での座標に置き換え
                            px = 16 - px.abs % 16
                        else
                            px = px % 16
                        end
                        if 0 > pz then
                            pz = 16 - pz.abs % 16
                        else
                            pz = pz % 16
                        end
                        pnum = 16 * 1025 * px + 1025 * pz - (px*16+pz)
                        p code = text.slice(pnum, 1024)#x,zで指定される座標のデータを表示

                        print("y座標入力してな\n")
                        loop{
                            pointy = gets
                            ynum = pointy.chomp!.to_i
                            if 0 > ynum || 256 <= ynum #y座標がおかしな値だったことを指摘
                            print("そんな場所にブロックあらへんがな\n")
                            elsif 0 <= ynum && 256 > ynum && 1 <= pointy.count('0-9') && 0 == pointy.count('a-z')
                                print("\nその場所のデータ:")
                                p blockdata = code.slice(4*ynum, 4)
                                if "8" == blockdata[2]#ブロックが新しく追加されたものか、水中にあるのかを確認
                                    waterin = "水中の"
                                    newitem = nil
                                elsif "9" == blockdata[2]
                                    waterin = "水中の"
                                    newitem = "4"
                                elsif "1" == blockdata[2]
                                    waterin = nil
                                    newitem = 4
                                else
                                    waterin = nil
                                    newitem = nil
                                end
                                print("ブロックid:")
                                p blockid = "#{waterin}" + "#{newitem}#{blockdata.reverse.chr}#{blockdata.chr}".to_i(16).to_s
                                print("メタデータ:") 
                                p metadata = blockdata[1].to_i(16)                            
                                break
                            else #入力された値が数値でないまたは全角だった事を指摘
                                print("きみは何を入力しとんのや\n")
                            end
                        }
                        break
                    end
                }
                print("\n何をしたい？半角で入力たのむで\n1:座標からブロックデータ取得\n2:ブロックデータの座標検索\n0:終了\n")
            elsif "2" == command1
                print("検索したいブロックデータを[4桁のデータ:hex]か[ブロックid,ダメージ値:dec]で入力してな\nダメージ値は入力せんでもええで\n----入力例(花崗岩の場合)----\n前者:'1100:hex'\n後者:'1,1:dec'\n")
                loop{
                searchdata = gets.chomp!
                if /hex/ =~ searchdata && 5 == searchdata.count("0-9") + searchdata.count("a-f")#hexとdecで仕分け
                    searchdata.delete_suffix!("hex")
                    searchdata.delete_suffix!(":")
                    print("検索するブロックデータ:#{searchdata}\n")
                    monorisshooting(monoris, searchdata)
                    break
                elsif 3 == searchdata.count("dec") && 1<= searchdata.count("0-9") && nil != searchdata.delete_suffix!("dec") && 0 == searchdata.count('a-f','^c-e')
                    searchdata.delete_suffix!("dec")
                    searchdata.delete_suffix!(":")
                    if 1 == searchdata.count(",")
                        blockArray = searchdata.split(",")
                        blockid2 = blockArray[0].to_i
                        damage2 = blockArray[1].to_i.abs
                    else
                        blockid2 = searchdata.to_i
                        damage2 = 0
                    end
                    if 15 < damage2
                        print("ダメージ値でかすぎやん、地図かよ笑\n")
                    else
                        print("\n検索するブロックデータ:#{blockid2}\n")
                        print("　　そのダメージ値　　:#{damage2}\n")
                        if 1000 < blockid2
                            searchdata = "#{blockid2.to_s(16).reverse.slice(0)}#{damage2.to_s(16)}1#{blockid2.to_s(16).reverse.slice(1)}"
                            monorisshooting(monoris, searchdata)
                        else 
                            if 16 > blockid2
                                b2 = 0
                            else
                                b2 = blockid2.to_s(16).reverse.slice(1)
                            end
                            searchdata ="#{blockid2.to_s(16).reverse.slice(0)}#{damage2.to_s(16)}0#{b2}"
                            monorisshooting(monoris, searchdata)
                        end
                        break
                    end
                else
                    print("ちゃんと入力してくれへん？\nhexかdecってちゃんと書いとるか？\n")
                end
                }
                print("\n何したいん？半角で入力たのむで\n1:座標からブロックデータ取得\n2:ブロックデータの座標検索\n0:終了\n")   
            elsif "0" == command1
                print("終わるで\n")
                break
            else
                print("半角数字でおｋ\n")
            end
        }
        break
    else 
        print("そんなファイルは存在してへんで\n")
    end
}