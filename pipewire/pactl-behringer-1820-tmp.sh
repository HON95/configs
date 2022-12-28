#!/bin/bash

# Setup Behringer UMC1820 (4 stereo in, 5 stereo out).
# Temporary solution, create a Pipewire config instead.

# Names are broken.

set -eu -o pipefail

CARD="alsa_card.usb-BEHRINGER_UMC1820_B572BD9B-00"

pactl load-module module-remap-source master="$CARD" master_channel_map=aux0,aux1 channels=2 remix=no source_name="UMC1820 1/2"
pactl load-module module-remap-source master="$CARD" master_channel_map=aux2,aux3 channels=2 remix=no source_name="UMC1820 3/4"
pactl load-module module-remap-source master="$CARD" master_channel_map=aux4,aux5 channels=2 remix=no source_name="UMC1820 5/6"
pactl load-module module-remap-source master="$CARD" master_channel_map=aux6,aux7 channels=2 remix=no source_name="UMC1820 7/8"

pactl load-module module-remap-sink master="$CARD" master_channel_map=aux0,aux1 channels=2 remix=no sink_name="UMC1820 1/2"
pactl load-module module-remap-sink master="$CARD" master_channel_map=aux2,aux3 channels=2 remix=no sink_name="UMC1820 3/4"
pactl load-module module-remap-sink master="$CARD" master_channel_map=aux4,aux5 channels=2 remix=no sink_name="UMC1820 5/6"
pactl load-module module-remap-sink master="$CARD" master_channel_map=aux6,aux7 channels=2 remix=no sink_name="UMC1820 7/8"
pactl load-module module-remap-sink master="$CARD" master_channel_map=aux8,aux9 channels=2 remix=no sink_name="UMC1820 9/10"
