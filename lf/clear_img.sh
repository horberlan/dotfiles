#!/bin/sh
if [ -n "$LF_FIFO_UEBERZUG" ]; then
  printf '{"action": "remove", "identifier": "preview"}\n' >"$LF_FIFO_UEBERZUG"
fi