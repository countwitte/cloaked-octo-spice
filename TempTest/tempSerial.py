'''
Created on 3 May 2015

@author: michael
'''
import serial
import time

ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=1)

file1 = open('testtemp.txt','w')

while True:
    strline = ser.readline()
    if strline != '':
        ts = time.time()
        strs = strline.split(',')
        str1 = (strs[0].split(':'))[1].strip()
        str2 = (strs[1].split(':'))[1].strip()
        file1.write(str(ts)+','+str1+','+str2+'\n')
        file1.flush()
        print strline