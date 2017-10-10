#!/bin/bash


mkdir build/files -p
cd build/files 
wget -O- get.pharo.org/60+vmT | bash
./pharo-ui Pharo eval --save "  Metacello new baseline: 'SmartShackle'; repository: 'github://RMODINRIA-Blockchain/SmartShackle/src'; load. "
cd ..
cp ../*.sh .
cp ../*.st .
cp ../contracts . -r
rm build.sh 
cd .. 
