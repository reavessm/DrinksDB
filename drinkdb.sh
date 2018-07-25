#!/bin/bash

db=drinks.db

noDrinkFound () {
  clear
  echo -n "Please enter a valid UPC code"
  sleep 0.5
  echo -n .
  sleep 0.5
  echo -n .
  sleep 0.5
  echo -n .
  sleep 0.5
  clear
}

idiot () {
  clear
  echo -n "Don't be an idiot"
  sleep 0.5
  echo -n .
  sleep 0.5
  echo -n .
  sleep 0.5
  echo -n .
  sleep 0.5
  clear
}

checkDeps() {
  if [[ -z "$(which bash)" || -z "$(which sqlite3)" ]]
  then
    echo Please run the install script
    exit 1
  fi
}

showTable () {
  clear
  echo -e "\e[92m\e[7m"
#  sqlite3 -column -header $db <<EOF
#.width 20 4
#SELECT * FROM Drinks;
#EOF
  sqlite3 -column $db < show.sql
 echo -e "\e[0m\e[39m"
}

search () {
  read -p "Please enter 8 or 12 digit UPC code:
-> " upc
  #upc=01208500
  
  curl --silent https://www.upcdatabase.com/item/$upc 2>&1 | grep Description \
    | awk '{gsub("<[/a-zA-Z]*>", "");print}' \
    | awk '{gsub("Description", "");print}' 
}

massInsert () {
  drink=$(search)
  if [[ -z "$drink" ]]
  then
    noDrinkFound
    return
  fi
  
  if [[ "$#" < 1 ]]
  then
    read -p "Please Enter how many you want to insert: 
-> " num
  else
    num=$1
  fi

  sqlite3 $db <<EOF
  CREATE TABLE IF NOT EXISTS Drinks (drink VARCHAR(20) PRIMARY KEY, amt 
  INTEGER);
  INSERT INTO Drinks(drink,amt) 
    SELECT '$drink', 0
    WHERE NOT EXISTS(SELECT 1 FROM Drinks 
                      WHERE drink = '$drink');
  UPDATE Drinks
    SET amt = amt + $num
    WHERE drink = '$drink';
EOF

showTable
}

massDelete () {
  drink=$(search)
  if [[ -z "$drink" ]]
  then
    noDrinkFound
    return
  fi
  
  if [[ "$#" < 1 ]]
  then
    read -p "Please enter how many you want to delete:
-> " num
  else
    num=$1
  fi

  sqlite3 $db <<EOF
  CREATE TABLE IF NOT EXISTS Drinks (drink VARCHAR(20) PRIMARY KEY, amt
  INTEGER);
  UPDATE Drinks
    SET amt = amt - $num
    WHERE drink = '$drink';
  DELETE
    from drinks
    where amt < 0;
EOF

showTable
}


insert () {
  massInsert 1
}

delete () {
  massDelete 1
}

clear

checkDeps

while [[ -z "$opt" ]]
do

showTable

  read -p "Please select an option: 
  1: Insert
  2: Mass Insert
  3: Remove
  4: Mass Remove
  5: Quit

-> " opt

  case "$opt" in
      1) insert;
        opt="" ;;
      2) massInsert;
        opt="" ;;
      3) delete;
        opt="" ;;
      4) massDelete;
        opt="" ;;
      5) echo Bye.;
        exit 0;
        opt="" ;;
      *) idiot;
        opt="" ;;
  esac

done

