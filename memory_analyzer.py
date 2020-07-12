import numpy as np
import matplotlib.pyplot as plt
import subprocess
import time
import io
import os
import sys




def start2():
    print("Arg1: ",sys.argv[1])
    print("Arg2: ",sys.argv[2])
    print("Arg3: ",sys.argv[3])
    print("Arg4: ",sys.argv[4])
    matlab_string = './../../../../../../usr/local/MATLAB/R2019b/bin/matlab'
    matlab_string1 = ' -nodisplay'
    matlab_string2 = ' -nosplash'
    matlab_string3 = ' -r'
    matlab_string4 = 'try LargeScaleSim('+str(sys.argv[1])+','+str(sys.argv[2])+','+str(sys.argv[3])+','+str(sys.argv[4])+');catch;end;quit force;'
    print(matlab_string)
    print(matlab_string1)
    print(matlab_string2)
    print(matlab_string3)
    print(matlab_string4)
    #print(''.join(matlab_string))
    matlabprc1 = subprocess.call(['./../../../../../../usr/local/MATLAB/R2019b/bin/matlab','-nodisplay','-nosplash','-r',matlab_string4])


if __name__ =="__main__":
    start2()
