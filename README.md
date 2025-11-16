# RouterOS Scripts

This repository contains RouterOS scripts for MikroTik devices.

## Overview

This collection includes scripts designed to automate tasks, monitor system events, and enhance the functionality of RouterOS devices.

## Scripts

### login-notify.rsc

**Purpose**: Login Monitor Script

This script monitors RouterOS system logs for login, logout, and login failure events and sends notifications to a webhook.

<details>
<summary>Click to expand details</summary>

#### Features

- **Event Monitoring**: Tracks login, logout, and login failure events from system logs
- **Webhook Integration**: Automatically sends log entries to a webhook
- **Timestamp Tracking**: Uses the script's comment field to store the last processed timestamp, preventing duplicate notifications
- **Automatic Initialization**: On first run, starts tracking from 00:00:00 of the current date

#### Configuration

Before using this script, you need to configure the following variables:

- `webhookURL`: Your webhook URL
- `scriptName`: The name of the script as it appears in RouterOS

#### How It Works

1. **Read Last Timestamp**: Retrieves the last processed timestamp from the script's comment field
2. **Find Logs**: Searches system logs for relevant events (system, info, account, error, critical topics)
3. **Process New Entries**: For each log entry newer than the last timestamp:
   - Creates a JSON payload with the log message
   - Sends it to the configured webhook
   - Updates the maximum timestamp processed
4. **Update Tracking**: Saves the latest processed timestamp to the script's comment field for the next run

#### Usage

1. Copy the script to your RouterOS device
2. Update the configuration variables (`webhookURL` and `scriptName`)
3. Schedule the script to run periodically (e.g., using RouterOS scheduler)

#### Log Topics Monitored

- `system,info,account` - Account-related information logs
- `system,error,critical` - Error and critical system logs

#### Notes

- The script uses timestamp comparison to avoid processing duplicate log entries
- On first execution, it will process all logs from 00:00:00 of the current day
- Future enhancements may include filtering for specific event types (login, logout, login failure)

</details>

