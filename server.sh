#!/bin/bash
if [[ -f drinks.db ]]
then
  STUFF="$(sqlite3 drinks.db "select * from Drinks;" \
    | pandoc -s - -H meta.html -H style.html -t html)"
  RESPONSE="HTTP/1.1 200 OK\r\nConnection: keep-alive\r\n\r\n$STUFF\r\n"
fi
while { echo -en "$RESPONSE"; } | nc -l "${1:-8080}"; do
  if [[ -f drinks.db ]]
  then
    STUFF="$(sqlite3 drinks.db "select * from Drinks;" \
      | pandoc -s - -H meta.html -H style.html -t html)"
    RESPONSE="HTTP/1.1 200 OK\r\nConnection: keep-alive\r\n\r\n$STUFF\r\n"
  fi
done
