import subprocess
import os
import signal
import psutil
import time
import re
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def start_1(num_cars,num_peds,num_avs,num_acc_cars,time_taken):

    print('Starting Simulation for ',num_cars,' cars , ',num_peds,' pedestrains , ',num_avs,' AVs , ',num_acc_cars,' Cruise control cars; allowed sim time is : ',time_taken)

    if os.path.isfile("memory_consumed.txt"):
        os.remove("memory_consumed.txt")
    mem_proc = subprocess.Popen(['./mem_log.sh'])

    if os.path.isfile("output_time.txt"):
        os.remove("output_time.txt")

    if os.path.isfile("output.txt"):
        os.remove("output.txt")
    with open("output.txt", "w+") as output:
        subprocess.call(["python3", "./memory_analyzer.py",str(num_cars),str(num_peds),str(num_avs),str(num_acc_cars),str(time_taken)], stdout=output);
    
    print("Done writing data")
    time.sleep(10)

    subprocess.call(["cp","output.txt","output_time.txt"])

    with open('output_time.txt') as f:
        for line in f:
            if 'Time elapsed =' in line:
                print('Found line for simulation time ')
                sim_time = (re.findall("\d+\.\d+",line))
                sim_time_float = list(map(float, sim_time[0].split("*")))

    with open('output_time.txt') as f:
        for line in f:
            if 'Number of edges in the graph =' in line:
                print('Found line for number of edges')
                ned = (re.findall("\d+\.\d+",line))
                ned_int = list(map(float, ned[0].split("*")))


    mem_max = np.loadtxt('memory_consumed.txt')
    mem_max = max(mem_max)
    print("Max memory consumed : ",mem_max)
    sim_time_total = sim_time_float.pop(0)
    print("Total time taken : ",sim_time_total)
    ned_total = ned_int.pop(0)
    print('Number of edges : ',ned_total)


    print("Done loging data")
    #os.killpg(int(subprocess.check_output(["pidof","MATLAB"])), signal.SIGTERM)
    mem_proc.terminate()
    subprocess.call(["pkill","MATLAB"])
    subprocess.call(["pkill","mem_log.sh"])
    print("Done killing process")
    return mem_max,sim_time_total,ned_total


def start_sim():
    #pass arguments to start_1()
    #function interface - cars, peds, avs, acc_cars, time taken for execution
    mem_sim,time_sim,nedges = start_1(1,1,1,1,30)
    start_1(5,2,2,4,30)


def getWeightedNandEbyN(sim_params,edges):
    car_weight = 25
    acc_car_weight = 40
    ped_weight = 17.5
    av_weight = 17.5
    weighted_nodes = (car_weight*sim_params[0])+(ped_weight*sim_params[1])+(av_weight*sim_params[2])+(acc_car_weight*sim_params[3])
    return (edges/weighted_nodes),weighted_nodes

def threeD_plot(mem,time,ebyn,n):
    plot1=plt.plot(ebyn,mem,'k.',label='memory')
    plt.grid()
    plt.legend()
    plt.xlabel('E by weighted N')
    plt.ylabel('Maximum memory consumed in Kilobytes for the simulation to run')
    plt.title('Memory vs E/weighted N')
    plt.show()
    
    plot2=plt.plot(ebyn,time,'r.',label='time')
    plt.grid()
    plt.legend()
    plt.xlabel('E by weighted N')
    plt.ylabel('Time taken for the simualtion to run in seconds')
    plt.title('Simulation time vs E/weighted N')
    plt.show()

def auto_start_sim():
    sim_params = np.loadtxt('sim_configurations.txt')
    sim_params = sim_params.astype(int)
    print(sim_params.shape[0])
    sim_mem = []
    sim_time = []
    weightedEbyN = []
    weightedN = []
    for param in sim_params:
        print(param)
        sim_mem_tmp,sim_time_tmp,sim_nedges_temp = start_1(param[0],param[1],param[2],param[3],param[4])
        sim_mem.append(sim_mem_tmp)
        sim_time.append(sim_time_tmp)
        weightedEbyN_temp,weightedN_temp = getWeightedNandEbyN(param,sim_nedges_temp)
        weightedEbyN.append(weightedEbyN_temp)
        weightedN.append(weightedN_temp)

    print(sim_mem)
    print(sim_time)
    print(weightedEbyN)
    print(weightedN)

    print("Plotting now")
    threeD_plot(sim_mem,sim_time,weightedEbyN,weightedN)


if __name__=="__main__":
    #start_sim()
    auto_start_sim()
