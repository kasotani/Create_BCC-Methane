#!/bin/bash

gmx grompp -f init.mdp -c CH4.gro -p CH4.top -o ${1}.tpr >& ${1}.gentpr.log

wait

gmx mdrun -notunepme -s ${1}.tpr -c ${1}-last.gro -deffnm ${1} >& ${1}.run.log
