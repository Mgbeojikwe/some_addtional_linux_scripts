#!/bin/bash
#SBATCH -J 2L_NN_t
#SBATCH -p nocona
#SBATCH -o array-%A_%a.out
#SBATCH -e array-%A_%a.err
#SBATCH -N 1
#SBATCH --ntasks-per-node=3
#SBATCH -t 48:00:00   ##1 hour runtime, you may change or remove this option. Default hour is 48 hours
#SBATCH -a 1-__NUM_TRAJS__


#author : Bright C. Mgbeojikwe
#date : Dec./30/2025
#version : 1.0 
#usage : compile in the latest bash enviroment
#notes: this code must be changed to execution mode i.e chmod 700 $file_name before it can run 
#bash version: GNU bash, version 5.1.8(1)-release (x86_64-redhat-linux-gnu)




trajs=(__TRAJS__) 



LR_MIN=__LR_MIN__
LR_MAX=__LR_MAX__

NUM_NUE_min=__NUM_NUE_MIN__
NUM_NUE_max=__NUM_NUE_MAX__


BATCH_SIZE_min=__BATCH_SIZE_MIN__
BATCH_SIZE_max=__BATCH_SIZE_MAX__


RANDOM_STATE=__RANDOM_STATE__
REG_PARA=__LAMBDA__



cwd=$PWD


#The variable $SLURM_ARRAY_JOB_ID is the ID for the entire array job
#The variable $SLURM_JOB_ID is the ID for each job in the array 

my_index=$(expr $SLURM_ARRAY_TASK_ID - 1)

 traj=${trajs[ $my_index ]}


 #  EXTRACTING THE HYPERPARAMETERS 

 	lr_range=$(echo $traj | cut -d "/" -f1 )
 	num_nuerones_range=$(echo $traj | cut -d "/" -f2 )
 	random_state=$(echo $traj | cut -d "/" -f3 )
 	reg_para=$(echo $traj | cut -d "/" -f4 )
	batch_size_range=$(echo $traj | cut  -d "/" -f5)



	seed=$(echo $random_state | cut  -d "_" -f2 )               # removing "RANDOM" string

	num_nue_min=$(echo  $num_nuerones_range | cut -d "_" -f1)
	num_nue_max=$(echo  $num_nuerones_range | cut -d "_" -f2)

	lambda=$(echo  $reg_para | cut  -d "_" -f2 )                #removing "lamda" string

	lr_min=$(echo  $lr_range | cut  -d "_" -f1)
	lr_max=$(echo  $lr_range | cut  -d "_" -f2)
	
	batch_size_min=$(echo $batch_size_range|cut -d "_" -f1)
	batch_size_max=$(echo $batch_size_range|cut -d "_" -f2)



   if [[ ! -d  $traj  ]] ;then       # if is the first time we are conducting study on the trajectory_range 
	

	mkdir -p $traj        
  
   	cd   $traj 

  	echo $traj does not exist  >>   output.txt  

      
	cp  $cwd/*py  $cwd/*csv   ./           





#BATCH_SIZE_min=__BATCH_SIZE_MIN__
#BATCH_SIZE_max=__BATCH_SIZE_MAX__




	sed  -e "s|$RANDOM_STATE|$seed|g" -e "s|$NUM_NUE_min|$num_nue_min|g"  -e "s|$NUM_NUE_max|$num_nue_max|g"  -e "s|$LR_MIN|$lr_min|g"  -e  "s|$LR_MAX|$lr_max|g"  -e "s|$REG_PARA|$lambda|g"   -e "s|$BATCH_SIZE_min|$batch_size_min|g"  -e "s|$BATCH_SIZE_max|$batch_size_max|g"  objective_func_ini.py   >  objective_func.py  

	sed -e "s|$RANDOM_STATE|$seed|g"   sampling_study_ini.py >   sampling_study.py 



	#run the hyperparameter sampling study

		source ~/.bashrc_miniconda

		python3  sampling_study.py  >> output.txt     2>err_sampling
	

else
	

		
		cd $traj 
		


		echo $traj does exist  >>   output.txt  


		#run the hyperparameter sampling study
		source ~/.bashrc_miniconda

		python3  sampling_study.py  >> output.txt     2>err2_sampling
	
		


  fi



