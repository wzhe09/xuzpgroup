#!/usr/bin/python3

temp = open('temp.cube','w')
inf = open('100-cbn_h.cube')

nline = 6912000
index = 1

while(True):
    line = inf.readline()
    mps = line.strip().split()
    if(mps[0] == '1'):
        break;

while(True):
    line = inf.readline()
    temp.write(line)
    index = index + 1
    if(index > nline):
        break;

temp.close()
inf.close()
outf = open('diff.cube','w')
inf1 = open('pri.cube')
inf2 = open('temp.cube')
inf = open('100-cbn_h.cube')

while(True):
    line = inf1.readline()
    outf.write(line)
    mps = line.strip().split()
    if(mps[0] == '1'):
        break;

inf.close()

index = 1

while(True):
    line2 = inf2.readline()
    line1 = inf1.readline()
    mps1 = line1.strip().split()
    mps2 = line2.strip().split()
    res = []
    res.append(float(mps2[0])-float(mps1[0]))
    res.append(float(mps2[1])-float(mps1[1]))
    res.append(float(mps2[2])-float(mps1[2]))
    res.append(float(mps2[3])-float(mps1[3]))
    res.append(float(mps2[4])-float(mps1[4]))
    res.append(float(mps2[5])-float(mps1[5]))
    outf.write('  ')
    for j in res:
        outf.write("%.5e"%float(j))
        outf.write('  ')
    outf.write('\n')
    index = index + 1
    if(index > nline):
        break;

outf.close()
inf1.close()
inf2.close()
