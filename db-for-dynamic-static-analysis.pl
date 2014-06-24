#!/usr/bin/perl -w
 use DBI;
 $dbh = DBI->connect('dbi:mysql:mobileapps;mysql_local_infile=1','root','root')
 or die "Connection Error: $DBI::errstr\n";



$num_args = $#ARGV + 1;
if ($num_args != 1) {
  print "\nUsage: db.pl application-name\n";
  exit;
}

$app_name=$ARGV[0];
#print $app_name;
$file_instr_static = "output-final-static.$app_name.txt";
$file_instr_dynamic = "output-final-dynamic.$app_name.txt";
$file_manif = "manifest-permissions.$app_name.txt";
#file_manif.$app


$table_instr_static = $app_name."Static";
$table_instr_dynamic = $app_name . "Dynamic";
$table_manif= $app_name."Manifest";
$table_view_static = $app_name."ViewStatic";
$table_view_dynamic = $app_name."ViewDynamic";

 
#create the table of the static analysis
print "static loading";
$sql_create_table_static_instr = "create table $table_instr_static (apiName VARCHAR(600) NOT NULL PRIMARY KEY)";
$sth = $dbh->prepare($sql_create_table_static_instr);
$sth->execute or die "SQL Error: $DBI::errstr\n";

$load_instr_static = "LOAD DATA LOCAL INFILE '$file_instr_static' INTO TABLE $table_instr_static FIELDS TERMINATED BY \' \' LINES TERMINATED BY '\n' (apiName)";
$sth = $dbh->prepare($load_instr_static);
$sth->execute or die "SQL Error: $DBI::errstr\n";



#create the table of the dynamic analysis
print "dynamic loading";
$sql_create_table_dynamic_instr = "create table $table_instr_dynamic (apiName VARCHAR(600) NOT NULL PRIMARY KEY)";
$sth = $dbh->prepare($sql_create_table_dynamic_instr);
$sth->execute or die "SQL Error: $DBI::errstr\n";

