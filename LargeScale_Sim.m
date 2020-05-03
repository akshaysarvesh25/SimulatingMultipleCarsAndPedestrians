clc;clear all;close all;
tic()

open_system(new_system('MultipleCarsPedestrians'));

object_name = 'Objects{';

Num_Cars = 2;
Num_Peds = 0;
Num_Avs = 0;


%%%%Create cars%%%
add_car = 'genericAgentLib/car';
car_name = 'MultipleCarsPedestrians/Car';
for c = 1:Num_Cars

car_name1 = strcat(car_name,string(c));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_car,car_name1);
set_param(car_name1,'MaskValueString',object_name1);
set_param(car_name1,'LinkStatus','inactive');
Objects{c} = initialize_car_objs(c);
end


%%Add relative position for pedestrians to get a count of total number of objects%%%
Num_Peds_relative = Num_Peds + Num_Cars;

%%%%Create Pedestrians%%%
add_ped = 'genericAgentLib/ped1';
ped_name = 'MultipleCarsPedestrians/ped';
for c = Num_Cars+1:Num_Peds_relative

%Starting the number of pedestrians from 1, but not changing it to keep the value of object different
ped_name1 = strcat(ped_name,string(c-Num_Cars));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_ped,ped_name1);
set_param(ped_name1,'MaskValueString',object_name1);
%Objects{c} = initialize_pedestrian_objs(c);
end

%%Add relative position for Avs to get a count of total number of objects%%%
Num_avs_relative = Num_Peds_relative+Num_Avs;

%%%%Create Avs%%%
add_av = 'genericAgentLib/av_simple';
av_name = 'MultipleCarsPedestrians/av';
for c = Num_Peds_relative+1:Num_avs_relative

%Starting the number of avs from 1, but not changing it to keep the value of object different
av_name1 = strcat(av_name,string(c-Num_Peds_relative));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_av,av_name1);
set_param(av_name1,'MaskValueString',object_name1);
end

toc()


