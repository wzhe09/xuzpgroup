#!/bin/sh
#BSUB -J cut
#BSUB -q priority
#BSUB -n 12
#BSUB -o %J.output -e %J.err
#BSUB -W 1480:00
#BSUB -a intelmpi
#BSUB -R "span[ptile=12]"
##relax########
rm -rf  rdrho
mkdir rdrho
cp bader.sh sumspin.py drho.sh cbncube initcube diffcube.py decompxv.py cbn_h.XV cbn_h.MDX rdrho/
cd rdrho
rm -rf initial
mkdir initial
cp initcube initial/
rm -rf sum
mkdir sum
cp diffcube.py sum
#loop
for i in $(seq 100 200 10101)
do
rm -r $i
mkdir $i
cp cbncube cbn_h.XV cbn_h.MDX decompxv.py $i
cp ../$i.TDRho $i/cbn_h.RHO
cd $i
sed -i "7c \nxv = $i" decompxv.py
python decompxv.py
rm cbn_h.XV
cp out-cbn_h.XV cbn_h.XV
./cbncube
cp cbn_h.cube ../sum/$i-cbn_h.cube
cd ..
rm -r $i
done
#Initial
cp cbncube cbn_h.XV cbn_h.MDX decompxv.py initial/
cp ../100.TDRho initial/cbn_h.RHO
cd initial
sed -i "7c \nxv = 100" decompxv.py
python decompxv.py
rm cbn_h.XV
cp out-cbn_h.XV cbn_h.XV
./initcube
cp cbn_h.cube ../sum/pri.cube
cd ..

