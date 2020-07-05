clc;clear all;close all;

%pathToScript = fullfile('/home/akshay/Documents/code_scratch/linux_time_memory_log','mem_log.sh');
%system(pathToScript);
%system('sh /home/akshay/Documents/code_scratch/linux_time_memory_log/mem_log.sh;sleep 2')
op = LargeScaleSim(24,2,2,14);
%pause(2)
%system('sh pkill -f /home/akshay/Documents/code_scratch/linux_time_memory_log/mem_log.sh;sleep 2')

