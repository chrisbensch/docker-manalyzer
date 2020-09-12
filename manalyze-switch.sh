#!/bin/bash

case "$1" in
  manalyze)
    /usr/local/bin/manalyze "${@:2}" ;;
  shell)
    /bin/sh;;
  "")
    /usr/local/bin/manalyze "${@:2}" ;;
  *)
    echo "Unsupported command: $1"
esac
