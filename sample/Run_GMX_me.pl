#!/usr/bin/perl
#
# Carry out a MD run. 
#

# Job number
  $num = 1;  

# Number of threads
  $N_thread = 8; 

# $job_name.gro and $job_name.top are necessary.  
# $job_name.ndx is also required for some types of MD.
  $job_name = "CH4"; 

# Change $maxwarn according to ?????.gentpr.log if needed.
  $maxwarn = 1;

  for($i_num=$num;$i_num<=$num;$i_num++){
    $num_new = sprintf("%05d",$i_num);
    $num_old = sprintf("%05d",$i_num-1);

#   Parameters which should not be changed through the simulation.
#   Type of the intermolecular interaction  
    $Coulomb_type  = "cut-off";
#   Neighbor searching             
    $nstlist       = "10     ";
    $ns_type       = "grid   ";
    $cutoff_scheme = "group ";
#   Long range LJ
    $L_LJ_long     = "1";  # 0/1 = off/on

    $gen_seed                 = "173529";
    $Run_type = "init";    
#   MD steps and output control     
    $dt              = "0.0001   ";  # ps
    $nsteps          = "10000    ";
    $nstxout         = "500     ";
    $nstvout         = "10000    ";
    $nstlog          = "50      ";
    $nstenergy       = "50      ";
    $nstxtcout       = "0       ";
    $energygrps      = "System  ";
#   Temperature coupling
    $gen_vel         = "0";  # 0/1 = off/on
    $tcoupl          = "v-rescale ";
    $tc_grps         = "System        ";
    $tau_t           = "0.6           ";
    $ref_t           = "300.0         ";
#   Pressure coupling                  
    $Pcoupl          = "no            ";
    $pcoupltype      = "isotropic     ";
    $tau_p           = "1.0           ";
    $compressibility = "4.5e-5        ";
    $ref_p           = "1000.0           ";
#   Freeze groups           
    $L_freeze_grps   = "0";  # 0/1/2 = off/on/on(energygrp_excl)
    $freezegrps      = "FIX  "; 
    $freezedim       = "Y Y Y";
    $othergrps       = "DUM  ";

#   Make $num_new.mdp or $num_new.mdp.ext
    if($Run_type eq "extend"){
      open(MDP,">$num_new.mdp.ext") || die;
      print MDP "extend job \n";
      print MDP "time_ext = $time_ext \n";
      close(MDP);
    }else{
      &make_mdp;
    }

#   check tpr file
    if(-e "$num_new.tpr"){  
      print "Run_GMX_02.pl: Exit. $num_new.tpr exists. \n\n";
      exit;
    }

#   Generate $num_new.tpr and run MD.
    if($Run_type eq "init"){
      if(-e "$job_name.ndx"){  
        system("grompp_d -maxwarn $maxwarn -f $num_new.mdp -p $job_name.top -c $job_name.gro -n $job_name.ndx -o $num_new.tpr >& $num_new.gentpr.log");
      }else{
        system("grompp_d -maxwarn $maxwarn -f $num_new.mdp -p $job_name.top -c $job_name.gro -o $num_new.tpr >& $num_new.gentpr.log");
      }
      &check_newtpr_generated;
      system("mdrun_d -notunepme  -nt $N_thread -deffnm $num_new -c $num_new-last.gro >& $num_new.stdo.log");

    }elsif($Run_type eq "change"){
      if(-e "$job_name.ndx"){  
        system("grompp_d -maxwarn $maxwarn -n $job_name.ndx -f $num_new.mdp -p $job_name.top -c $num_old.tpr -t $num_old.cpt -o $num_new.tpr >& $num_new.gentpr.log");
      }else{
        system("grompp_d -maxwarn $maxwarn -f $num_new.mdp -p $job_name.top -c $num_old.tpr -t $num_old.cpt -o $num_new.tpr >& $num_new.gentpr.log");
      }

      &check_newtpr_generated;
      system("mdrun_d -notunepme  -nt $N_thread -deffnm $num_new -c $num_new-last.gro>& $num_new.stdo.log");

    }elsif($Run_type eq "extend"){
      system("tpbconv_d -extend $time_ext -s $num_old.tpr -o $num_new.tpr >& $num_new.gentpr.log");
      &check_newtpr_generated;
      system("mdrun_d -notunepme  -nt $N_thread -deffnm $num_new -c $num_new-last.gro -cpi $num_old.cpt >& $num_new.stdo.log");
    }

  }
