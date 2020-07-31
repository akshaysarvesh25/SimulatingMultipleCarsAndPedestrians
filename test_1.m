clc;clear all;close all;

% 
% open_system(new_system('Test'));
% system_name = 'Test';
% %load_system('robotics system toolbox')
% add_block('robotlib/Subscribe','Test/msg_1')

clc;clear all;close all;

%LargeScaleSimPartions(1,1,1,1);

open_system(new_system('MultipleCarsPedestrians'));
system_name = 'MultipleCarsPedestrians';

object_name = 'Objects{';

Num_Cars = 6;
Num_Peds = 1;
Num_Avs = 1;
Num_Acc_cars = 3;

% 
% Num_Cars = num_cars;
% Num_Peds = num_peds;
% Num_Avs = num_avs;
% Num_Acc_cars = num_acc_cars;

%Create lanes depending on the number of vehicles that are present
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
add_car = 'LargeScaleSimLib_old/car';
car_name = 'MultipleCarsPedestrians/Car';
topic_prefix_name = '/Data_Pub_';
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
%pos = randi(length(Lanes));
Lane_car(lane_counter_car) = Lanes(mod(c,length(Lanes))+1);
lane_counter_car = lane_counter_car + 1;

%add input blocks
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/vxd_',string(c)));
add_block('simulink/Commonly Used Blocks/Constant',strcat('MultipleCarsPedestrians/delta_f',string(c)));

%add ROS blocks
add_block('robotlib/Blank Message',strcat('MultipleCarsPedestrians/BM_',string(c)));
add_block('robotlib/Publish',strcat('MultipleCarsPedestrians/Pub_',string(c)));
add_block('simulink/Signal Routing/Bus Assignment',strcat('MultipleCarsPedestrians/BA_',string(c)));

%get port handles for Blank Message and Bus Assignment
Ports_BM_ = get_param(strcat('MultipleCarsPedestrians/BM_',string(c)),'PortHandles');
Ports_BA_ = get_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'PortHandles');

%Connect the BM to BA
add_line(system_name,Ports_BM_.Outport,Ports_BA_.Inport(1));

set_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'AssignedSignals','X,Y')
%set_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'AssignedSignals','Y')

car_port = get_param(car_name1,'PortHandles');
BA_port = get_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'PortHandles');

%Connect the X&Y of cars to the MUX
add_line(system_name,car_port.Outport(1),BA_port.Inport(2));
add_line(system_name,car_port.Outport(2),BA_port.Inport(3));

%Get the port handles for the Cars
Pub_port = get_param(strcat('MultipleCarsPedestrians/Pub_',string(c)),'PortHandles');

%Connect the output of the MUX to the Publish block
add_line(system_name,BA_port.Outport,Pub_port.Inport);

%Modify the topic of the Pub port
set_param(strcat('MultipleCarsPedestrians/Pub_',string(c)),'topic',strcat(topic_prefix_name,string(c)));

%increase the velocity
%set_param(strcat('MultipleCarsPedestrians/vxd_',string(c)),'Value',string(90/(Num_Cars+Num_Acc_cars-c)));

%decrease the velocity
set_param(strcat('MultipleCarsPedestrians/vxd_',string(c)),'Value',string(90/(c)));


set_param(strcat('MultipleCarsPedestrians/delta_f',string(c)),'Value',string(0));

%get output port handles
Ports_vxd = get_param(strcat('MultipleCarsPedestrians/vxd_',string(c)),'PortHandles');
Ports_deltaf = get_param(strcat('MultipleCarsPedestrians/delta_f',string(c)),'PortHandles');


%add arrows to connect
add_line(system_name,Ports_vxd.Outport,car_port.Inport(1));
add_line(system_name,Ports_deltaf.Outport,car_port.Inport(2));

%Initialize objects
Objects{c} = initialize_car_objs(c,Lanes(mod(c,length(Lanes))+1),(Num_Cars+Num_Acc_cars+Num_Avs+Num_Peds));

end


