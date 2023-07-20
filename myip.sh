#!/bin/bash

hostname --all-ip-addresses > output.txt
cat output.txt
rm output.txt
