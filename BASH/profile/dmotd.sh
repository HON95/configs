#!/usr/bin/env bash

# Name: MOTD
# Description:
# Prints optional static MOTD, neofetch info and logged in users.
# Does not print if sudo environment is detected,
# or if the UID is less than or equal to SYS_UID_MAX.
# Type: profile.d script
# Dependencies: neofetch lolcat
# Version: 1.1.4
# Author: HON

# Changelog:
# 1.1.4: Add check for required shell features and list of excluded users
# 1.1.3: Add list of dependencies and change some variables
# 1.1.2: Add last login
# 1.1.1: Change users format (and remove tabs in src)
# 1.1.0: Add static MOTD and make more customizable
# 1.0.2: Don't run for system users
# 1.0.1: Avoid "exit", it breaks profile.d
# 1.0.0: Release

################################################################################

# For boolean options, "yes" (not "YES", 1, true) is the only recognized value for true

# Enable MOTD header
USE_MOTD_HEADER="yes"
# Path to logo
MOTD_HEADER_PATH="/etc/logo"
# Enable lolcat for MOTD header
USE_MOTD_HEADER_LOLCAT="yes"
# Enable MOTD footer
USE_MOTD_FOOTER="yes"
# Path to MOTD footer
MOTD_FOOTER_PATH="/etc/motd"
# Enable Neofetch
USE_NEOFETCH="yes"
# Enable Neofetch image
USE_NEOFETCH_IMAGE="no"
# Enable print last login
USE_LAST_LOGIN="yes"
# Enable print logged-in users
USE_USERS="yes"
# Max system UID, UIDs equal to or below this value don't run the script
SYS_UID_MAX=999
# Users that cannot run this (space separated list)
EXCLUDED_USERS="bot"

################################################################################

# Check some required shell feature is missing
! type "[[" >/dev/null && return

# Check if in sudo
[[ ! -z "$SUDO_USER" ]] && return

# Check if system user
[[ $(id -u) -le $SYS_UID_MAX ]] && return

# Check if excluded user
REGEX="(.* )?$(id -un)( .*)?"
[[ $EXCLUDED_USERS =~ $REGEX ]] && return
  
# Pre MOTD
if [[ $USE_MOTD_HEADER = "yes" ]] && [[ -f $MOTD_HEADER_PATH ]]; then
  if [[ $USE_MOTD_HEADER_LOLCAT = "yes" ]]; then
  cat "$MOTD_HEADER_PATH" | lolcat
else
  cat "$MOTD_HEADER_PATH"
fi
  echo
fi

# Neofetch
if [[ $USE_NEOFETCH = "yes" ]]; then
  if [[ $USE_NEOFETCH_IMAGE = "yes" ]]; then
    neofetch
  else
    neofetch --off
  fi
fi

# Last login
if [[ $USE_LAST_LOGIN = "yes" ]]; then
  echo -n "Last login: "
  last_out=$(last -n1 | head -n1)
  if [[ ! -z $last_out ]]; then
    echo "$last_out" | sed -E 's/^([^ ]+ +){2}//' | sed -E 's/^([^ ]+)[ ]+/\1,  /'
  else
    echo "(never)"
  fi
  echo
fi

# Users
if [[ $USE_USERS = "yes" ]]; then
  echo "Users"
  echo "-----"
  who
  echo
fi

# Post MOTD
if [[ $USE_MOTD_FOOTER = "yes" ]] && [[ -f $MOTD_FOOTER_PATH ]]; then
  cat "$MOTD_FOOTER_PATH"
echo
fi
