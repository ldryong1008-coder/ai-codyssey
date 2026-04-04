#!/bin/bash
LOG_FILE="/Users/ldryong10097422/dev-workstation/mission.log"

echo "=== System & Docker Log ===" > $LOG_FILE
echo "$ docker --version" >> $LOG_FILE
docker --version >> $LOG_FILE 2>&1
echo "" >> $LOG_FILE

echo "$ docker info | grep -E 'Server Version|Operating System|OSType|Architecture|Name'" >> $LOG_FILE
docker info | grep -E 'Server Version|Operating System|OSType|Architecture|Name' >> $LOG_FILE 2>&1
echo "" >> $LOG_FILE

echo "$ git --version" >> $LOG_FILE
git --version >> $LOG_FILE 2>&1
echo "" >> $LOG_FILE

echo "=== Terminal Basics Log ===" >> $LOG_FILE
mkdir -p ~/dev-workstation/practice
cd ~/dev-workstation/practice
echo "$ pwd" >> $LOG_FILE
pwd >> $LOG_FILE

echo "$ touch file1.txt" >> $LOG_FILE
touch file1.txt

echo "$ echo 'Hello' > file1.txt" >> $LOG_FILE
echo 'Hello' > file1.txt

echo "$ cp file1.txt file2.txt" >> $LOG_FILE
cp file1.txt file2.txt

echo "$ mkdir dir1" >> $LOG_FILE
mkdir dir1

echo "$ mv file2.txt dir1/renamed.txt" >> $LOG_FILE
mv file2.txt dir1/renamed.txt

echo "$ rm file1.txt" >> $LOG_FILE
rm file1.txt

echo "$ ls -la" >> $LOG_FILE
ls -la >> $LOG_FILE
echo "" >> $LOG_FILE

echo "=== Permission Log ===" >> $LOG_FILE
echo "$ ls -la dir1/renamed.txt" >> $LOG_FILE
ls -la dir1/renamed.txt >> $LOG_FILE

echo "$ chmod 777 dir1/renamed.txt" >> $LOG_FILE
chmod 777 dir1/renamed.txt

echo "$ ls -la dir1/renamed.txt" >> $LOG_FILE
ls -la dir1/renamed.txt >> $LOG_FILE

echo "$ ls -ld dir1" >> $LOG_FILE
ls -ld dir1 >> $LOG_FILE

echo "$ chmod 755 dir1" >> $LOG_FILE
chmod 755 dir1

echo "$ ls -ld dir1" >> $LOG_FILE
ls -ld dir1 >> $LOG_FILE
echo "" >> $LOG_FILE
