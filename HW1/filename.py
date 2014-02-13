#!/bin/sh

folder = 'ls'
output_file = filename.txt
: > $output_file

for file in ${folder}/*.csv; do
    temp = '$file'
    echo $temp >> output_file
done
