#!/bin/bash

cd $(dirname $0)

echo
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Test running..."
./test.sh > report.txt
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Finished."

readonly now=$(date '+%Y-%m-%d %H:%M:%S %z')

echo "" >> report.txt
echo "Reported at: ${now}" >> report.txt
echo "" >> report.txt

cat report.txt
