#!/usr/bin/env bash

# Name: MOTD
# Description:
# Prints optional static MOTD, neofetch info and logged in users.
# Does not print if sudo environment is detected,
# or if the UID is less than or equal to SYS_UID_MAX.
# Type: profile.d script
# Version: 1.1.0
# Author: HON

# Changelog:
# 1.1.1: Change users format (and remove tabs in src)
# 1.1.0: Add static MOTD and make more customizable
# 1.0.2: Don't run for system users
# 1.0.1: Avoid "exit", it breaks profile.d
# 1.0.0: Release

# For boolean options, "yes" is the only recognized value for true

# Max system UID, UIDs equal to or below this value don't run the script
SYS_UID_MAX=999
# Path to static MOTD to show first
PRE_MOTD_PATH="/etc/pre-motd"
# Path to static MOTD to show last
POST_MOTD_PATH="/etc/post-motd"
# Enable static MOTD to show first
USE_PRE_MOTD="no"
# Enable static MOTD to show last
USE_POST_MOTD="no"
# Enable lolcat for MOTD to show first (requires lolcat)
USE_LOLCAT_PRE_MOTD="yes"
# Enable Neofetch
USE_NEOFETCH="yes"
# Enable Neofetch image
USE_NEOFETCH_IMAGE="no"
# Enable print logged-in users
USE_USERS="yes"

if [ -z "$SUDO_USER" ] && [ $(id -u) -gt $SYS_UID_MAX ]; then
  # Pre MOTD
  if [ "$USE_PRE_MOTD" = "yes" ] && [ -f "$PRE_MOTD_PATH" ]; then
    if [ "$USE_LOLCAT_PRE_MOTD" = "yes" ]; then
    cat "$PRE_MOTD_PATH" | lolcat
  else
    cat "$PRE_MOTD_PATH"
  fi
    echo
  fi

  # Neofetch
  if [ "$USE_NEOFETCH" = "yes" ]; then
    if [ "$USE_NEOFETCH_IMAGE" = "yes" ]; then
    neofetch
    else
      neofetch --off
    fi
    echo
  fi

  # Users
  if [ "$USE_USERS" = "yes" ]; then
    echo "Users"
  echo "-----"
    who
  echo
  fi

  # Post MOTD
  if [ "$USE_POST_MOTD" = "yes" ] && [ -f "$POST_MOTD_PATH" ]; then
    cat "$POST_MOTD_PATH"
  echo
  fi
fi
