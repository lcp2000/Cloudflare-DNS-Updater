# cfdns
Dynamically Update IP on Cloudflare DNS

cfdns v1.0.68 - Created 02/21/21
by Lazo Consumer Products, LLC.

Dynamically updates your computer's IP address to your Cloudflare DNS account so that you don't have to worry about updating IP's every time your home ISP's DHCP changes it. Great for running your own website on a Raspberry Pi, at home.

  USAGE:
    Creat a file _**cfdns.sh**_ in _**/etc/cron.daily/**_ to run script in background.
    Add the following contents to the file: 

        #!/bin/bash

        # Run cfdns daily
        /home/apps/cfdns/cfdns.sh

    OR

        # Within the cron script, run every 2 hours
        0 */2 * * * /home/apps/cfdns/cfdns.sh