%%Add relative position for pedestrians to get a count of total number of objects%%%
Num_Peds_relative = Num_Peds + Num_Cars;

%%%%Create Pedestrians%%%
add_ped = 'LargeScaleSimLib_old/ped1';
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
add_av = 'LargeScaleSimLib_old/av_simple';
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

Objects{c} = initialize_av_objs(c);%todo:evalint, or specify from simulink model
end


%%Add relative position for Avs to get a count of total number of objects%%%
Num_acc_cars_relative = Num_avs_relative + Num_Acc_cars;

%%%%Create Acc cars%%%
add_acc = 'LargeScaleSimLib_old/car_acc';
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
%pos = randi(length(Lanes));
Lane_acc(lane_counter_acc) = Lanes(mod(c,length(Lanes))+1);
lane_counter_acc = lane_counter_acc+1;

%add input blocks
add_block('simulink/Signal Routing/Mux',strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)));
%set_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)),'Inputs',string(8));


%add ROS blocks
add_block('robotlib/Blank Message',strcat('MultipleCarsPedestrians/BM_',string(c)));
add_block('robotlib/Publish',strcat('MultipleCarsPedestrians/Pub_',string(c)));
add_block('simulink/Signal Routing/Bus Assignment',strcat('MultipleCarsPedestrians/BA_',string(c)));

%get port handles for Blank Message and Bus Assignment
Ports_BM_ = get_param(strcat('MultipleCarsPedestrians/BM_',string(c)),'PortHandles');
Ports_BA_ = get_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'PortHandles');

%Connect the BM to BA
add_line(system_name,Ports_BM_.Outport,Ports_BA_.Inport(1));

set_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'AssignedSignals','X,Y');

acc_car_port = get_param(acc_name1,'PortHandles');

BA_port = get_param(strcat('MultipleCarsPedestrians/BA_',string(c)),'PortHandles');

%Connect the X&Y of cars to the MUX
add_line(system_name,acc_car_port.Outport(1),BA_port.Inport(2));
add_line(system_name,acc_car_port.Outport(2),BA_port.Inport(3));

%Get the port handles for the Cars
Pub_port = get_param(strcat('MultipleCarsPedestrians/Pub_',string(c)),'PortHandles');

%Connect the output of the MUX to the Publish block
add_line(system_name,BA_port.Outport,Pub_port.Inport);

%Modify the topic of the Pub port
set_param(strcat('MultipleCarsPedestrians/Pub_',string(c)),'topic',strcat(topic_prefix_name,string(c)));


%get port output and input handles
Ports_mux = get_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(c)),'PortHandles');


%add arrows to connect
add_line(system_name,Ports_mux.Outport,acc_car_port.Inport(1));

Objects{c} = initialize_acc_car_objs(c,Lanes(mod(c,length(Lanes))+1),(Num_Cars+Num_Acc_cars+Num_Avs+Num_Peds));
end


