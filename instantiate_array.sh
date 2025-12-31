#!/bin/bash 

#author : Bright C. Mgbeojikwe
#date : Dec./30/2025
#version : 1.0 
#usage : compile in the latest bash enviroment
#notes: this code must be changed to execution mode i.e chmod 700 $file_name before it can run 
#bash version: GNU bash, version 5.1.8(1)-release (x86_64-redhat-linux-gnu)

declare -a trajs

TRAJS=__TRAJS__
NUM_TRAJS=__NUM_TRAJS__


learning_rate_range=( "1e-13_1e-7"  "1e-7_1e-4" "1e-4_1e-1" )

num_neurones_range=( "50_70" "70_100" "100_130" "130_160" "160_200")

random_state=( $(seq 0 1 10) )

#reg_parameters=( "1e-1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "1e-8" "1e-9" "1e-10" )
reg_parameters=( "1e-1"  )
batch_size_range=(  "3_60"  "60_90"  "91_150" "151_300"  "300_400"   ) 




for lr_range in ${learning_rate_range[@]}; do 

	for num_neur_range in ${num_neurones_range[@]};do 

		for r_s in  ${random_state[@]}; do 

			for  lambda in ${reg_parameters[@]}; do 

			    for b_s in  ${batch_size_range[@]}; do 


				size=${#trajs[@]}				

				traj=$lr_range/$num_neur_range/RANDOM_$r_s/lambda_$lambda/$b_s 

				trajs[$size]=$traj                            # Appending $traj to an array 

			     done 

			done

		done

	done

done 


trajectories="${trajs[@]}"
num_trajs=${#trajs[@]}

	
TRAJS=__TRAJS__
NUM_TRAJS=__NUM_TRAJS__


	
	sed -e  "s|$TRAJS|$trajectories|g"  -e   "s|$NUM_TRAJS|$num_trajs|g"  submit_array_ini.sh   > submit_array.sh 

	sbatch submit_array.sh 

