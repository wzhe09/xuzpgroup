#!/bin/sh
#BSUB -J cut
#BSUB -q priority
#BSUB -n 12
#BSUB -o %J.output -e %J.err
#BSUB -W 1480:00
#BSUB -a intelmpi
#BSUB -R "span[ptile=12]"
##relax########
for time in 10201
do
#TDBader
for i in $(seq 100 200 $time)
do
rm -r $i
mkdir $i
cp cbncube cbn_h.XV cbn_h.MDX decompxv.py $i
cp ../$i.TDBader $i/cbn_h.RHO
cd $i
sed -i "7c \nxv = $i" decompxv.py
python decompxv.py
rm cbn_h.XV
cp out-cbn_h.XV cbn_h.XV
./cbncube
cp cbn_h.cube ../sum/$i-bader.cube
cd ..
rm -r $i
done
#sumspin
cp sumspin.py sum/
cd sum
for i in $(seq 100 200 $time)
do
cp $i-cbn_h.cube temp.cube
sed -i "5c \outf = open('$i-rho.cube','w')" sumspin.py
sed -i "6c \inf1 = open('$i-cbn_h.cube')" sumspin.py
python sumspin.py
rm temp.cube
done
#bader
rm -rf rebader
mkdir rebader
cp /home/cnmm/WORK1/wanzhen/02_vasp/bader/bader ./
for i in $(seq 100 200 $time)
do
./bader $i-rho.cube -ref $i-bader.cube
cp ACF.dat rebader/$i-ACF.dat
#cp BCF.dat rebader/$i-BCF.dat
#cp AVF.dat rebader/$i-AVF.dat
done
rm ACF.dat BCF.dat AVF.dat
done
