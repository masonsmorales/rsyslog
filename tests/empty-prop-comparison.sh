#!/bin/bash
# addd 2016-07-08 by RGerhards, released under ASL 2.0

. $srcdir/diag.sh init
. $srcdir/diag.sh generate-conf
. $srcdir/diag.sh add-conf '
module(load="../plugins/imtcp/.libs/imtcp")
input(type="imtcp" port="13514")
template(name="outfmt" type="string" string="%msg:F,58:2%\n")

set $!doOutput = "";
if $msg contains "msgnum:0" then
	set $!doOutput = "1";

if $!doOutput == "" then stop
action(type="omfile" template="outfmt" file="rsyslog.out.log")
'
. $srcdir/diag.sh startup
echo '<167>Mar  6 16:57:54 172.20.245.8 test: msgnum:0
<167>Mar  6 16:57:54 172.20.245.8 test: msgnum:' > rsyslog.input
. $srcdir/diag.sh tcpflood -B -I rsyslog.input
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
. $srcdir/diag.sh seq-check 0 0
. $srcdir/diag.sh exit
