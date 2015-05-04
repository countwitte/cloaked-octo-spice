'''
Created on 3 May 2015

small program to write serial output to a file for plotting a line chart

@author: countwitte@github.com
'''
import serial
import time
import os.path

ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=1)

if os.path.isfile("testtemp.txt"):
    file1 = open('testtemp.txt','a')
else:
    file1 = open("testtemp.txt",'w')
    file1.write("Timestamp,Office,Lounge\n")

while True:
    strline = ser.readline()
    if strline != '':
        ts = time.time()
        strs = strline.split(',')
        str1 = (strs[0].split(':'))[1].strip()
        str2 = (strs[1].split(':'))[1].strip()
        if str1 == '1':
            file1.write(str(ts)+','+str2+','+'\n')
            file1.flush()
        else:
            file1.write(str(ts)+','+','+str2+'\n')
            file1.flush()