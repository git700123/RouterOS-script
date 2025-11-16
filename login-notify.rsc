# ----------------------------------------------------------------------------------
# Script Name: discord-login-monitor
# Purpose: Find records of login, logout, and login failures
# State Tracking: Uses script's 'comment' field to store the latest full timestamp.
# ----------------------------------------------------------------------------------

# --- Configuration Variables ---
# Modify these values according to your setup
:local webhookURL "YOUR_DISCORD_WEBHOOK_URL"
:local scriptName "YOUR_SCRIPT_NAME"

# --- 1. Read the last processed full timestamp ---
# Format example: "Nov/15 08:30:00"
:local lastTimestamp [/system script get $scriptName comment]
:local newLogsFound false

:if ([:len $lastTimestamp] = 0) do={ 
    # First run: Use current date with 00:00:00 as baseline
    :set lastTimestamp ([:tostr [/system clock get date]] . " 00:00:00")
}

# --- 2. Find target logs ---
:local logEntries [/log find topics=system,info,account or topics=system,error,critical]

# Initialize the maximum timestamp for this tracking session
:local currentMaxTimestamp $lastTimestamp 

:foreach logEntry in $logEntries do={
    :local logTime [/log get $logEntry time]
    :local logMessage [/log get $logEntry message]
    :local fullMessage ($logTime . " " . $logMessage)

    :if ($logTime > $lastTimestamp) do={
        :set newLogsFound true

        # --- future use ---
        # :if ($logMessage ~ "logged in") do={
        #     :put $fullMessage
        # }

        # :if ($logMessage~"Logged out") do={

        # } 

        # :if ($logMessage~"Login failure") do={

        # }

        # --- 3. Create JSON payload ---
        :local jsonPayload ("{\"content\":\"" . $fullMessage . "\"}")
        
        # --- 4. Send Webhook ---
        /tool fetch url="$webhookURL" \
            http-method=post \
            http-header-field="Content-Type: application/json" \
            http-data=$jsonPayload \
            keep-result=no \
            as-value

        :set currentMaxTimestamp $logTime
    }
}

# --- 5. Save the maximum timestamp processed in this session ---
:if ($newLogsFound = true) do={
    /system script set $scriptName comment=[:tostr $currentMaxTimestamp]
    # :log info "Discord Login Monitor: Successfully processed new logs. Updated tracking timestamp to $currentMaxTimestamp."
}