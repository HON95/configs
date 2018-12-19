#!/usr/bin/env bash

# Name: Google Auth Config Prompter
# Description:
# Checks if the user has configured Google Authenticator MFA,
# and prompts it to do so if it is not.
# Type: profile.d script
# Version: 1.0.0
# Author: HON

FILE="$HOME/.google_authenticator"
# Arguments:
# t: Time-based tokens
# d: Don't allow token reuse
# u: Don't rate limit
# W: Allow one code before and one after current code
CONFIGURE="google-authenticator -tduW"

# Check dependencies
command -v "google-authenticator" >/dev/null 2>&1 || { echo >&2 "Google Authenticator not found."; exit 1; }

# Exit successfully if it exists
[ ! -f "$FILE" ] || exit 0

# Ask to configure
echo "You have not yet configured Google Authenticator MFA."
while :; do
  read -p "Configure it now? [Y/n] " choice
  case "$choice" in
    "" ) continue=0 ; break ;;
    y|Y ) continue=0 ; break ;;
    n|N ) continue=1 ; break ;;
    * ) ;;
  esac
done

# Exit successfully if user said no
[ $continue ] || exit 1

# Configure
echo "Please add the account to your app and store the secret key and codes somewhere safe BEFORE continuing here."
$CONFIGURE
