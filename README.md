# What is this?

This program will track the items in the fridge by UPC (barcodes)

# But how?

`drinkdb.sh` searches the web for UPC codes and returns an item name, which it
then will add or subtract from a local sqlite3 database.

`server.sh` runs a small webserver so everyone in the office can see how much
we have in the fridge.

# What do I do?

1. Get a USB Barcode Scanner
2. Run `sudo ./install.sh`
3. Run `run.sh`
4. Open 'http://\<ip-of-this-computer\>:8080' to see the status

# How much is configurable?

Technically, all of it.  The easiest stuff to tweak would be:
  1. The port number, in `server.sh`
  2. The css, in `style.html`
  3. The refresh timer, in `meta.html` as `content`
  4. Formatting options, in `show.sql`

# Next Steps

If you had the time, you could configure this to email a group of people
(The Buyers) whenever an item go below a certain threshold

If you got reallllllly good, you could set up some webhooks and automatically
buy the items when you run low
