#!/bin/bash

# 只显示文件夹
tree -v -L 3 | awk 'BEGIN{print "```bash"} {print} END{print "```"}' > README.md
