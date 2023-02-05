# How to Run?

$ ~/bin/init.sh 001<br>
$ ~/bin/stab.sh 002 003<br>
$ ~/bin/main.sh 003 004<br>
...

<br>

中身については以下の通り<br>
$ gmx grompp -f (init/stab/main).mdp -c CH4.gro -p CH4.top -o (num).tpr >& (num).gentpr.log<br>
* (init/stab/main).mdp, CH4.gro, CH4.top から (num).tpr を作成
* (stab/main).mdpは "-c CH4.gro" が "-c (num-1).tpr -t (num-1).cpt" になる

<br>

$ gmx mdrun -notunepme -s (num).tpr -c (num)-last.gro -deffnm (num) >& (num).gentpr.log<br>
* (num).tpr から (num)-last.gro などを作成

# .topファイル

* CH4, 伸縮は固定, 電荷無し

# .mdpファイル

* init > stab > main
* dt = 2fs
* step数は 10000 > 30000 > 50000
* ref_t(K)とref_p(bar)を変更して使用

# 初期構造（.groファイル）の作成

1. make_bcc内のBCC.pyでBCC構造を作成<br>
$ python3 make_bcc.py > bcc.gro
2. 50K1000barで固体のまま構造を緩和
3. 緩和した構造の内、重心のz座標が全体の半分以下の分子を固定
3.1. 固定する分子を指定するためのファイル（.ndx）ファイルを作成
$ q | gmx make_ndx -f bcc.gro -o bcc.ndx<br>
3.2 作成した.ndxファイルに固定する分子を書き込むスクリプトを実行
$ python make_ndx_input.py >> bcc.ndx<br>
    bcc.gro<br>
4. まずは半分を固定した状態でシミュレーション
$ gmx grompp -f init.mdp -c bcc.gro -p CH4.top -n bcc.ndx -o 001.tpr >& 001.gentpr.log<br>
$ gmx mdrun -notunepme -s 001.tpr -c 001-last.gro -deffnm 001 >& 001.run.log<br>
5. 固定を外して緩和
$ gmx grompp -f stab2.mdp -c 001.tpr -t 001.cpt -p CH4.top -o 002.tpr -maxwarn 1 >& 002.gentpr.log<br>
$ gmx mdrun -notunepme -s 002.tpr -c 002-last.gro -deffnm 002 >& 002.run.log<br>
$ gmx grompp -f main.mdp -c 002.tpr -t 002.cpt -p CH4.top -o 003.tpr >& 003.gentpr.log<br>
$ gmx mdrun -notunepme -s 003.tpr -c 003-last.gro -deffnm 003 >& 003.run.log<br>
