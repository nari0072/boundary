
-viewerの構造説明-

ARGV
lines = File.readlines(ARGV[0])
linesに読み込んだファイルを格納する

lattice = [ ]
ファイルを読み込んだlines内の番号2から4までの3つの格子座標を
読み込んで配列latticeに格納する．

atom = [ ]
ファイルを読み込んだlines内の番号７から最後までの3つの原子座標を
読み込んで配列atomに格納する．


real_pos[]
配列atomに格納された原子座標をposへ入力
posで原子座標xxをiでまわす
関数pos.each_with_index
xxに原子の座標を入力，格子の各座標をlx,ly,lzに代入，
順番に原子座標と格子座標を加算して配列real_posに格納．



