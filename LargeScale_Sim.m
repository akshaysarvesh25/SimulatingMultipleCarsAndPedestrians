clc;clear all;close all;
tic()

open_system(new_system('MultipleCarsPedestrians'));
system_name = 'MultipleCarsPedestrians';

object_name = 'Objects{';

Num_Cars = 2;
Num_Peds = 2;
Num_Avs = 2;
Num_Acc_cars = 2;


%%%%Create cars%%%
add_car = 'LargeScaleSimLib/car';
car_name = 'MultipleCarsPedestrians/Car';
for c = 1:Num_Cars

car_name1 = strcat(car_name,string(c));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_car,car_name1);

%Make Library link status as inactive
set_param(car_name1,'LinkStatus','inactive');

%Set object name
set_param(car_name1,'MaskValueString',object_name1);



%add input blocks
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/vxd_',string(c)));
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/delta_f',string(c)));
set_param(strcat('MultipleCarsPedestrians/vxd_',string(c)),'Value',string(rand(5,1,1)*10));
set_param(strcat('MultipleCarsPedestrians/delta_f',string(c)),'Value',string(randi([-5,5],1,1)));

%get output port handles
Ports_vxd = get_param(strcat('MultipleCarsPedestrians/vxd_',string(c)),'PortHandles');
Ports_deltaf = get_param(strcat('MultipleCarsPedestrians/delta_f',string(c)),'PortHandles');
car_port = get_param(car_name1,'PortHandles');

%add arrows to connect
add_line(system_name,Ports_vxd.Outport,car_port.Inport(1));
add_line(system_name,Ports_deltaf.Outport,car_port.Inport(2));

%Initialize objects
Objects{c} = initialize_car_objs(c);

end


%%Add relative position for pedestrians to get a count of total number of objects%%%
Num_Peds_relative = Num_Peds + Num_Cars;

%%%%Create Pedestrians%%%
add_ped = 'LargeScaleSimLib/ped1';
ped_name = 'MultipleCarsPedestrians/ped';
for c = Num_Cars+1:Num_Peds_relative

%Starting the number of pedestrians from 1, but not changing it to keep the value of object different
ped_name1 = strcat(ped_name,string(c-Num_Cars));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_ped,ped_name1);

%Make Library link status as inactive
set_param(ped_name1,'LinkStatus','inactive');

%Set object name
set_param(ped_name1,'MaskValueString',object_name1);

%add input blocks
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/v_d',string(c)));
add_block('simulink/Sources/Repeating Sequence Interpolated',strcat('MultipleCarsPedestrians/seq_',string(c)));
set_param(strcat('MultipleCarsPedestrians/v_d',string(c)),'Value',string(rand(4,1,1)*10));
set_param(strcat('MultipleCarsPedestrians/seq_',string(c)),'tsamp',string(-1));
%ToDo randomize the pedestrians : Outvalues and TimeValues are the variable
%names

%get output port handles
Ports_v_d = get_param(strcat('MultipleCarsPedestrians/v_d',string(c)),'PortHandles');
Ports_seq_ = get_param(strcat('MultipleCarsPedestrians/seq_',string(c)),'PortHandles');
ped_port = get_param(ped_name1,'PortHandles');

%add arrows to connect
add_line(system_name,Ports_v_d.Outport,ped_port.Inport(1));
add_line(system_name,Ports_seq_.Outport,ped_port.Inport(2));

Objects{c} = initialize_pedestrian_objs(c);
end

%%Add relative position for Avs to get a count of total number of objects%%%
Num_avs_relative = Num_Peds_relative+Num_Avs;

%%%%Create Avs%%%
add_av = 'LargeScaleSimLib/av_simple';
av_name = 'MultipleCarsPedestrians/av';
for c = Num_Peds_relative+1:Num_avs_relative

%Starting the number of avs from 1, but not changing it to keep the value of object different
av_name1 = strcat(av_name,string(c-Num_Peds_relative));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_av,av_name1);

%Make Library link status as inactive
set_param(av_name1,'LinkStatus','inactive');

%Set object name
set_param(av_name1,'MaskValueString',object_name1);

%add input blocks
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/av_v_d',string(c)));
add_block('simulink/Sources/Repeating Sequence Interpolated',strcat('MultipleCarsPedestrians/av_seq_',string(c)));
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/av_v_z',string(c)));
set_param(strcat('MultipleCarsPedestrians/av_v_d',string(c)),'Value',string(rand(10,5,1)));
set_param(strcat('MultipleCarsPedestrians/av_seq_',string(c)),'tsamp',string(-1));
set_param(strcat('MultipleCarsPedestrians/av_v_d',string(c)),'Value',string(0));
%ToDo randomize the pedestrians : Outvalues and TimeValues are the variable
%names

%get output port handles
Ports_av_v_d = get_param(strcat('MultipleCarsPedestrians/av_v_d',string(c)),'PortHandles');
Ports_av_seq_ = get_param(strcat('MultipleCarsPedestrians/av_seq_',string(c)),'PortHandles');
Ports_av_v_z = get_param(strcat('MultipleCarsPedestrians/av_v_z',string(c)),'PortHandles');
av_port = get_param(av_name1,'PortHandles');

%add arrows to connect
add_line(system_name,Ports_av_v_d.Outport,av_port.Inport(1));
add_line(system_name,Ports_av_seq_.Outport,av_port.Inport(2));
add_line(system_name,Ports_av_v_z.Outport,av_port.Inport(3));

Objects{c} = initialize_av_objs(c);
end


%%Add relative position for Avs to get a count of total number of objects%%%
Num_acc_cars_relative = Num_avs_relative + Num_Acc_cars;

%%%%Create Acc cars%%%
add_acc = 'LargeScaleSimLib/car_acc';
acc_name = 'MultipleCarsPedestrians/car_acc';
for c = Num_avs_relative+1:Num_acc_cars_relative
   
%Starting the number of acc_cars from 1, but not changing it to keep the value of object different
acc_name1 = strcat(acc_name,string(c-Num_avs_relative));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_acc,acc_name1);

%Make Library link status as inactive
set_param(acc_name1,'LinkStatus','inactive');

%Set object name
set_param(acc_name1,'MaskValueString',object_name1);

%add input blocks
add_block('Simulink/Signal Routing/Mux',strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)));

%get port output and input handles
Ports_
    
end

%%%%Create Auto-Cruise control cars%%%%
% add_acc = 'LargeScaleSimLib/car_acc';
% acc_car_name = 'MultipleCarsPedestrians/car_acc';
% 
% add_block('LargeScaleSimLib/car_acc','MultipleCarsPedestrians/acc_car1');
% set_param('MultipleCarsPedestrians/acc_car1','LinkStatus','inactive');
% set_param('MultipleCarsPedestrians/acc_car1','MaskValueString','Objects{7}');
 Objects{7} = initialize_acc_car_objs(7);

toc()

tic()
%sim(system_name,100)
toc();

