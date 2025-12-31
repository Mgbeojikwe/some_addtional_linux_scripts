This folder contains two bash script viz "instantiate.sh" and "submit_array_ini.sh". both scripts work together inorder to submit an array of jobs to a high performance computer(HPC); the jobs submitted are Machine_learning hyperparameter-sampling jobs. The function of the scripts are as follows:

.......  instantiate.sh  ...  

step 1 :  conducts a five-nested iterative operation on five arrays , then forms a string-like path.

step 2:  each path from step 1 is appended to the "traj" array

step 3: on existing the entire looping operation, the elements of "traj" are extrated as a single string object to the "trajectories" variable.

step 4: a)  the $ sed command is used to replace "__TRAJS__" present in submit_array_in.sh objects with the result from step 3 and then write the modified file to submit_array.sh
        b) the $ sed command also replaces "__NUM_TRAJS__" in submit_array_ini.sh  with the final length of the array obtained in step 2, the modified script also written to submit_array.sh

step 5 : submit_array.sh is mow submitted to the cluster.


.....  submit_array_ini.sh  ..... 


step 1:  submit_array.sh is resubmitted to the cluster for a number-of-times equal to the length of the "traj" array in "instantiate.sh" i.e the size of "trajs" in submit_array.sh
                             
step 2 : for each count that submit_array.sh is resubmitted it takes an elements at an index position equal to a preceeding number before the the value of the count (check line 48) .
                        
step 3 : the element obtained in step 2 is splitted based on "/" delimiter and each result is futher splitted based on the "_" delimiter so as obtain the max. and min. learning rate, max. and min. batch size, max. and min. number of nuerones. (check line 55-74)                   
                                                                                            
step 4: with the help of the $ sed command,  the neccessary string objects in sampling_study_ini.py are replaced with the results of step 3 and the modified file written to sampling_study.py                                                                                      

step 5: sampling_study.py is now executed i.e python3 sampling_study.py > output.txt  2>err_sampling  
