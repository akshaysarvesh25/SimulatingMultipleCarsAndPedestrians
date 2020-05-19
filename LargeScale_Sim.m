clc;clear all;close all;
tic()

open_system(new_system('MultipleCarsPedestrians'));
system_name = 'MultipleCarsPedestrians';

object_name = 'Objects{';

Num_Cars = 2;
Num_Peds = 2;
Num_Avs = 2;
Num_Acc_cars = 15;


if((Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2>25)
    Lanes = [0 1 2 3 4 5];
elseif((Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2>15 & (Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2<25)
    Lanes = [0 1 2 3 4];
elseif((Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2>10 & (Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2<15)
    Lanes = [0 1 2 3];
elseif((Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2>5 & (Num_Cars+Num_Peds+Num_Avs+Num_Acc_cars)/2<10)
    Lanes = [0 1 2];
else
    Lanes = [0 1];          
end

%%%%Create cars%%%
add_car = 'LargeScaleSimLib/car';
car_name = 'MultipleCarsPedestrians/Car';
lane_counter_car = 1;
for c = 1:Num_Cars

car_name1 = strcat(car_name,string(c));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_car,car_name1);

%Make Library link status as inactive
set_param(car_name1,'LinkStatus','inactive');

%Set object name
set_param(car_name1,'MaskValueString',object_name1);

%Select car lane randomly from the available lanes
pos = randi(length(Lanes));
Lane_car(lane_counter_car) = Lanes(pos);
lane_counter_car = lane_counter_car + 1;

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
lane_counter_acc = 1;
for c = Num_avs_relative+1:Num_acc_cars_relative
   
%Starting the number of acc_cars from 1, but not changing it to keep the value of object different
acc_name1 = strcat(acc_name,string(c-Num_avs_relative));
object_name1 = strcat(object_name,string(c),'}');
add_block(add_acc,acc_name1);

%Make Library link status as inactive
set_param(acc_name1,'LinkStatus','inactive');

%Set object name
set_param(acc_name1,'MaskValueString',object_name1);

%Select car lane randomly from the available lanes
pos = randi(length(Lanes));
Lane_acc(lane_counter_acc) = Lanes(pos);
lane_counter_acc = lane_counter_acc+1;

%add input blocks
add_block('simulink/Signal Routing/Mux',strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)));
%set_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)),'Inputs',string(8));

%get port output and input handles
Ports_mux = get_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)),'PortHandles');
acc_car_port = get_param(acc_name1,'PortHandles');

%add arrows to connect
add_line(system_name,Ports_mux.Outport,acc_car_port.Inport(1));

Objects{c} = initialize_acc_car_objs(c);
end


%Change the number of inputs to the MUX based on the number of cars in the
%lane
for n = 1:length(Lanes)
   
    acc_cars_indices = find(Lane_acc == Lanes(n))
    cars_indices = find(Lane_car == Lanes(n))
    
    total_inputs_mux = (length(acc_cars_indices)+length(cars_indices))*2
    
    for j = 1:length(acc_cars_indices)
        set_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(j+Num_avs_relative+1)),'Inputs',string(total_inputs_mux));
        mux_ph(j) = get_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(j+Num_avs_relative+1)),'PortHandles');
    end
    
%     counter_1 = 1;
    for j1 = 1:length(cars_indices)
        ph_car = get_param(strcat('MultipleCarsPedestrians/Car',string(j1)),'PortHandles');
        
%         for j2 = 1:length(acc_cars_indices)
%             add_line(system_name,ph.Outport(1),mux_ph(j2).Inport(counter_1));
%             add_line(system_name,ph.Outport(2),mux_ph(j2).Inport(counter_1+1));
%             counter_1 = counter_1+2;
%         end
    end
    
    for j2 = 1:length(acc_cars_indices)
       ph_acc_car = get_param(strcat('MultipleCarsPedestrians/car_acc',string(j1)),'PortHandles');
    end
    
end



toc()

tic()
%sim(system_name,100)
toc();

