# aa_quota
Tool to scrape my remaining aaisp.net bandwidth quota from their homepage.

My kids are addicted to YouTube.  My better half is addicted to iPlayer.
I'm a bit partial to Netflix.

Between us our 100GB per month download quota from Andrews & Arnold is soon
consumed... and when it's gone, we either have to pay $$$ for more or live in the 80s
for a few days.

A&A helpfully place a remaining quota indicator on their webpage but annoyingly
it's a PNG.  So these scripts do some poor-man's OCR on the image to convert to text.

Provided A&A don't change the font they're using we're all good.

## Requirements
ImageMagick 'convert' tool (PNG to PGM conversion)

## Future work
 * use RMagick gem, then we can get it all in one .rb script and do away with the .sh script
 * wrap in a Sinatra server
 * do whatever is needed to get this running on a RaspPi
 * and have it talk to a ThingM blink(1) LED to show the status color.

