#!/bin/bash
#
# Supposedly this will send the daily fire weather
#

# I have to use RVM to run ruby on my server
if [ -e "/etc/profile.d/rvm.sh" ]
then
	source /etc/profile.d/rvm.sh
fi

# Bring in the config variables

source "$(pwd)/config"

cd $dir

# Ugly-ass hack for the day of the week
day=$(date | head -c 3)

if [ $day = "Sun" ]; then
	export modday="SUNDAY"
elif [ $day = "Mon" ]; then
	export modday="MONDAY"
elif [ $day = "Tue" ]; then
	export modday="TUESDAY"
elif [ $day = "Wed" ]; then
	export modday="WEDNESDAY"
elif [ $day = "Thu" ]; then
	export modday="THURSDAY"
elif [ $day = "Fri" ]; then
	export modday="FRIDAY"
elif [ $day = "Sat" ]; then
	export modday="SATURDAY"
fi

# Get daily Southwest Area Fire Danger and other info from the SWCC
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/A_01_10_PREPAREDNESS_LEVEL.csv -O SW_Wildfire_Prep.csv
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/G_01_30_Daily_RX_AZ_Website.csv -O Daily_RX_AZ.csv
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/D_04_70_SWCC_Morning_Situation_Report.pdf -O assets/Southwest_Situation_Report.pdf
wget https://www.nifc.gov/nicc/sitreprt.pdf -O assets/National_Situation_Report.pdf
##########################################################

# Simplify Wildfire Preparedness Level
cut -d\, -f2 SW_Wildfire_Prep.csv > level-raw.txt
cut -b106 level-raw.txt > levels.txt
sed -n '1p' levels.txt > sw-level.txt
sed -n '2p' levels.txt > nat-level.txt
export sw=$(cat sw-level.txt)
export us=$(cat nat-level.txt)
echo "<a href=\"assets/Southwest_Situation_Report.pdf\" target=\"_blank\"><img src=\"https://img.shields.io/badge/Southwest-$sw-blue\"></a>&nbsp;<a href=\"assets/National_Situation_Report.pdf\" target=\"_blank\"><img src=\"https://img.shields.io/badge/National-$us-green\"></a><br><font size=\"-3\">Click one for the appropriate situation report.</font>" > _includes/wildfire-prep.html
rm level*.txt
rm SW_Wildfire_Prep.csv
##########################################################

# REGULAR WATCHES / WARNINGS / ADVISORIES
$wxcast text $office AFD > afd-raw.txt
cp afd-raw.txt wwa-raw.txt
sed -n '9,$p' < wwa-raw.txt > wwa-step2.txt
sed -i '/.SYNOPSIS/,/&&/d' wwa-step2.txt
sed -i '/.DISCUSSION/,/&&/d' wwa-step2.txt
sed -i '/.AVIATION/,/&&/d' wwa-step2.txt
sed -i '/.FIRE WEATHER/,/&&/d' wwa-step2.txt
sed -n '6,$p' < wwa-step2.txt > wwa.txt
rm wwa-step2.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '/^$/d' wwa.txt
sed -i '/^\&\&/,$d' wwa.txt
sed -i 's/.TWC WATCHES\/WARNINGS\/ADVISORIES...//' wwa.txt
sed -i 's/$//' wwa.txt
rm wwa-raw.txt
mv wwa.txt _includes
##########################################################

# Remember to just create a LINK to this file hosted on the web since there can be SO much data.
##########################################################
# Get the 7 day forecast for St David and format it.
#$wxcast forecast $location > 7dayfcast.txt
$wxcast forecast "Benson, AZ" > 7dayfcast.txt # Quick hack
sed -i 's/No forecast found for location\: 85630 coordinates\: 31\.902220000000057\,\-110\.21934499999998/The NWS has no forecast available to download for Saint David\./' 7dayfcast.txt
sed -i 's/$/<br>/' 7dayfcast.txt
sed -i 's/Today/<b>Today<\/b>/' 7dayfcast.txt
sed -i 's/Tonight/<br><b>Tonight<\/b>/' 7dayfcast.txt
sed -i 's/Tomorrow/<b>Tomorrow<\/b>/' 7dayfcast.txt
sed -i 's/This/<b>This<\/b>/' 7dayfcast.txt
sed -i 's/Thru/<b>Thru<\/b>/' 7dayfcast.txt
sed -i 's/Afternoon/<b>Afternoon<\/b>/' 7dayfcast.txt
sed -i 's/Evening/<b>Evening<\/b>/' 7dayfcast.txt
sed -i 's/Overnight/<b>Overnight<\/b>/' 7dayfcast.txt
sed -i 's/Day/<b>Day<\/b>/' 7dayfcast.txt
sed -i 's/Night/<b>Night<\/b>/' 7dayfcast.txt
sed -i 's/Eve/<b>Eve<\/b>/' 7dayfcast.txt
sed -i 's/Next/<b>Next<\/b>/' 7dayfcast.txt
sed -i 's/Weekend/<b>Weekend<\/b>/' 7dayfcast.txt
sed -i 's/Week/<b>Week<\/b>/' 7dayfcast.txt
sed -i 's/VeteransDay/<b>Veterans Day<\/b/' 7dayfcast.txt
sed -i 's/Memorial/<b>Memorial<\/b/' 7dayfcast.txt
sed -i 's/Labor/<b>Labor<\/b/' 7dayfcast.txt
sed -i 's/Columbus/<b>Columbus<\/b/' 7dayfcast.txt
sed -i 's/Presidents/<b>Presidents<\/b/' 7dayfcast.txt
sed -i 's/New Years/<b>New Years<\/b/' 7dayfcast.txt
sed -i 's/Independence/<b>Independence<\/b/' 7dayfcast.txt
sed -i 's/Inauguration/<b>Inauguration<\/b/' 7dayfcast.txt
sed -i 's/Valentines/<b>Valentines<\/b/' 7dayfcast.txt
sed -i 's/New Year/<b>New Year<\/b/' 7dayfcast.txt
sed -i 's/Halloween/<b>Halloween<\/b/' 7dayfcast.txt
sed -i 's/Easter/<b>Easter<\/b/' 7dayfcast.txt
sed -i 's/Thanksgiving/<b>Thanksgiving<\/b/' 7dayfcast.txt
sed -i 's/Christmas/<b>Christmas<\/b/' 7dayfcast.txt
sed -i 's/Monday/<br><b>Monday<\/b>/' 7dayfcast.txt
sed -i 's/Tuesday/<br><b>Tuesday<\/b>/' 7dayfcast.txt
sed -i 's/Wednesday/<br><b>Wednesday<\/b>/' 7dayfcast.txt
sed -i 's/Thursday/<br><b>Thursday<\/b>/' 7dayfcast.txt
sed -i 's/Friday/<br><b>Friday<\/b>/' 7dayfcast.txt
sed -i 's/Saturday/<br><b>Saturday<\/b>/' 7dayfcast.txt
sed -i 's/Sunday/<br><b>Sunday<\/b>/' 7dayfcast.txt
sed -i 's/\:/<b>\:<\/b>/' 7dayfcast.txt
mv 7dayfcast.txt _includes
##########################################################

