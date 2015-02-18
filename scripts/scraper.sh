#!/bin/bash
set -e

TMPDIR=`mktemp -d`
pushd $TMPDIR > /dev/null

curl -s "http://a.soulless.thn.aa.net.uk/info.cgi" > quota.png
convert quota.png quota.pgm
rm quota.png

popd > /dev/null

QUOTA_REMAIN=`ruby ./lib/ocr.rb $TMPDIR/quota.pgm`

ruby ./lib/quota.rb $QUOTA_REMAIN

rm -rf $TMPDIR
