#!/usr/bin/python3

import numpy as np

outf = open('sumrho.cube','w')
inf1 = open('rho.cube')
inf2 = open('temp.cube')

line = inf1.readline()
outf.write(line)
line = inf1.readline()
outf.write(line)
line = inf1.readline()
outf.write(line)
mps  = line.strip().split()
na   = int(mps[0])

line = inf1.readline()
outf.write(line)
mps  = line.strip().split()
n1   = int(mps[0])
line = inf1.readline()
outf.write(line)
mps  = line.strip().split()
n2   = int(mps[0])
line = inf1.readline()
outf.write(line)
mps  = line.strip().split()
n3   = int(mps[0])

index = 1
while(True):
    line = inf1.readline()
    outf.write(line)
    index = index + 1
    if(index > na):
        break;

for i in range(6+na):
	inf2.readline()

nline = n1*n2*n3/6
index = 1

while(True):
	line = inf2.readline()
	if(index > nline):
		break;
	index = index + 1

index = 1
while(True):
	line1 = inf1.readline()
	mps1  = line1.strip().split()
	line2 = inf2.readline()
	mps2  = line2.strip().split()
	for i in range(6):
		mps = float(mps1[i])+float(mps2[i])
		outf.write('  ')
		outf.write("%.5E"%mps)
	outf.write('\n')
	index = index + 1
	if(index > nline):
		break;

inf1.close()
inf2.close()
outf.close()
