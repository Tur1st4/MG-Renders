#!/bin/sed -n

s/^.*href='//
s/'.*//
s/    var downPage.*;//
/^$/d
s/'.*//
