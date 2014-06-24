#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage $0 file-for-analysis"
	exit 1
fi

filename='static-analysis.'$1.'txt'
echo $filename

#echo "$(grep "uses-permission android:name=" $1.AndroidManifest.xml | sed 's/uses-permission android:name=//g')" > manifest-tmp.txt
#echo "$(sed 's/[<:>/ "]//g' manifest-tmp.txt)" > $1.manifest.txt
echo "$(sort $filename | uniq | wc -l )" >> uniq-calls-static.$1.txt
echo "$(sed 's/[<:>]//g' $filename)" > tmp-static.txt  
echo "$(awk 'BEGIN { FS = " " } ; {printf "%s.%s\n", $1,$3}' tmp-static.txt)" > output-final-static.$1.txt  
rm tmp-static.txt
#rm manifest-tmp.txt


