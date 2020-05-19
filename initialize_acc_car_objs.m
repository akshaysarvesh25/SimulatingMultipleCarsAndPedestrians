function  t = initialize_acc_car_objs(c)
persistent sensors
Objects{c}.NameStrh = convertStringsToChars(strcat('Car_acc_',string(c)));
Objects{c}.isTeamMember = 1;
Objects{c}.Type = 'Car_acc';
Objects{c}.I = 1600; %kg m^2
Objects{c}.m = 1000; %kg

Objects{c}.vx0 = 0;
Objects{c}.ax0 = 0;
Objects{c}.vy0 = 0;
Objects{c}.omega0 = 0;
Objects{c}.psi0 = 0 * pi/180;
Objects{c}.X0 = -20;
Objects{c}.Y0 = -25;
Objects{c}.init = [Objects{c}.vx0 Objects{c}.ax0 Objects{c}.vy0 Objects{c}.omega0 Objects{c}.psi0 Objects{c}.X0 Objects{c}.Y0 0 0 0]';

Objects{c}.Calpha_f = 60000; % N/rad
Objects{c}.Calpha_r = 60000; % N/rad
Objects{c}.Fyfmax = 60000*10/180*pi;
Objects{c}.Fyrmax = 60000*10/180*pi;
Objects{c}.lr = 1.5; % m
Objects{c}.lf = 1.0; % m

Objects{c}.longctl.psi = 0.707;
Objects{c}.longctl.w = 10;

Objects{c}.vx_threshold1 = 0.1;

Objects{c}.datafreq = 10;
Objects{c}.delaystepssigma = 0.1;
Objects{c}.delaystepsmax = 0.2;


sensors.origin = [1;0];
sensors.orientation = 0; %degrees
sensors.azimuthRange = 160; %degrees
sensors.Range = 30; %m

Objects{c}.sensors = sensors;

t = Objects{c};

end