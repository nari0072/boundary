# boundary計算の作業手順

## boundary(CUI)のinstall
- pseudovaspをgit@github.com:daddygongon/boundary.gitからFork
- git cloneする
- rake install:localで localにinstall
- boundaryを同様にgit cloneしてlocal install

## boundaryで粒界モデルの作成
- boundary -d 'spec' -m '2 2 2 3'
- POSCAR_2223がspec dirに作成される

## adjusterで粒界モデルの修正
- Selective dynamicsをPOSCARに入れる
- ruby adjusterで修正開始
- energyと座標を見て重なっているatomsをdelしていく

## vasp計算
- モデルを移動(scp)
  - scp POSCAR_2223 asura0:~/
- POTCARの作成
  - cd vasp_potentials/potcar_paw_pbe/
  - cat Al/POTCAR >> ~/POTCAR
- 計算初期環境の作成
  - POSCAR, POTCAR, KPOINTS, INCARを一つのdirに準備
  - vs -i でinitialとfullrelaxを作成
  - vs --fix　でinitialあるいはfullrelaxからfixを作成
  - vs でvasp計算をsubmit

## vaspの緩和(relax)計算
-  vs -i でdirectoryの初期化．pwdのVASP filesをfullrelax配下にcp
-  作業中断，緩和の計算．．．

## viewerによるチェック
- モデルを移動(scp)
- viewerで緩和後の構造をチェック
- 大槻プロットに加える
