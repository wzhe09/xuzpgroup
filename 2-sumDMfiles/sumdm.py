#!/usr/bin/python3
import sys

outf = open('gra_h.DM','w')
inf1 = open('base.DM')   # check order of input file!
inf2 = open('h.DM')

## orbitals and spins
line1  = inf1.readline()
mps1   = line1.strip().split()
no1    = int(mps1[0])
nspin1 = int(mps1[1])
line2  = inf2.readline()
mps2   = line2.strip().split()
no2    = int(mps2[0])
nspin2 = int(mps2[1])
if(nspin1 != nspin2):
	print('Error: numbers of spin are not equal')
	sys.exit(0)

no = no1 + no2
outf.write(str("%12d"%no)+str("%12d"%nspin1)+'\n')

## sparse format
# index
spn1 = no1 // 6 + 1
spn2 = no2 // 6 + 1
res = []
for i in range(spn1):
	line1 = inf1.readline()
	mps1  = line1.strip().split()
	for j in mps1:
		res.append(j)
for i in range(spn2):
	line2 = inf2.readline()
	mps2  = line2.strip().split()
	for j in mps2:
		res.append(j)

i = 1
for j in res:
	outf.write(str("%12d"%int(j)))
	if(i%6 == 0):
		outf.write('\n')
	i = i + 1
if(i%6 != 0):
	outf.write('\n')

# write sparse
sp1 = res[0:no1]
sp2 = res[no1:no]
for i in range(no1):
	spnline = int(res[i]) // 6 + 1
	for j in range(spnline):
		line1 = inf1.readline()
		outf.write(line1)
for i in range(no2):
	spnline = int(res[i+no1]) // 6 + 1
	for j in range(spnline):
		line2 = inf2.readline()
		mps2  = line2.strip().split()
		for k in mps2:
			outf.write(str("%12d"%(int(k)+no1)))
		outf.write('\n')

## density matrix element
# write element
for i in range(no1):
	spnline = int(res[i]) // 3 + 1
	for j in range(spnline):
		line1 = inf1.readline()
		outf.write(line1)
for i in range(no2):
	spnline = int(res[i+no1]) // 3 + 1
	for j in range(spnline):
		line2 = inf2.readline()
		outf.write(line2)

# if nspin == 2, write element * 2
if (nspin1 == 2):
	for i in range(no1):
		spnline = int(res[i]) // 3 + 1
		for j in range(spnline):
			line1 = inf1.readline()
			outf.write(line1)
	for i in range(no2):
		spnline = int(res[i+no1]) // 3 + 1
		for j in range(spnline):
			line2 = inf2.readline()
			outf.write(line2)

outf.close()
inf1.close()
inf2.close()
