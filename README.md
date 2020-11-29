<!-- Required extensions: mdx_gh_links, markdown.higlight -->
# Fire Weather Forecast

This script is licensed under the GPL 3.0 and may be modified and shared provided the original author is credited by leaving the footer.html file as-is.  ***There is NO support for this repo.***

## Take the time to read the WARRANTY file.   DO NOT USE THIS SOFTWARE FOR CRITICAL OR LIFE-SAFETY FUNCTIONS OR DECISIONS!

It is currently in use by the [Saint David Fire Distict](http://www.stdavidfire.com/firewx).

>This script requires python3, the [wxcast](https://github.com/smarlowucf/wxcast) Python3 library, ruby, [jekyll](https://jekyllrb.com/docs/), [sed](https://www.gnu.org/software/sed/manual/sed.html), [tr](https://linuxize.com/post/linux-tr-command/), [awk](https://www.tutorialspoint.com/unix_commands/awk.htm), [cut](https://www.computerhope.com/unix/ucut.htm) and requires some configuration and the use of [crontab](https://www.tutorialspoint.com/unix_commands/crontab.htm) and the mail commands.  Before trying to use this repo, you should become VERY familiar with jekyll, sed cut, awk and tr.

DIFFICULTY LEVEL: **MODERATE**

1. Install ruby using your package manager (sudo [package manager name] install python3 ruby gcc make).
2. Install jekyll (sudo gem install jekyll).
3. Install wxcast (sudo pip3 install wxcast).
4. Set the required variables in the config file.
5. Set the required variables in the index.md file.
6. Copy your department's logo to the images directory.
7. Use crontab -e to set the frequency that weather.sh will be ran.  It is recommended to run it at least every hour.
8. Use crontab -e to set how often to run send-mail.sh.
   I send it out once per day.

**SOME ASSEMBLY REQUIRED:**
To make the script usable for you, you're going to need to do some research as to URLS for the fire danger, preparedness levels and the prescribed burns.  You're also going to have tinker with formatting the wxcast output for your specific area.  Little did I know that the data entered for each report type is NOT necessarily standard across NWS offices.

**For some reason, the NWS has issues with their 7-day forecast feed that causes a "No forecast found" message
to be sometimes be returned.  This is a KNOWN issue and the NWS has no plans to fix it.**