%Change the number of inputs to the MUX based on the number of cars in the
%lane 
% - OMG! Complicated logic :D
for n = 1:length(Lanes)
   
    acc_cars_indices = find(Lane_acc == Lanes(n))
    cars_indices = find(Lane_car == Lanes(n))
    counter_1 = 1;
    
    car_index = [cars_indices acc_cars_indices]
    
    total_inputs_mux = (length(acc_cars_indices)+length(cars_indices))*2;
    
    
    for j = 1:length(acc_cars_indices)
        set_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(acc_cars_indices(j)+Num_avs_relative)),'Inputs',string(total_inputs_mux));
        mux_ph(j) = get_param(strcat('MultipleCarsPedestrians/acc_car_mux_',string(acc_cars_indices(j)+Num_avs_relative)),'PortHandles');
    end
    
        %Add the subscribers depending on the number of muxes for cars
    for count1 = 1:(length(cars_indices))
        add_block('robotlib/Subscribe',strcat('MultipleCarsPedestrians/Sub_',string(cars_indices(count1))));
        set_param(strcat('MultipleCarsPedestrians/Sub_',string(cars_indices(count1))),'topic',strcat(topic_prefix_name,string(cars_indices(count1))));
        add_block('simulink/Commonly Used Blocks/Bus Selector', strcat('MultipleCarsPedestrians/BusSel_',string(cars_indices(count1))));
        BusSel = get_param(strcat('MultipleCarsPedestrians/BusSel_',string(cars_indices(count1))),'PortHandles');
        Sub_ports = get_param(strcat('MultipleCarsPedestrians/Sub_',string(cars_indices(count1))),'PortHandles');
        add_line(system_name,Sub_ports.Outport(2),BusSel.Inport);
        set_param(strcat('MultipleCarsPedestrians/BusSel_',string(cars_indices(count1))),'OutputSignals','X,Y');
    end
    
        %Add the subscribers depending on the number of muxes for cars
    for count1 = 1:(length(acc_cars_indices))
        add_block('robotlib/Subscribe',strcat('MultipleCarsPedestrians/Sub_',string(acc_cars_indices(count1)+Num_avs_relative)));
        set_param(strcat('MultipleCarsPedestrians/Sub_',string(acc_cars_indices(count1)+Num_avs_relative)),'topic',strcat(topic_prefix_name,string(acc_cars_indices(count1)+Num_avs_relative)));
        add_block('simulink/Commonly Used Blocks/Bus Selector', strcat('MultipleCarsPedestrians/BusSel_',string(acc_cars_indices(count1)+Num_avs_relative)));
        BusSel = get_param(strcat('MultipleCarsPedestrians/BusSel_',string(acc_cars_indices(count1)+Num_avs_relative)),'PortHandles');
        Sub_ports = get_param(strcat('MultipleCarsPedestrians/Sub_',string(acc_cars_indices(count1)+Num_avs_relative)),'PortHandles');
        add_line(system_name,Sub_ports.Outport(2),BusSel.Inport);
        set_param(strcat('MultipleCarsPedestrians/BusSel_',string(acc_cars_indices(count1)+Num_avs_relative)),'OutputSignals','X,Y');
    end
    
    %If there are more than one normal car in the lane
%     if(length(cars_indices)>0)
%         counter_1 = 1;
%         for j1 = 1:length(cars_indices)
%             ph_car = get_param(strcat('MultipleCarsPedestrians/Car',string(cars_indices(j1))),'PortHandles');
% 
% 
% 
%             for j2 = 1:length(acc_cars_indices)
%                 add_line(system_name,ph_car.Outport(1),mux_ph(j2).Inport(counter_1));
%                 add_line(system_name,ph_car.Outport(2),mux_ph(j2).Inport(counter_1+1));
%             end
%             
%             counter_1 = counter_1+2;
% 
%         end
%     end
%     
%     temp = counter_1;
%     
%     %If there are more than one acc car in the lane
%     if(length(acc_cars_indices)>0)
%         counter_2 = temp;
%         for j3 = 1:length(acc_cars_indices)
%             ph_acc_car = get_param(strcat('MultipleCarsPedestrians/car_acc',string(acc_cars_indices(j3))),'PortHandles');
%             
%             for j4 = 1:length(acc_cars_indices)
%                 add_line(system_name,ph_acc_car.Outport(1),mux_ph(j4).Inport(counter_2));
%                 add_line(system_name,ph_acc_car.Outport(2),mux_ph(j4).Inport(counter_2+1));
%             end
%             
%             counter_2 = counter_2+2;
%             
%         end
%     end
    
    
end

options = simset('SrcWorkspace','current');

% toc()
%%%Done creating the system
% warning('off')
% %sim(system_name,0.01,options);
% 
% tstart = tic();
% %Start the system / Simulate the system
% %output1 = sim(system_name,100,options);
% time_elapsed = toc(tstart);
% fprintf('\n\nTime elapsed = %f',time_elapsed);



