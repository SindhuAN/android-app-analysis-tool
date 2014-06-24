#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage $0 file-for-analysis"
	exit 1
fi

filename='dynamic-analysis.'$1.'txt'
echo $filename

#/home/oper/mobileApps/tools/apktool/./apktool decode $file
#echo "$(grep "uses-permission android:name=" AndroidManifest.$1.xml | sed 's/uses-permission android:name=//g')" > manifest-tmp.txt
#echo "$(sed 's/[<:>/ "]//g' manifest-tmp.txt)" > manifest.$1.txt
echo "$(sort $filename | uniq | wc -l )" >> uniq-calls-dynamic.$1.txt
echo "$(sed 's/[<:>]//g' $filename)" > tmp-dynamic.txt  
echo "$(awk 'BEGIN { FS = " " } ; {printf "%s.%s\n", $1,$3}' tmp-dynamic.txt)" > output-final-dynamic.$1.txt  
echo "$(sort output-final-dynamic.$1.txt | uniq )" > output-final-dynamic-sort.$1.txt
rm tmp-dynamic.txt

#rm manifest-tmp.txt

