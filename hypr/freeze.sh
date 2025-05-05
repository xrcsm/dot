#!/bin/bash

grim /tmp/freeze.png

echo "ESC quit" > /tmp/mpv_input.conf

# Show screenshot in fullscreen and quit on ESC
mpv /tmp/freeze.png \
    --fullscreen \
    --no-border \
    --ontop \
    --no-osc \
    --image-display-duration=inf \
    --keep-open=yes \
    --idle=no \
    --input-conf=/tmp/mpv_input.conf \
    --really-quiet
