#!/bin/bash

readonly __DIR__=$(cd $(dirname $0) && pwd)

readonly TEMP=$(mktemp)

echo
echo "Build start:"

# 编译 app-01
./build.sh app-01 >$TEMP 2>&1

if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to build app-01"
    cat $TEMP
    rm $TEMP
    echo
    exit 1
fi

echo "    app-01 done."

# 编译 app-02
./build.sh app-02 >$TEMP 2>&1

if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to build app-02"
    cat $TEMP
    rm $TEMP
    echo
    exit 1
fi

echo "    app-02 done."

# 编译 app-03
./build.sh app-03 >$TEMP 2>&1

if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to build app-03"
    cat $TEMP
    rm $TEMP
    echo
    exit 1
fi

echo "    app-03 done."

rm $TEMP

echo
echo "Test start:"
echo

cd "${__DIR__}/target"

echo "[COMMAND] java -cp app-01.jar org.example.app.App01:"
echo
java -cp app-01.jar org.example.app.App01
echo

echo "[COMMAND] java -cp app-02.jar org.example.app.App02:"
echo
java -cp app-02.jar org.example.app.App02
echo

echo "[COMMAND] java -cp app-03.jar org.example.app.App03:"
echo
java -cp app-03.jar org.example.app.App03
echo

echo "[COMMAND] java -cp app-03.jar:app-02.jar:app-01.jar org.example.app.App03:"
echo
java -cp app-03.jar:app-02.jar:app-01.jar org.example.app.App03
echo

echo "[COMMAND] java -cp app-03.jar:app-01.jar:app-02.jar org.example.app.App03:"
echo
java -cp app-03.jar:app-01.jar:app-02.jar org.example.app.App03
echo

echo "[COMMAND] java -cp app-01.jar:app-02.jar org.example.app.App01:"
echo
java -cp app-01.jar:app-02.jar org.example.app.App01
echo

echo "[COMMAND] java -cp app-02.jar:app-01.jar org.example.app.App01:"
echo
java -cp app-02.jar:app-01.jar org.example.app.App01
echo