for lane_ = 1:length(Lanes)
   
    acc_cars_indices = find(Lane_acc == Lanes(lane_))+Num_avs_relative;
    cars_indices = find(Lane_car == Lanes(lane_));
    
    for node_ = 1:length(acc_cars_indices)
        
        if(node_ == 1 || lane_ == 1)
            G = digraph([acc_cars_indices(acc_cars_indices~=acc_cars_indices(node_)) cars_indices],acc_cars_indices(node_));
        
        else
            G = addedge(G,[acc_cars_indices(acc_cars_indices~=acc_cars_indices(node_)) cars_indices],acc_cars_indices(node_));
        end
        
        
        
    end
    
    
end

%figure
%plot(G)
%title('Simulation graph')
fprintf('\n\nNumber of edges in the graph = %f',numedges(G));

%output_return = time_elapsed;
% %Plotting routine XY plot
% car_string = 'output.Car';
% x_data_string = '.Data(:,1)';
% y_data_string = '.Data(:,2)';
% figure;
% for plot_count = 1:(Num_Cars)
%     
%     
%     ts = eval([car_string,num2str(plot_count),x_data_string]);
%     ds = eval([car_string,num2str(plot_count),y_data_string]);
%     plot((ts),(ds));
%     xlabel('x');
%     ylabel('y');
%     title('Plot of X&Y');
%     hold on
%   
% end
% 
% car_string = 'output.Car_acc_';
% for plot_count = Num_avs_relative+1:Num_acc_cars_relative
%     
%     ts = eval([car_string,num2str(plot_count),x_data_string]);
%     ds = eval([car_string,num2str(plot_count),y_data_string]);
%     plot((ts),(ds));
%     xlabel('x');
%     ylabel('y');
%     title('Plot of X&Y');
%     hold on
%     
% end
% %End XY plot
% 
% 
% %Plotting routine X plot
% car_string = 'output.Car';
% data_string = '.Data(:,1)';
% time_string = '.Time(:,1)';
% figure;
% for plot_count = 1:(Num_Cars)
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('X');
%     title('Plot of X vs time');
%     hold on
%   
% end
% 
% car_string = 'output.Car_acc_';
% for plot_count = Num_avs_relative+1:Num_acc_cars_relative
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('X');
%     title('Plot of X vs time');
%     hold on
%   
% end
% %End X plot
% 
% 
% 
% %Plotting routine Y plot
% car_string = 'output.Car';
% data_string = '.Data(:,2)';
% time_string = '.Time(:,1)';
% figure;
% for plot_count = 1:(Num_Cars)
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Y');
%     title('Plot of Y vs time');
%     hold on
%   
% end
% 
% car_string = 'output.Car_acc_';
% for plot_count = Num_avs_relative+1:Num_acc_cars_relative
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Y');
%     title('Plot of Y vs time');
%     hold on
%   
% end
% %%%%%End Y plot
% 
% %Plotting routine Vx plot
% car_string = 'output.Car';
% data_string = '.Data(:,3)';
% time_string = '.Time(:,1)';
% figure;
% for plot_count = 1:(Num_Cars)
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Vx');
%     title('Plot of Vx vs time');
%     hold on
%   
% end
% 
% car_string = 'output.Car_acc_';
% for plot_count = Num_avs_relative+1:Num_acc_cars_relative
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Vx');
%     title('Plot of Vx vs time');
%     hold on
%   
% end
% 
% %%%End Vx plot
% 
% 
% %Plotting routine Vy plot
% car_string = 'output.Car';
% data_string = '.Data(:,4)';
% time_string = '.Time(:,1)';
% figure;
% for plot_count = 1:(Num_Cars)
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Vy');
%     title('Plot of Vy vs time');
%     hold on
%   
% end
% 
% car_string = 'output.Car_acc_';
% for plot_count = Num_avs_relative+1:Num_acc_cars_relative
%     
%     ts = eval([car_string,num2str(plot_count),time_string]);
%     ds = eval([car_string,num2str(plot_count),data_string]);
%     plot((ts),(ds));
%     xlabel('Time');
%     ylabel('Vy');
%     title('Plot of Vy vs time');
%     hold on
%   
% end
% %%%End Vy plot
% 
% op = car_string;