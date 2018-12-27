#!/bin/bash

cd $(dirname $0)

./test.sh > report.txt

readonly now=$(date '+%Y-%m-%d %H:%M:%S %z')

echo "" >> report.txt
echo "Reported at: ${now}" >> report.txt
echo "" >> report.txt

cat report.txt
