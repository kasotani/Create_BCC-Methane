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

# .groファイル

* make_bcc内のBCC.pyで作成<br>
$ python3 make_bcc.py > bcc.gro
