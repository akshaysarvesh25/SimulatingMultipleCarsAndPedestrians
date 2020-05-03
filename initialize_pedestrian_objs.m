function  t = initialize_pedestrian_objs(c)

Objects{c}.NameStrh = convertStringsToChars(strcat('Ped',string(c)));
Objects{c}.isTeamMember = 0;
Objects{c}.Type = 'pedestrian';
Objects{c}.X0 = -90;
Objects{c}.Y0 = -40;
Objects{c}.init = [Objects{c}.X0 Objects{c}.Y0]';

Objects{c}.datafreq = 10;
Objects{c}.delaystepssigma = 0.1;
Objects{c}.delaystepsmax = 0.2;

t = Objects{c};

end