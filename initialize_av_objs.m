function  t = initialize_av_objs(c)

Objects{c}.NameStrh = convertStringsToChars(strcat('av',string(c)));
Objects{c}.isTeamMember = 1;
Objects{c}.Type = 'av';
Objects{c}.X0 = -60;
Objects{c}.Y0 = -60;
Objects{c}.Z0 = 15;
Objects{c}.init = [Objects{c}.X0 Objects{c}.Y0 Objects{c}.Z0]';

Objects{c}.datafreq = 10;
Objects{c}.delaystepssigma = 0.1;
Objects{c}.delaystepsmax = 0.2;

sensors.origin = [0;0];
sensors.orientation = 0; %degrees
sensors.azimuthRange = 120; %degrees
sensors.Range = 30; %m
Objects{c}.sensors = sensors;
t = Objects{c};

end