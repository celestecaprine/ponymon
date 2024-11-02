#!/bin/bash

log="/tmp/output.mc"
match="RCON running on 0.0.0.0:25575"

while getopts 'abc:h' opt; do
  case "$opt" in
    c)
      arg="$OPTARG"
      command="$OPTARG"
      ;;

    ?|h)
      echo "Usage: $(basename $0) [-c arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

$command > "$log" 2>&1 &
pid=$!

while sleep 20
do
  if ps -p $pid >/dev/null
    then
      echo "process running, not erroring out"
    else
      echo "process dead, erroring out"
      cat /tmp/output.mc
      exit 1
  fi
  if fgrep -q "$match" "$log"
    then
	cat /tmp/output.mc
        kill $pid
        exit 0
  fi
done