$load_instr_dynamic = "LOAD DATA LOCAL INFILE '$file_instr_dynamic' INTO TABLE $table_instr_dynamic FIELDS TERMINATED BY \' \' LINES TERMINATED BY '\n' (apiName)";
$sth = $dbh->prepare($load_instr_dynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";


#create the table of manifest
$sql_create_table_manif = "create table $table_manif (permName VARCHAR(400) NOT NULL PRIMARY KEY, used INT DEFAULT 0)";
$sth = $dbh->prepare($sql_create_table_manif);
$sth->execute or die "SQL Error: $DBI::errstr\n";

$load_manifest = "LOAD DATA LOCAL INFILE '$file_manif' INTO TABLE $table_manif FIELDS TERMINATED BY ' ' LINES TERMINATED BY '\n' (permName)";

$sth = $dbh->prepare($load_manifest);
$sth->execute or die "SQL Error: $DBI::errstr\n";

#do first the static-analysis mapping

$mapquerystatic= "select $table_instr_static.apiName, permissionMap.permission from $table_instr_static,permissionMap where $table_instr_static.apiName=permissionMap.API and permission!=''";

$sth = $dbh->prepare($mapquerystatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

 #I should make some kind of processing  
 #$outputtmp = 
 open (MYFILE, '>'.$app_name.'.static-mapping.txt');
 
 print "Static Analysis Against the Map of Stowaway\n";
 
 while (@row = $sth->fetchrow_array) {
	print "@row\n";	
	print MYFILE "@row\n";
	# print "@row\n";
	 #print "first  field:" .  $row[0] . "\n"; #method
	 #print "second field:" .  $row[1] . "\n"; #permission
	 #$permission = $row[1];
	# i need to make an update statement
	#$updatestmt = "UPDATE $table_manif SET used='1' where $table_manif.permName='$permission'";
	#print $updatestmt;
	#$sth2 = $dbh->prepare($updatestmt);
	#sth2->execute or die "SQL Error: $DBI::errstr\n";
	#grep? I should identify if in the manifest exist this permission at the end I should have identify
 	# if any of the permission is unmarked this will means that there are permission that are not used...
	#xrisimopoiwntas ta permission tha mporousame na kanoume ena query 
 } 
 close(MYFILE);

 #$final = "select * from $table_manif where used='0'";
 #$sth = $dbh->prepare($final);
 #$sth->execute or die "SQL Error: $DBI::errstr\n";
 #open (MYFILE, '>overprivileged.txt');
 #print "Permissions do not used:\n";
 #while (@row = $sth->fetchrow_array) {
#	print "@row\n";	
#	print MYFILE "@row\n";
# }
#close (MYFILE);

#print "Creating the view\n";


$permSQLstatic="create view $table_view_static as select $table_instr_static.apiName, permissionMap.permission from $table_instr_static,permissionMap where $table_instr_static.apiName=permissionMap.API and permission!=''";

#print $permSQL; 

$sth = $dbh->prepare($permSQLstatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

open (MYFILE, '>'.$app_name.'.permissionMap-static.txt');

print "Permission Mapping\n";

$permSQLstatic="select $table_instr_static.apiName, permissionMap.permission from $table_instr_static,permissionMap 
where $table_instr_static.apiName=permissionMap.API and permission!=''";

$sth = $dbh->prepare($permSQLstatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";
 
while (@row = $sth->fetchrow_array) {
	print "@row\n";	
	print MYFILE "@row\n";
}

close (MYFILE);

#print "Undeclared permission\n";

#proopen (MYFILE, '>undeclared.txt');

#$undeclaredPerm = "select * from  $table_view where EXISTS (select * from $table_manif where $table_view.permission=$table_manif.permName";
#, 
# where EXIST (select * from $table_manif, where $table_view.permission=$table_manif.permName";

#$undeclaredPerm = "select * from  $table_view where permission not in (select $table_manif.permName from $table_manif)";

#$sth = $dbh->prepare($undeclaredPerm);
#$sth->execute or die "SQL Error: $DBI::errstr\n";

#while (@row = $sth->fetchrow_array) {
#	print "@row\n";
#	print MYFILE "@row\n";
#}

#close (MYFILE);

#print "Declared permission\n";
#$declaredPerm = "select * from  $table_view where permission  in (select $table_manif.permName from $table_manif)";
$declaredPermstatic = "select $table_view_static.apiName, $table_view_static.permission from  $table_view_static, $table_manif where $table_view_static.permission=$table_manif.permName"; 
$sth = $dbh->prepare($declaredPermstatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";
 
print "Static Final Analysis (Declared)\n";

open (MYFILE, '>'.$app_name.'.static-final-analysis.txt');


while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close(MYFILE);


#$undeclaredPerm = "select * from  $table_view where EXISTS (select * from $table_manif where $table_view.permission=$table_manif.permName";
#, 
# where EXIST (select * from $table_manif, where $table_view.permission=$table_manif.permName";

$unusedApisStatic = "select $table_view_static.apiName, $table_view_static.permission from $table_view_static where $table_view_static.permission not in (select $table_manif.permName from $table_manif)";
#$unusedPerm = "select * from $table_view where $table_view.permission not in (select $table_manif.permName from $table_manif)";

$sth = $dbh->prepare($unusedApisStatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

#open (MYFILE, '>api-without-permission-in-manifest.'.$app_name.'.txt');
open (MYFILE, '>'.$app_name.'api-without-permission-in-manifest-static.txt');

print "APIs without permissions\n";

while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close (MYFILE);

open (MYFILE, '>'.$app_name.'.unused-permissions-static.txt');

print "Unused Permissions\n" ;

#$unusedApis = "select $table_view.apiName, $table_view.permission from $table_view where $table_view.permission not in (select $table_manif.permName from $table_manif)";
$unusedPermStatic="select permName from  $table_manif where permName not in (select  $table_view_static.permission from  $table_view_static)";
$sth = $dbh->prepare($unusedPermStatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";



while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}
#end of static analysis

print "Dynamic analysis\n";

####################################################################
###start the dynamic analysis 
#do secondly the dynamic-analysis mapping

$mapquerydynamic= "select $table_instr_dynamic.apiName, permissionMap.permission from $table_instr_dynamic,permissionMap where $table_instr_dynamic.apiName=permissionMap.API and permission!=''";

$sth = $dbh->prepare($mapquerydynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

 #I should make some kind of processing  
 #$outputtmp = 
 open (MYFILE, '>'.$app_name.'.dynamic-mapping.txt');
 
 print "Dynamic Analysis Against the Map of Stowaway\n";
 
 while (@row = $sth->fetchrow_array) {
	print "@row\n";	
	print MYFILE "@row\n";
	# print "@row\n";
	 #print "first  field:" .  $row[0] . "\n"; #method
	 #print "second field:" .  $row[1] . "\n"; #permission
	 #$permission = $row[1];
	# i need to make an update statement
	#$updatestmt = "UPDATE $table_manif SET used='1' where $table_manif.permName='$permission'";
	#print $updatestmt;
	#$sth2 = $dbh->prepare($updatestmt);
	#sth2->execute or die "SQL Error: $DBI::errstr\n";
	#grep? I should identify if in the manifest exist this permission at the end I should have identify
 	# if any of the permission is unmarked this will means that there are permission that are not used...
	#xrisimopoiwntas ta permission tha mporousame na kanoume ena query 
 } 
 close(MYFILE);

 #$final = "select * from $table_manif where used='0'";
 #$sth = $dbh->prepare($final);
 #$sth->execute or die "SQL Error: $DBI::errstr\n";
 #open (MYFILE, '>overprivileged.txt');
 #print "Permissions do not used:\n";
 #while (@row = $sth->fetchrow_array) {
#	print "@row\n";	
#	print MYFILE "@row\n";
# }
#close (MYFILE);

#print "Creating the view\n";


$permSQLdynamic="create view $table_view_dynamic as select $table_instr_dynamic.apiName, permissionMap.permission from $table_instr_dynamic,permissionMap where $table_instr_dynamic.apiName=permissionMap.API and permission!=''";

#print $permSQL; 

$sth = $dbh->prepare($permSQLdynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

open (MYFILE, '>'.$app_name.'.permissionMap-dynamic.txt');

print "Permission Mapping\n";

$permSQLdynamic="select $table_instr_dynamic.apiName, permissionMap.permission from $table_instr_dynamic,permissionMap 
where $table_instr_dynamic.apiName=permissionMap.API and permission!=''";

$sth = $dbh->prepare($permSQLdynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";
 
while (@row = $sth->fetchrow_array) {
	print "@row\n";	
	print MYFILE "@row\n";
}

close (MYFILE);

#print "Undeclared permission\n";

#proopen (MYFILE, '>undeclared.txt');

#$undeclaredPerm = "select * from  $table_view where EXISTS (select * from $table_manif where $table_view.permission=$table_manif.permName";
#, 
# where EXIST (select * from $table_manif, where $table_view.permission=$table_manif.permName";

#$undeclaredPerm = "select * from  $table_view where permission not in (select $table_manif.permName from $table_manif)";

#$sth = $dbh->prepare($undeclaredPerm);
#$sth->execute or die "SQL Error: $DBI::errstr\n";

#while (@row = $sth->fetchrow_array) {
#	print "@row\n";
#	print MYFILE "@row\n";
#}

#close (MYFILE);

#print "Declared permission\n";
#$declaredPerm = "select * from  $table_view where permission  in (select $table_manif.permName from $table_manif)";

$declaredPermdynamic = "select $table_view_dynamic.apiName, $table_view_dynamic.permission from  $table_view_dynamic, $table_manif where $table_view_dynamic.permission=$table_manif.permName"; 
$sth = $dbh->prepare($declaredPermdynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";
 
print "Dynamic Final Analysis (Declared)\n";

open (MYFILE, '>'.$app_name.'.dynamic-final-analysis.txt');


while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close(MYFILE);


#$undeclaredPerm = "select * from  $table_view where EXISTS (select * from $table_manif where $table_view.permission=$table_manif.permName";
#, 
# where EXIST (select * from $table_manif, where $table_view.permission=$table_manif.permName";

$unusedApisDynamic = "select $table_view_dynamic.apiName, $table_view_dynamic.permission from $table_view_dynamic where $table_view_dynamic.permission not in (select $table_manif.permName from $table_manif)";
#$unusedPerm = "select * from $table_view where $table_view.permission not in (select $table_manif.permName from $table_manif)";

$sth = $dbh->prepare($unusedApisDynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

#open (MYFILE, '>api-without-permission-in-manifest.'.$app_name.'.txt');
open (MYFILE, '>'.$app_name.'api-without-permission-in-manifest-dynamic.txt');

print "APIs dynamic without permissions\n";

while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close (MYFILE);

open (MYFILE, '>'.$app_name.'.unused-permissions-dynamic.txt');

print "Unused Permissions\n" ;

#$unusedApis = "select $table_view.apiName, $table_view.permission from $table_view where $table_view.permission not in (select $table_manif.permName from $table_manif)";
$unusedPermDynamic="select permName from  $table_manif where permName not in (select  $table_view_dynamic.permission from  $table_view_dynamic)";
$sth = $dbh->prepare($unusedPermDynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";



while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close (MYFILE);

####################################################################

open (MYFILE, '>'.$app_name.'.static-dynamic-similarities.txt');

#joining the tables 
print "Similarities\n";

$similarity="select $table_view_dynamic.apiName, $table_view_dynamic.permission from $table_view_dynamic,$table_view_static where $table_view_dynamic.apiName=$table_view_static.apiName and $table_view_dynamic.permission=$table_view_static.permission";

$sth = $dbh->prepare($similarity);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}

close (MYFILE);


####################################################################

####################################################################

print "Static Not in dynamic\n";

open (MYFILE, '>'.$app_name.'.static-not-in-dynamic.txt');

$notindynamic = "select $table_view_static.apiName,$table_view_static.permission from $table_view_static where $table_view_static.apiName not in (select $table_view_dynamic.apiName from  $table_view_dynamic)";

$sth = $dbh->prepare($notindynamic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}


close (MYFILE);


print "Dynamic Not in static\n";


open (MYFILE, '>'.$app_name.'.dynamic-not-in-static.txt');

$notinstatic = "select $table_view_dynamic.apiName,$table_view_dynamic.permission from $table_view_dynamic where $table_view_dynamic.apiName not in (select $table_view_static.apiName from  $table_view_static)";

$sth = $dbh->prepare($notinstatic);
$sth->execute or die "SQL Error: $DBI::errstr\n";

while (@row = $sth->fetchrow_array) {
	print "@row\n";
	print MYFILE "@row\n";
}
close(MYFILE);

####################################################################


 $drop1 = "drop table $table_instr_dynamic";
 $drop2 = "drop table $table_instr_static";
 $drop3 = "drop table $table_manif";
 $drop4 = "drop view  $table_view_static";
 $drop5 = "drop view  $table_view_dynamic";

 $sth = $dbh->prepare( $drop1);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

 $sth = $dbh->prepare( $drop2);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

 $sth = $dbh->prepare( $drop3);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

 $sth = $dbh->prepare( $drop4);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

 $sth = $dbh->prepare( $drop5);
 $sth->execute or die "SQL Error: $DBI::errstr\n";

