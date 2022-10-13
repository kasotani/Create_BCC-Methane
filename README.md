# How to Run?

$ gmx grompp -f grompp.mdp -c conf.gro -p topol.top -o topol.tpr >& num.gentpr.log<br>
    * grompp.mdp, conf.gro, topol.top から topol.tpr を作成
    * change以降は "-c conf.gro" が "-c old.tpr -t old.cpt" になる

<br>

$ gmx mdrun -notunepme -nt 16 -s topol.tpr -c num-last.gro -deffnm num >& num.gentpr.log<br><br>
    * topol.tpr から hoge.tpr や hoge.gro などを作成

# .topファイル

* CH4, 伸縮は固定, 電荷無し
* 原子数（最終行）は後で修正


# .mdpファイル

* init > stab > main
* dt = 2fs
* step数は 10000 > 100000 > 500000
* ref_t(K)とref_p(GPa)を変更して使用

# .groファイル

* make_bcc内のBCC.pyで作成
