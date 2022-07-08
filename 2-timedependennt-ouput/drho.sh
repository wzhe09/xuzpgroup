#!/bin/sh
#BSUB -J cut
#BSUB -q priority
#BSUB -n 12
#BSUB -o %J.output -e %J.err
#BSUB -W 1480:00
#BSUB -a intelmpi
#BSUB -R "span[ptile=12]"
##relax########
# sumspin
cp sumspin.py sum/
cd sum
# initial
cp pri.cube temp.cube
sed -i "5c \outf = open('pri-rho.cube','w')" sumspin.py
sed -i "6c \inf1 = open('pri.cube')" sumspin.py
python sumspin.py
rm temp.cube
#loop
for i in $(seq 100 200 101)
do
cp $i-gra_h.cube temp.cube
sed -i "5c \outf = open('$i-rho.cube','w')" sumspin.py
sed -i "6c \inf1 = open('$i-gra_h.cube')" sumspin.py
python sumspin.py
rm temp.cube
sed -i "4c \inf = open('$i-rho.cube')" diffcube.py
sed -i "25c \inf1 = open('pri-rho.cube')" diffcube.py
sed -i "27c \inf = open('$i-rho.cube')" diffcube.py
python diffcube.py
mv diff.cube $i-diff.cube
#cd ..
done

