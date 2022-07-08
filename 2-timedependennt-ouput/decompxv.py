#!/usr/bin/python3

outf = open('out-cbn_h.XV','w')
inf1 = open('cbn_h.XV')
inf2 = open('cbn_h.MDX')

nxv = 2
nline = 66

# write cell information
line1 = inf1.readline()
outf.write(line1)
line1 = inf1.readline()
outf.write(line1)
line1 = inf1.readline()
outf.write(line1)
line1 = inf1.readline()
outf.write(line1)

# write atom infromation
index = 1
while(True):
    line2 = inf2.readline()
    if(index > (nline*(nxv-1)+1)):
    	mps = line2.strip().split()
    	outf.write("%3i"%int(mps[0]))
    	outf.write("%6i"%int(mps[1]))
#    	outf.write('  ')
    	outf.write("%18.9f"%float(mps[2]))
    	outf.write("%18.9f"%float(mps[3]))
    	outf.write("%18.9f"%float(mps[4]))
    	outf.write("%18.9f"%float(mps[5]))
    	outf.write("%18.9f"%float(mps[6]))
    	outf.write("%18.9f"%float(mps[7]))
    	outf.write('\n')
    index = index + 1
    if(index > (nline*nxv)):
        break;

outf.close()
inf1.close()
inf2.close()
