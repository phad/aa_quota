#!/bin/bash
set -e

RUBY=/home/paul/.rvm/rubies/ruby-1.9.3-p448/bin/ruby
CONVERT=/usr/bin/convert
CURL=/usr/bin/curl
BLINK1=/usr/bin/blink1-tool
JQ=/usr/bin/jq
SED=/bin/sed

TMPDIR=`mktemp -d`
pushd $TMPDIR > /dev/null

$CURL -s "http://a.soulless.thn.aa.net.uk/info.cgi" > quota.png
$CONVERT quota.png quota.pgm
rm quota.png

popd > /dev/null

QUOTA_REMAIN=`$RUBY ./lib/ocr.rb $TMPDIR/quota.pgm`

QUOTA_JSON=`$RUBY ./lib/quota.rb $QUOTA_REMAIN`

BLINK1_COLOR=`echo $QUOTA_JSON | $JQ .blink1_rgb | $SED 's/\"//g'`

$BLINK1 --rgb=$BLINK1_COLOR

rm -rf $TMPDIR

echo $QUOTA_JSON

