#!/usr/bin/env bash

# Name: Google Auth Config Prompter
# Description:
# Checks if the user has configured Google Authenticator MFA,
# and prompts it to do so if it is not.
# Type: profile.d script
# Version: 1.0.3
# Author: HON

FILE="$HOME/.google_authenticator"
# Arguments:
# t: Time-based tokens
# d: Don't allow token reuse
# u: Don't rate limit
# W: Allow one code before and one after current code
CONFIGURE_CMD="google-authenticator -tduW"
# Use "return" if profile.d script and "exit 0" otherwise.
EXIT_CMD="return"

# Don't run if sudo
[ -z "$SUDO_USER" ] || $EXIT_CMD

# Check dependencies
command -v "google-authenticator" >/dev/null 2>&1 || {
  echo >&2 "Google Authenticator not found."
  $EXIT_CMD
}

# Exit successfully if it exists
[ ! -f "$FILE" ] || $EXIT_CMD

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
[ $continue -eq 0 ] || $EXIT_CMD

# Configure
echo "Please add the account to your authenticator app and store the secret key and codes somewhere safe BEFORE saving here."
echo "Also, please widen your terminal window to make the QR code render properly."
read -p "Press enter to continue or CTRL+C to cancel."

$CONFIGURE_CMD
