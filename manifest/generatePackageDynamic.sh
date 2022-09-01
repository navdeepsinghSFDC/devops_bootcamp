#Have an authenticated default username
#Then call this with: bash -ex manifest/generatePackageDynamic.sh
#to generate a package xml for dashboards, email templates, reports, and their folders.

rm -f manifest/packageDynamic.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> manifest/packageDynamic.xml
echo "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">" >> manifest/packageDynamic.xml
rm -f temp.txt
rm -f temp.json
sfdx force:mdapi:listmetadata --metadatatype=DashboardFolder --json > temp.json
jq .result.fullName temp.json >> temp.txt || true
jq .result[].fullName temp.json >> temp.txt || true
input="temp.txt"
echo "	<types>" >> manifest/packageDynamic.xml
while IFS= read -r line
do
	folderName="${line//\"/}"
	echo "		<members>$folderName</members>" >> manifest/packageDynamic.xml
	rm -f temp1.json
	rm -f temp1.txt
	sfdx force:mdapi:listmetadata --metadatatype=Dashboard --folder=$folderName --json > temp1.json
	jq .result.fullName temp1.json >> temp1.txt || true
	jq .result[].fullName temp1.json >> temp1.txt || true
	while IFS= read -r line1
	do
		dashboardName="${line1//\"/}"
		echo "		<members>$dashboardName</members>" >> manifest/packageDynamic.xml
	done < "temp1.txt"
	rm -f temp1.json
	rm -f temp1.txt
done < "$input"
echo "		<name>Dashboard</name>" >> manifest/packageDynamic.xml
echo "	</types>" >> manifest/packageDynamic.xml
rm -f temp.txt
rm -f temp.json
sfdx force:mdapi:listmetadata --metadatatype=EmailFolder --json > temp.json
jq .result.fullName temp.json >> temp.txt || true
jq .result[].fullName temp.json >> temp.txt || true
input="temp.txt"
echo "	<types>" >> manifest/packageDynamic.xml
while IFS= read -r line
do
	folderName="${line//\"/}"
	echo "		<members>$folderName</members>" >> manifest/packageDynamic.xml  
	rm -f temp1.json
	rm -f temp1.txt
	sfdx force:mdapi:listmetadata --metadatatype=EmailTemplate --folder=$folderName --json > temp1.json
	jq .result.fullName temp1.json >> temp1.txt || true
	jq .result[].fullName temp1.json >> temp1.txt || true
	while IFS= read -r line1
	do
		templateName="${line1//\"/}"
		echo "		<members>$templateName</members>" >> manifest/packageDynamic.xml
	done < "temp1.txt"
	rm -f temp1.json
	rm -f temp1.txt
done < "$input"
echo "		<name>EmailTemplate</name>" >> manifest/packageDynamic.xml
echo "	</types>" >> manifest/packageDynamic.xml
rm -f temp.txt
rm -f temp.json
sfdx force:mdapi:listmetadata --metadatatype=ReportFolder --json > temp.json
jq .result.fullName temp.json >> temp.txt || true
jq .result[].fullName temp.json >> temp.txt || true
input="temp.txt"
echo "	<types>" >> manifest/packageDynamic.xml
while IFS= read -r line
do
	folderName="${line//\"/}"
	echo "		<members>$folderName</members>" >> manifest/packageDynamic.xml
	rm -f temp1.json
	rm -f temp1.txt
	sfdx force:mdapi:listmetadata --metadatatype=Report --folder=$folderName --json > temp1.json
	jq .result.fullName temp1.json >> temp1.txt || true
	jq .result[].fullName temp1.json >> temp1.txt || true
	while IFS= read -r line1
	do
		reportName="${line1//\"/}"
		echo "		<members>$reportName</members>" >> manifest/packageDynamic.xml
	done < "temp1.txt"
	rm -f temp1.json
	rm -f temp1.txt
done < "$input"
echo "		<name>Report</name>" >> manifest/packageDynamic.xml
echo "	</types>" >> manifest/packageDynamic.xml
rm -f temp.txt
rm -f temp.json
echo "	<version>55.0</version>" >> manifest/packageDynamic.xml
echo "</Package>" >> manifest/packageDynamic.xml
