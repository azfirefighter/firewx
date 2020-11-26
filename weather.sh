#!/bin/sh
#
# Supposedly this will send the daily fire weather
#

source ./config

cd $dir

cp site.webmanifest $webhome
cp LICENSE $webhome

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
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/F_01_50_Daily_Fire_Danger_DISPATCH.jpg -O $webhome/FireDanger.jpg
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/A_01_10_PREPAREDNESS_LEVEL.csv -O $webhome/SW_Wildfire_Prep.csv
wget https://gacc.nifc.gov/swcc/predictive/intelligence/daily/UPLOAD_Files_toSWCC/G_01_30_Daily_RX_AZ_Website.csv -O $webhome/Daily_RX_AZ.csv
##########################################################

# REGULAR WATCHES / WARNINGS / ADVISORIES
$wxcast text TWC AFD > afd-raw.txt
cp afd-raw.txt wwa-raw.txt
sed -n '9,$p' < wwa-raw.txt > wwa-step2.txt
sed -i '/.SYNOPSIS/,/&&/d' wwa-step2.txt
sed -i '/.DISCUSSION/,/&&/d' wwa-step2.txt
sed -i '/.AVIATION/,/&&/d' wwa-step2.txt
sed -i '/.FIRE WEATHER/,/&&/d' wwa-step2.txt
sed -n '6,$p' < wwa-step2.txt > wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '$d' wwa.txt
sed -i '/^$/d' wwa.txt
sed -i '/^\&\&/,$d' wwa.txt
#sed -i '/^.TWC WATCHES\/WARNINGS\/ADVISORIES.../d' wwa.txt
sed -i 's/.TWC WATCHES\/WARNINGS\/ADVISORIES...//' wwa.txt
sed -i 's/$/<br><\/p>/' wwa.txt
##########################################################

# Remember to just create a LINK to this file hosted on the web since there can be SO much data.
##########################################################
# Get the 7 day forecast for St David
$wxcast forecast 85630 > 7dayfcast.txt
sed -i 's/No forecast found for location\: 85630 coordinates\: 31\.902220000000057\,\-110\.21934499999998/The NWS has no forecast available to download for Saint David\./' 7dayfcast.txt
sed -i 's/\:/<b>\:<\/b>/' 7dayfcast.txt
sed -i 's/Today/<b>Today<\/b>/' 7dayfcast.txt
sed -i 's/Tonight/<b>Tonight<\/b>/' 7dayfcast.txt
sed -i 's/Tomorrow/<b>Tomorrow<\/b>/' 7dayfcast.txt
sed -i 's/This/<b>This<\/b>/' 7dayfcast.txt
sed -i 's/Thru/<b>Thru<\/b>/' 7dayfcast.txt
sed -i 's/Afternoon/<b>Afternoon<\/b>/' 7dayfcast.txt
sed -i 's/Evening/<b>Evening<\/b>/' 7dayfcast.txt
#sed -i 's/Over/<b>Over<\/b>/' 7dayfcast.txt
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
sed -i 's/$/<br>/' 7dayfcast.txt
##########################################################

# Get the area discussion
cp afd-raw.txt afd.txt
sed -i '/000/,/2020/d' afd.txt
sed -i '/.AVIATION.../,/&&/d' afd.txt
sed -i '/.FIRE WEATHER.../,/&&/d' afd.txt
sed -i '/.TWC WATCHES\/WARNINGS\/ADVISORIES.../,/&&/d' afd.txt
sed -i 's/.SYNOPSIS.../<p><b>SYNOPSIS<\/b><br>/' afd.txt
sed -i 's/.DISCUSSION.../<\/p><p><b>DISCUSSION<\/b><br>/' afd.txt
sed -i 's/&&/<\/p>/' afd.txt
sed -i '/^\$\$/Q' afd.txt
##########################################################

# Get the full Fire Weather Forecast
$wxcast text TWC FWF > fwf-raw.txt
cp fwf-raw.txt fwf-disc.txt
sed -i '/000/,/\+/d' fwf-disc.txt
sed -i '/AZZ150/Q' fwf-disc.txt
sed -e '1,4d' < fwf-disc.txt > fwf.txt
sed -i 's/.DISCUSSION.../<b>DISCUSSION: <\/b><br>/' fwf.txt
sed -i '$d' fwf.txt
sed -i '$d' fwf.txt
sed -i '$d' fwf.txt
sed -i '$d' fwf.txt
sed -i 's/$/<br>/' fwf.txt
##########################################################

