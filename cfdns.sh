#!/bin/sh
##
##  Dynamically Update IP on Cloudflare DNS
##
##     cfdns v1.0.68 - Created 02/21/21
##      by Lazo Consumer Products, LLC.
##
##  USAGE:
##    Use in etc/cron.daily to run script in background schedule
##    Creat a file (cfdns.sh) with the following contents: 
##
##        #!/bin/bash
##
##        # Run cfdns daily
##        /root/apps/cfdns/cfdns.sh
##
##    OR
##
##        # Within the cron script, run every 2 hours
##        0 */2 * * * /root/apps/cfdns/cfdns.sh
##
#####################################################################

## CLOUDFLARE API SETTINGS
zone_name="domain.com"
record_name="sub.domain.com" 	# the record_name is the complete address, including subdomain
zone_id="YOUR-CF-ZONE-ID" 		# every zone (domain) has an id in cloudflare
record_id="YOUR-CF-RECORD-ID" 	# likewise, every subdomain has a zone record id (e.g. subdomain)
auth_key="YOUR-CF-TOKEN-KEY" 	# the cloudflare bearer token key, aka the API key

## FILE SETTINGS
DIR="/home/apps/cfdns" ## Location of main script file (cfdns.sh)

log_file="$DIR/cf_log"
ip_file="$DIR/cf_ip"
status_file="$DIR/cf_status"

## MISC SETTINGS
alias cls='printf "\033c"' ## an alias to the "clear" screen command, to use in bash scripts
wan_ip=$(curl -s http://ipv4.icanhazip.com) ## where we get our WAN ip from, which is your router's ip


##################################
## Edit Below At Your Own Peril ##
##################################

## Logs all updates to /home/apps/cfdns/cf_log
log() {
  [ ! -z "$1" ] && echo " [$(date)] - $1" >> $log_file;
  [ ! -z "$2" ] && echo " [$(date)] - $2" >> $log_file;
  echo " **********************************************************************************************" >> $log_file
  echo " " >> $log_file
}

## Check if file exists
checkFile () {
  if [ -e $1 ]; then
    return
  fi
  false
}

## Returns true only when status file exists and
## contains "true" within.
checkStatus () {
  if checkFile "$1"; then
    if grep -q "true" $1; then
      return
    fi
    false
  fi
  false
}

## STARTING THE UPDATE PROCESS 
cls
echo "            UPDATE STARTED !             "
echo "========================================="
echo " "

if checkFile "$ip_file"; then
  old_ip=$(cat $ip_file | awk '{print $1}')
else
  old_ip=""
fi

## DISPLAY ON CONSOLE AND LOG
if [ ! -z "$old_ip" ]; then
  if [ "$wan_ip" = "$old_ip" ]; then
    cls
    echo "           UPDATE CANCELLED !            "
    echo "========================================="
    echo " "
    message1="WAN IP has not yet changed."
    message2="Old IP: $old_ip | New IP: $wan_ip"
    log "UPDATE CANCELLED: $message1" "$message2"
    echo "$message1"
    echo "$message2"
    echo " "
    exit 0
  else if [ -z "$wan_ip" ]; then
    echo " "
    echo "              TIMEOUT ! ! !              "
    echo "========================================="
    echo " "
    message1="TIMEOUT: Could not proceed any further as"
    message2="communications with CF API has timed out."
    log "$message1" "$message2"
    echo "$message1"
    echo "$message2"
    echo " "
    exit 1
  fi
  fi
fi

## UPDATING DATA
response=$(curl -f -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$wan_ip\"}")

## RETRIEVING STATUS OF UPDATE
echo $response | grep -oP '(?<=\"success\":).{4}' > $status_file

## DISPLAY ON CONSOLE AND LOG
if checkStatus "$status_file"; then
    ## (success)
    cls
    echo "                SUCCESS !                "
    echo "========================================="
    echo " "
    message1="IP Updated To: $wan_ip"
    message2="$record_name"
    log "$message1" "$message2"
    echo "$message1"
    echo "$message2"
    echo " "
    echo "$wan_ip" > $ip_file
    exit 0
else
    ## (failure)
    cls
    echo "                FAILURE !                "
    echo "========================================="
    echo " "
    message="CF API UPDATE FAILED!"
    log "$message"
    echo "$message"
    echo " "
    exit 1
fi
