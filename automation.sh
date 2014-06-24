#!/bin/bash

#emulator @AVD_for_Galaxy_Nexus_by_Google

# adb -s emulator-5554 install BalanceBY.apk

#adb -s -d install /home/oper/mobileApps/bening/set-0/BalanceBY.apk

#I should start the tests
#run the app
#copy the data 
#adb -s emulator-5554 uninstall com.example.hello
#I have to change the 

for file in ~/mobileApps/results/*.apk
do
	echo $file
	basenamefile=$(basename $file .apk)
	~/mobileApps/tools/apktool/./apktool decode -f $file
	cd $basenamefile
	cp AndroidManifest.xml ../
	cd ..
	mv AndroidManifest.xml AndroidManifest.$basenamefile.xml

	
	echo "$(grep -o  "package\(=\)\(.*\)" AndroidManifest.$basenamefile.xml)" > package.txt
	echo "$(sed 's/package=//g' package.txt )" > package.txt
	echo "$(sed 's/["]//g' package.txt)" > package.name.$basenamefile.txt
	cp package.name.$basenamefile.txt package.txt
	

	read -r packagename<package.name.$basenamefile.txt
	echo "packagename:$packagename"
	rm -r $basenamefile
	
	./run-instr.sh $basenamefile
	#the installation will be accomplished in run-instr
	adb -s emulator-5554 shell monkey -p $packagename -v 1500
	adb -s emulator-5554 pull /data/data/$packagename/log-out
	mv log-out dynamic-analysis.$basenamefile.txt
	adb -s emulator-5554 uninstall $packagename
	

	./dynamic-modify.sh $basenamefile
	./static-modify.sh $basenamefile
	./manifest-perm.sh $basenamefile
	
	./db-for-dynamic-static-analysis.pl $basenamefile
	#exit
#	rm package.txt
done






