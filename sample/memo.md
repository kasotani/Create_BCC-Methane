$ gmx grompp -f grompp.mdp -c conf.gro -p topol.top -o topol.tpr >& num.gentpr.log
    grompp.mdp, conf.gro, topol.top から topol.tpr を作成

change以降は "-c conf.gro" が "-c old.tpr -t old.cpt" になる



$ gmx mdrun -notunepme -nt 16 -s topol.tpr -c num-last.gro -deffnm num >& num.gentpr.log
    topol.tpr から hoge.tpr や hoge.gro などを作成