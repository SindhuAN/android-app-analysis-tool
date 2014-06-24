#!/bin/bash





for file in ~/mobileApps/results/uniq-calls-dynamic.*
do
#	echo $file
	
	basenamefile=$(basename $file .txt)
	var="$(cat $file)"
	echo "$basenamefile $var " >> uniq-calls-dynamic-stats.csv
	
#	~/mobileApps/tools/apktool/./apktool decode -f $file
#	cd $basenamefile
#	cp AndroidManifest.xml ../
#	cd ..
#	mv AndroidManifest.xml AndroidManifest.$basenamefile.xml

	
#	echo "$(grep -o  "package\(=\)\(.*\)" AndroidManifest.$basenamefile.xml)" > package.txt
#	echo "$(sed 's/package=//g' package.txt )" > package.txt
#	echo "$(sed 's/["]//g' package.txt)" > package.name.$basenamefile.txt
#	cp package.name.$basenamefile.txt package.txt
	

#	read -r packagename<package.name.$basenamefile.txt
#	echo "packagename:$packagename"
#	rm -r $basenamefile
	
#	./run-instr.sh $basenamefile
	#the installation will be accomplished in run-instr
#	adb -s emulator-5554 shell monkey -p $packagename -v 500
#	adb -s emulator-5554 pull /data/data/$packagename/log-out
#	mv log-out dynamic-analysis.$basenamefile.txt
#	adb -s emulator-5554 uninstall $packagename
	

#	./dynamic-modify.sh $basenamefile
#	./static-modify.sh $basenamefile
#	./manifest-perm.sh $basenamefile
	
#	./db-for-dynamic-static-analysis.pl $basenamefile
#	rm package.txt
done


echo "$(sed 's/uniq-calls-dynamic.//g' uniq-calls-dynamic-stats.csv )" > uniq-calls-dynamic-stats.csv


