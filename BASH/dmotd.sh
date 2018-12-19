#!/usr/bin/env bash

# Name: MOTD
# Description:
# Generates a live/dynamic MOTD for users.
# Does not print if run directly or indirectly with sudo.
# Type: profile.d script
# Version: 1.0.1
# Author: HON

if [ -z "$SUDO_USER" ]; then
  echo
  neofetch --off
  echo "Users:"
  who
  echo
fi