# Get the full Fire Weather Forecast and split out the Discussion
$wxcast text $office FWF > fwf-raw.txt
sed -n '/.DISCUSSION.../,/^$/p' fwf-raw.txt > fwf-disc.txt
sed -i '/.DISCUSSION.../d' fwf-disc.txt
sed -i 's/$/<br>/' fwf-disc.txt
mv fwf-disc.txt _includes
##########################################################

# Pull out just the fire zone forecast
sed -n '/AZZ151/,/$$/p' fwf-raw.txt > zone151.txt
sed -i '1d' zone151.txt
sed -i '$d' zone151.txt
sed -i 's/.FORECAST DAYS 3 THROUGH 7.../<b>FORECAST DAYS 3 THROUGH 7<\/b>/' zone151.txt
sed -i 's/.TODAY.../<b>TODAY\:<\/b>/' zone151.txt
sed -i 's/.TONIGHT.../<b>TONIGHT\:<\/b>/' zone151.txt
sed -i 's/.SUNDAY.../<b>SUNDAY<\/b>\:/' zone151.txt
sed -i 's/.MONDAY.../<b>MONDAY<\/b>\:/' zone151.txt
sed -i 's/.TUESDAY.../<b>TUESDAY<\/b>\:/' zone151.txt
sed -i 's/.WEDNESDAY.../<b>WEDNESDAY<\/b>\:/' zone151.txt
sed -i 's/.THURSDAY.../<b>THURSDAY<\/b>\:/' zone151.txt
sed -i 's/.FRIDAY.../<b>FRIDAY<\/b>\:/' zone151.txt
sed -i 's/.SATURDAY.../<b>SATURDAY<\/b>\:/' zone151.txt
sed -i 's/\* Sky\/Weather\.\.\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Sky\/Weather\: <\/i><\/span>/' zone151.txt
sed -i 's/\* Max Temperature\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Max Temparature\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Mixing Height\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Mixing Height\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Transport Winds\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Transport Winds\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Ventilation Category\.\.\.\.\./<span style="color: orange"><i>Ventilation Category\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Min Temperature\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Min Temparature\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Min Humidity\.\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Min Humidity\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Max Humidity\.\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Max Humidity\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Wind (20 ft\/10-min avg)\.\./<span style="color: orange"><i>Wind (20ft \/ 10min ave)\:<\/i><\/span> /' zone151.txt
sed -i 's/\* 10000 ft MSL Wind\.\.\.\.\.\.\.\./<span style="color: orange"><i>10000 ft MSL Wind\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Chance of Precip\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Chance of Precip\:<\/i><\/span> /' zone151.txt
sed -i 's/pct\./\%\./' zone151.txt
sed -i 's/\* LAL\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>LAL\:<\/i><\/span> /' zone151.txt
sed -i 's/\* Haines Index\.\.\.\.\.\.\.\.\.\.\.\.\./<span style="color: orange"><i>Haines Index\:<\/i><\/span> /' zone151.txt
sed -i 's/\* //' zone151.txt
sed -i 's/\.\.\.\.\.\.\.\.\.\.\./\:<\/i><\/span> /' zone151.txt
sed -i 's/24 hr Trend\:/<span style="color: orange"><i>24 hr Trend\:<\/i><\/span> /' zone151.txt
sed -i 's/$/<br>/' zone151.txt
rm fwf-raw.txt
mv zone151.txt _includes
##########################################################

# This is for the date at the top of the html file
echo "$(date)" > _includes/date.txt

# Build the html file and deploy it.
jekyll build && jekyll deploy

# Clean up disk space
rm $dir/_includes/*.txt
rm $dir/*.csv
