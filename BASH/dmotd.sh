#!/usr/bin/env bash

# Name: MOTD
# Description:
# Generates a live/dynamic MOTD for users.
# Does not print if run directly or indirectly with sudo.
# Type: profile.d script
# Version: 1.0.2
# Author: HON

# Changelog:
# 1.0.2: Don't run for system users
# 1.0.1: Avoid "exit", it breaks profile.d
# 1.0.0: Release

SYS_UID_MAX=999

if [ -z "$SUDO_USER" ] && [ $(id -u) -gt $SYS_UID_MAX ]; then
  echo
  neofetch --off
  echo "Users:"
  who
  echo
fi
