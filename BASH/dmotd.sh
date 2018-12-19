#!/usr/bin/env bash

# Name: MOTD
# Description:
# Generates a live/dynamic MOTD for users.
# Does not print if run directly or indirectly with sudo.
# Type: profile.d script
# Version: 1.0.0
# Author: HON

[ -z "$SUDO_USER" ] || exit 0

echo
neofetch --off
echo "Users:"
who
echo
