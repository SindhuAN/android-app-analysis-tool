#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage $0 file-for-manifest analysis"
	exit 1
fi

echo "$(grep "uses-permission android:name=" AndroidManifest.$1.xml | sed 's/uses-permission android:name=//g')" > manifest-tmp.txt
echo "$(sed 's/[<:>/ "]//g' manifest-tmp.txt)" > manifest-permissions.$1.txt
rm manifest-tmp.txt
