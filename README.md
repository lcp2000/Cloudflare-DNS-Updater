# cfdns
Dynamically Update IP on Cloudflare DNS

cfdns v1.0.68 - Created 02/21/21
by Lazo Consumer Products, LLC.

Dynamically updates your computer's IP address to your Cloudflare DNS account so that you don't have to worry about updating IP's every time your home ISP's DHCP changes it. Great for running your own website on a Raspberry Pi, at home.

  USAGE:
    Use in etc/cron.daily to run script in background schedule
    Creat a file (cfdns.sh) with the following contents: 

        #!/bin/bash

        # Run cfdns daily
        /root/apps/cfdns/cfdns.sh

    OR

        # Within the cron script, run every 2 hours
        0 */2 * * * /root/apps/cfdns/cfdns.sh