#----------------------------------------------------------
sub check_newtpr_generated{
  if(!-e "$num_new.tpr"){
    print "\n";
    print "Error-02. \n";
    print "$num_new.tpr was not generated. \n";
    print "See $num_new.gentpr.log. \n\n";
    exit;
  }
}

#----------------------------------------------------------
sub make_mdp{
  open(MDP,">$num_new.mdp") || die;
  
  print MDP "title                    = test1     \n";
  print MDP "cpp                      = /lib/cpp  \n";
  print MDP "include                  =           \n";
  print MDP "define                   =           \n";
  print MDP "integrator               = md        \n";
  print MDP "                                     \n";
  
  print MDP "; MD steps and output control          \n";
  print MDP "dt                       = $dt         \n";
  print MDP "nsteps                   = $nsteps     \n";
  print MDP "nstxout                  = $nstxout    \n";
  print MDP "nstvout                  = $nstvout    \n";
  print MDP "nstlog                   = $nstlog     \n";
  print MDP "nstenergy                = $nstenergy  \n";
  print MDP "nstxtcout                = $nstxtcout  \n";
  print MDP "                                        \n";
  
  print MDP "; Neighbor searching                      \n";
  print MDP "nstlist                  = $nstlist       \n";
  print MDP "ns_type                  = $ns_type       \n";
  print MDP "cutoff_scheme            = $cutoff_scheme \n";
  print MDP "                                          \n";
  
  print MDP "; Coulomb and vdW interactions      \n";
  if($Coulomb_type eq "cut-off"){
    print MDP ";cut_off.  Bad energy conservation. \n";
    print MDP "coulombtype              = cut-off  \n";
    print MDP "vdwtype                  = cut-off  \n";
    print MDP "rlist                    = 0.90     \n";
    print MDP "rcoulomb                 = 0.90     \n";
    print MDP "rvdw                     = 0.90     \n";
  }elsif($Coulomb_type eq "shift"){
    print MDP ";shift                            \n";
    print MDP "coulombtype              = shift  \n";
    print MDP "vdwtype                  = shift  \n";
    print MDP "rlist                    = 1.00   \n";
    print MDP "rcoulomb                 = 0.90   \n";
    print MDP "rvdw                     = 0.90   \n";
    print MDP "rcoulomb_switch          = 0.70   \n";
    print MDP "rvdw_switch              = 0.70   \n";
  }elsif($Coulomb_type eq "Reaction-Field"){
    print MDP ";RF.  Bad energy conservation?             \n";
    print MDP "coulombtype              = Reaction-Field  \n";
    print MDP "vdwtype                  = cut-off         \n";
    print MDP "epsilon_rf               = 0.0             \n";
    print MDP "rlist                    = 1.10            \n";
    print MDP "rcoulomb                 = 1.10            \n";
    print MDP "rvdw                     = 1.10            \n";
  }elsif($Coulomb_type eq "Reaction-Field-nec"){
    print MDP ";RF-nec. Before ver 3.3.  Bad energy conservation? \n";
    print MDP "coulombtype              = Reaction-Field-nec      \n";
    print MDP "vdwtype                  = cut-off                 \n";
    print MDP "epsilon_rf               = 0.0                     \n";
    print MDP "rlist                    = 0.90                    \n";
    print MDP "rcoulomb                 = 0.90                    \n";
    print MDP "rvdw                     = 0.90                    \n";
  }elsif($Coulomb_type eq "Reaction-Field-zero"){
    print MDP ";RF0.  Infinit dielectric constant.             \n";
    print MDP "coulombtype              = Reaction-Field-zero  \n";
    print MDP "vdwtype                  = shift                \n";
    print MDP "epsilon_rf               = 0.0                  \n";
    print MDP "rlist                    = 1.00                 \n";
    print MDP "rcoulomb                 = 0.90                 \n";
    print MDP "rvdw                     = 0.90                 \n";
    print MDP "rcoulomb_switch          = 0.70                 \n";
    print MDP "rvdw_switch              = 0.70                 \n";
  }elsif($Coulomb_type eq "PME"){
    print MDP ";PME.                                \n";
    print MDP "coulombtype              = PME       \n";
    print MDP "vdwtype                  = cut-off   \n";
    print MDP "fourierspacing           = 0.12      \n";
    print MDP "pme_order                = 4         \n";
    print MDP "ewald_rtol               = 1e-5      \n";
    print MDP "rlist                    = 0.9       \n";
    print MDP "rcoulomb                 = 0.9       \n";
    print MDP "rvdw                     = 0.9       \n";
  }elsif($Coulomb_type eq "PME-Switch"){
    print MDP ";PME-Switch.                           \n";
    print MDP "coulombtype              = PME-Switch  \n";
    print MDP "vdwtype                  = shift       \n";
    print MDP "fourierspacing           = 0.12        \n";
    print MDP "pme_order                = 4           \n";
    print MDP "ewald_rtol               = 1e-5        \n";
    print MDP "rlist                    = 1.0         \n";
    print MDP "rcoulomb                 = 0.9         \n";
    print MDP "rvdw                     = 0.9         \n";
    print MDP "rcoulomb_switch          = 0.70        \n";
    print MDP "rvdw_switch              = 0.70        \n";
  }else{
    print "\n";
    print "Error-03. \n";
    print "Unknown Coulomb_type. \n";
    exit;
  }
  print MDP "\n";
  
  print MDP "; Long range LJ correction             \n";
  if($L_LJ_long == 1){
    print MDP "DispCorr                  = EnerPres   \n";
  }else{
    print MDP "DispCorr                  = no         \n";
  }
  print MDP "\n";
  
  print MDP "; Temperature coupling                 \n";
  print MDP "tcoupl                   = $tcoupl     \n";
  print MDP "nh-chain-length          = 1           \n";
  print MDP "tc_grps                  = $tc_grps    \n";
  print MDP "tau_t                    = $tau_t      \n";
  print MDP "ref_t                    = $ref_t      \n";
  print MDP "\n";
  
  print MDP "; Pressure coupling                         \n";
  print MDP "Pcoupl                   = $Pcoupl          \n";
  print MDP "pcoupltype               = $pcoupltype      \n";
  print MDP "tau_p                    = $tau_p           \n";
  print MDP "compressibility          = $compressibility \n";
  print MDP "ref_p                    = $ref_p           \n";
  print MDP "\n";
  
  if($gen_vel == 1){ 
    print MDP "; Velocity generation                \n";
    print MDP "gen_vel                  = yes       \n";
    print MDP "gen_temp                 = $ref_t    \n";
    print MDP "gen_seed                 = $gen_seed \n";
  }else{
    print MDP "; Extende simulations                \n";
    print MDP "gen_vel                  = no       \n";
    print MDP "continuation             = yes      \n";
  }
  print MDP "\n";
  
  if($L_freeze_grps == 0){ 
    print MDP "energygrps               = $energygrps \n";
  }elsif($L_freeze_grps == 1){ 
    print MDP "; Freeze groups                        \n";
    print MDP "freezegrps               = $freezegrps \n";
    print MDP "freezedim                = $freezedim  \n";
    print MDP "energygrps               = $energygrps \n";
  }elsif($L_freeze_grps == 2){ 
    print MDP "; Freeze groups                        \n";
    print MDP "freezegrps               = $freezegrps \n";
    print MDP "freezedim                = $freezedim  \n";
    print MDP "energygrps               = $freezegrps $othergrps   \n";
    print MDP "energygrp_excl           = $freezegrps $freezegrps  \n";
#    print MDP "refcoord_scaling         = com \n";
  }
  print MDP "\n";
  
  close(MDP);
}
#----------------------------------------------------------


