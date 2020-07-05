import numpy as np
import matplotlib.pyplot as plt
import subprocess
import time
import io
import os
import sys

def start():
    #a = np.loadtxt('test.txt')
    #print(a)
    f=open('test.txt',"r")
    lines=f.readlines()
    lines = np.array(lines)
    print(lines[509])
    print(lines[509][43],lines[509][44],lines[509][45])

    for i in lines[509]:
        print(i.shape[0])
        #f = str(i[43]+i[44]+i[45]+i[46]+i[47])

    print(f)



def start2():
    print("Arg1: ",sys.argv[1])
    print("Arg2: ",sys.argv[2])
    print("Arg3: ",sys.argv[3])
    print("Arg4: ",sys.argv[4])
    print("Arg5 : ",sys.argv[5])
    matlab_string = './../../../../../../usr/local/MATLAB/R2019b/bin/matlab'
    matlab_string1 = ' -nodisplay'
    matlab_string2 = ' -nosplash'
    matlab_string3 = ' -r'
    matlab_string4 = 'try LargeScaleSim('+str(sys.argv[1])+','+str(sys.argv[2])+','+str(sys.argv[3])+','+str(sys.argv[4])+');catch;end;quit;'
    print(matlab_string)
    print(matlab_string1)
    print(matlab_string2)
    print(matlab_string3)
    print(matlab_string4)
    #print(''.join(matlab_string))
    matlabprc1 = subprocess.Popen(['./../../../../../../usr/local/MATLAB/R2019b/bin/matlab','-nodisplay','-nosplash','-r',matlab_string4])

    #matlabprc1 = subprocess.Popen([matlab_string,matlab_string1,matlab_string2,matlab_string3,matlab_string4])
    print(matlabprc1.pid)
    #print(" stdout data : ",matlabprc1.communicate()[0])
    #string_command = 'strace -ewrite -p '+str(matlabprc1.pid)+' -s 500'
    #stream_line = os.popen(string_command)

    t_end = time.time() + 60
    
    time.sleep(int(sys.argv[5]))
    #matlabprc1.terminate()

if __name__ =="__main__":
    #start()
    start2()
