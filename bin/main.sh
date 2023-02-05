#!/bin/bash

gmx grompp -f main.mdp -c ${1}.tpr -t ${1}.cpt -p CH4.top -o ${2}.tpr >& ${2}.gentpr.log

wait

gmx mdrun -notunepme -s ${2}.tpr -c ${2}-last.gro -deffnm ${2} >& ${2}.run.log