# Pull out just the fire zone forecast
sed -n '/AZZ151/,/$$/p' fwf-raw.txt > zone151.txt
sed -i '/AZZ/,/2020/d' zone151.txt
sed -i '/.FORECAST DAYS 3 THROUGH 7.../,$d' zone151.txt
#sed -i '1i<pre>' zone151.txt
sed -i 's/.TODAY.../<b>TODAY<\/b>/' zone151.txt
sed -i 's/.TONIGHT.../<b>TONIGHT<\/b>/' zone151.txt
sed -i 's/.SUNDAY.../<b>SUNDAY<\/b>/' zone151.txt
sed -i 's/.MONDAY.../<b>MONDAY<\/b>/' zone151.txt
sed -i 's/.TUESDAY.../<b>TUESDAY<\/b>/' zone151.txt
sed -i 's/.WEDNESDAY.../<b>WEDNESDAY<\/b>/' zone151.txt
sed -i 's/.THURSDAY.../<b>THURSDAY<\/b>/' zone151.txt
sed -i 's/.FRIDAY.../<b>FRIDAY<\/b>/' zone151.txt
sed -i 's/.SATURDAY.../<b>SATURDAY<\/b>/' zone151.txt
sed -i 's/$/<br>/' zone151.txt
#echo "</pre>" >> zone151.txt
##########################################################

# Put it all together!
#
# Headers and Menu
cat header.html > DailyWeather.html
echo "<font color='yellow'>$(TZ='America/Phoenix' date)</font></h6>" >> DailyWeather.html

# Preparedness Levels
echo '<p id="prep"><div id="shadowbox"><b>WILDFIRE PREPAREDNESS LEVELS</b></br>' >> DailyWeather.html
cat  wildfire-prep.html >> DailyWeather.html
echo '</div></p>' >> DailyWeather.html

# Daily Prescribed Burns
echo '<p id="burns"><div id="shadowbox"><b>DAILY PRESCRIBED BURNS (STATEWIDE)</b></br>' >> DailyWeather.html
cat RX_Planned_AZ.html >> DailyWeather.html
echo "</div></p>" >> DailyWeather.html

# SWCC Daily Southwest Area Fire Danger
echo '<p id="dngr"><div id="shadowbox"><b>SOUTHWEST AREA FIRE DANGER</b></br>' >> DailyWeather.html
echo '<a href="https://www.lltodd.family/firewx/FireDanger.jpg" target="_blank"><img src="https://www.lltodd.family/firewx/FireDanger.jpg" width="25%"></a></br>' >> DailyWeather.html
echo 'Click to enlarge.</div></p>' >> DailyWeather.html

# TWC WATCHES/WARNINGS/ADVISORIES
echo '<p id="wwa"><div id="shadowbox"><b>WATCHES/WARNINGS/ADVISORIES</b></br><blockquote>' >> DailyWeather.html
cat wwa.txt >> DailyWeather.html
echo "</blockquote></div></p>" >> DailyWeather.html

# 7-DAY FORECAST
echo '<p id="7day"><div id="shadowbox"><b>7-DAY FORECAST</b></br><blockquote>' >> DailyWeather.html
cat 7dayfcast.txt >> DailyWeather.html
echo "</blockquote></div></p>" >> DailyWeather.html

# AREA DISCUSSION
echo '<p id="awd"><div id="shadowbox"><b>AREA DISCUSSION</b></br><blockquote>' >> DailyWeather.html
cat afd.txt >> DailyWeather.html
echo "</blockquote></div></p>" >> DailyWeather.html

# ZONE 151 FORECAST
echo '<p id="zone"><div id="shadowbox"><b>ZONE 151 FORECAST</b></br><blockquote>' >> DailyWeather.html
cat zone151.txt >> DailyWeather.html
echo "</blockquote></div></p>" >> DailyWeather.html

#
# ADD THE FOOTER
cat footer.html >> DailyWeather.html

##########################################################

# Copy the report to a web page

cp DailyWeather.html $webhome/index.html
rm $dir/DailyWeather.html
##########################################################


# Clean up the disk space
rm $dir/*.txt
