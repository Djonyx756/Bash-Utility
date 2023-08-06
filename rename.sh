#!/bin/bash

counter=1
for file in *.webm; do
    mv "$file" "video$counter.webm"
    counter=$((counter+1))
done
