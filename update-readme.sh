#!/bin/bash

tree | awk 'BEGIN{print "```bash"} {print} END{print "```"}' > README.md
