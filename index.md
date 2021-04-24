# Cloudflare DNS Updater
### Dynamically Update IP on Cloudflare DNS

_cfdns v1.0.68 - Created 02/21/21_
_by Lazo Consumer Products, LLC._

Dynamically updates your computer's IP address to your Cloudflare DNS account so that you don't have to worry about updating IP's every time your home ISP's DHCP changes it. Great for running your own website on a Raspberry Pi at home.

## SETUP:

   **PART I**<br>
     Create a directory to house the cfdns script. Your home directory should be a good place, i.e. /home/apps/cfdns.
   
      Make directory structure
      /#: mkdir -pv /home/apps/cfdns
      
      cd into the cfdns directory.
      /#: cd /home/apps/cfdns
      
      create the cfdns.sh file using nano or vim and copy the contents of the script into it.
      /#: nano cfdns.sh
      
      right click to paste (on DietPi)
      
      CTRL X to exit, Y to save, ENTER to write file
      
      
  Be sure to change the Cloudflare API settings:
  
      ## CLOUDFLARE API SETTINGS
      zone_name="domain.com"        # thezone_name is your domain name
      record_name="sub.domain.com"  # the record_name is the complete address, including subdomain
      zone_id="YOUR-CF-ZONE-ID"     # every zone (domain) has an id in cloudflare
      record_id="YOUR-CF-RECORD-ID" # likewise, every subdomain has a zone record id (e.g. subdomain)
      auth_key="YOUR-CF-TOKEN-KEY"  # the cloudflare bearer token key, aka the API key

      
   **PART II**<br>
   Create a file **_"cfdns"_** in **_"/etc/cron.daily/"_** to run script in background.
   
   Add the following contents to the file: 

        #!/bin/bash

        # Run the cfdns.sh script daily
        /home/apps/cfdns/cfdns.sh

  **OR**

        # Within your cron script, add this to run every 2 hours:
        0 */2 * * * /home/apps/cfdns/cfdns.sh
