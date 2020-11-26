## Fire Weather Forecast

This script is licensed under the GPL 3.0 and may be modified and shared provided the original author is credited by leaving the footer.html file
as-is.

Currently, this script is set up for use by [Animas Fire & Rescue](https://www.animasfire.com).  
It is also currently used (in modified form) by the [Saint David Fire Distict](http://www.stdavidfire.com).

>This script requires the wxcast Python3 library and requires some configuration and the use of crontab and the mail commands.

**For some reason, the NWS has issues with their 7-day forecast feed that causes a "No forecast found" message
to be sometimes be returned.  This is a KNOWN issue and the NWS has no plans to fix it.**

1. Install by issuing "sudo pip3 install wxcast" on the command line.
2. Set the required variables in the config file
3. Copy your department's logo to the webhome directory.
4. Copy the LICENSE file to the webhome directory.
5. Use crontab -e to set the frequency the script will be ran.
   It is recommended to run it at least every hour.
6. Use crontab -e to set when to send the email reminder.
   I send it out once per day.

>To make the script usable for you, you're going to need to do some research as to URLS for the fire danger, preparedness levels and
the prescribed burns.  You're also going to have tinker with formatting the wxcast output for your specific area.  Little did I know
that the data entered for each report type is NOT necessarily standard.
