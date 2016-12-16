
-viewerの構造説明-

ARGV[0]で外部ファイルである"POSCAR"を受け取る．
lines = File.readlines(ARGV[0])より，
受け取ったファイルのデータをreadlineesで読み込み，そのデータをlinesに代入する．

関数read_pos
lattice1 = [ ]
ファイルを読み込んだlines内の番号2から4までの3つの格子座標を
読み込んで配列latticeに格納する．

配列atom1
ファイルを読み込んだlines内の番号７から最後までの3つの原子座標を
読み込んで配列atomに格納する．

pos[]
配列atomに格納された原子座標をposへ入力
posで原子座標xxをiでまわす
関数pos.each_with_index
xxに原子の座標を入力，格子の各座標をlx,ly,lzに代入，
順番に原子座標と格子座標を加算して配列real_posに格納．



