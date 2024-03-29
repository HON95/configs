#!/bin/bash

# Set display backlight brightness.

# Usage:
# - Without an argument: Get the current brightness.
# - With an integer: Set to the provided value (limited by min/max).
# - With a relative integer (+-n): Increment/decrement the value (limited by min/max).

# Make sure the current user has write access to the backlight (e.g. using the video group and udev rules).

set -u -o pipefail

VALUE_MIN=0
VALUE_MAX=5
BACKLIGHT_DIR="/sys/class/backlight/$(ls -1 /sys/class/backlight)"

if [[ ! -d $BACKLIGHT_DIR ]]; then
    echo "Backlight device does not exist: $BACKLIGHT_DIR" >&2
    exit 1
fi

bright_min=1
bright_max=$(cat "$BACKLIGHT_DIR/max_brightness")
bright_current=$(cat "$BACKLIGHT_DIR/brightness")

function clamp {
    if (( $1 < $2 )); then
        echo $2
        return
    elif (( $1 > $3 )); then
        echo $3
        return
    fi
    echo $1
}

# Map an integer in [0, $VALUE_MAX] to [0, $bright_max]
function value_to_bright {
    a=$(($bright_max / $VALUE_MAX ** 2))
    value=$(clamp $1 $VALUE_MIN $VALUE_MAX)
    bright=$(bc <<<"$value^2 * $a")
    echo $bright
}

# Map an integer in [0, $bright_max] to [0, 10]
function bright_to_value {
    a=$(($bright_max / $VALUE_MAX ** 2))
    bright=$(clamp $1 $bright_min $bright_max)
    value=$(bc <<<"scale=0; sqrt($bright / $a)")
    echo $value
}

value_current=$(bright_to_value $bright_current)

if [[ $# == 0 ]]; then
    echo "$((100 * $bright_current / $bright_max))%"
elif [[ $1 =~ ^[\+\-]?[0-9]+$ ]]; then
    oper=$(grep -Eo '[+-]' <<<$1)
    in_value=$(grep -Eo '[0-9]+' <<<$1)

    # If relative, get abs value first
    value_new=$in_value
    if [[ $oper != "" ]]; then
        value_new=$(($value_current $oper $in_value))
    fi
    value_new=$(clamp $value_new $VALUE_MIN $VALUE_MAX)

    # Calculate new brightness
    bright_new=$(value_to_bright $value_new)

    # Limit
    bright_new=$(clamp $bright_new $bright_min $bright_max)

    # Update
    echo $bright_new > $BACKLIGHT_DIR/brightness
else
    echo "Unknown argument." >&2
    exit 1
fi
