#!/bin/bash

tree -v -L 3 -H 'https://github.com/opsxin/linux/blob/master' \
    | awk 'BEGIN{print "Linux<br/>"} /─/{print} /directories/{print "<br/>" $0}' \
    > README.md
