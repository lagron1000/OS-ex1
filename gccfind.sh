#!/bin/bash
#Lior Agron 208250225
cd "$1" || exit

for i in *.out
do
  if [ -f "$i" ]; then
      rm "$i"
  fi
done

if [ "$3" = "-r" ]; then
    for i in *
    do
        if [[ -d "$i" ]]; then
        ../"$0" "$i" "$2" "$3" || "$0" "$i" "$2" "$3"  #1st one worked in wsl and the second in the VSC debugger.
        fi
    done
fi

for i in *.c
do
if grep -q -i "$2" "$i"; then
    gcc "$i" -c -o "${i%.c}".out
fi
done