#!/bin/bash
# 说明：
# 本脚本为项目构建脚本，用于编译和打包 code 目录下的 java 代码
# 使用示例：
#   ./build.sh app-01

# 进入脚本所在目录，并保存该路径
readonly __DIR__=$(cd $(dirname $0) && pwd)

# 定义相关根目录
readonly CODE_DIR="${__DIR__}/code"
readonly TARGET_DIR="${__DIR__}/target"

# 获取目标 App 名称
readonly APP_NAME=$1

# 检查是否指定 App 名称
if [ "$APP_NAME" == "" ]
then
    echo
    echo "ERROR: no app name specified."
    echo "Usage:"
    echo "    ./build.sh app-name"
    echo
    exit 1
fi

readonly APP_PATH="${CODE_DIR}/${APP_NAME}"

# 如果路径不存在则退出
if [ ! -d "$APP_PATH" ]
then
    echo
    echo "ERROR: ${APP_PATH} is not a directory."
    echo
    exit 1
fi

# 获取一个格式化后的路径
# 防止用户输入：./build.sh app-01/../app0-1
readonly APP_ABS_PATH=$(cd $APP_PATH && pwd)
readonly APP_ABS_NAME=$(basename $APP_ABS_PATH)
readonly APP_PARENT_DIR=$(dirname $APP_ABS_PATH)

# App 的父目录应该是 code 目录，如果不是，则说明用户错误用法可能如下：
# ./build.sh app-01/src
if [ "${APP_PARENT_DIR}" != "${CODE_DIR}" ]
then
    echo
    echo "ERROR: invalid app name: ${APP_NAME}"
    echo "ERROR: ${APP_ABS_PATH} is not an app directory."
    echo
    exit 1
fi

# 定义源码目录
readonly APP_SRC="${APP_ABS_PATH}/src"

# 检查源码目录是否存在
if [ ! -d "${APP_SRC}" ]
then
    echo
    echo "ERROR: ${APP_SRC} is not a directory"
    echo
    exit 1
fi

# 定义输出目录
readonly APP_TARGET_DIR="${TARGET_DIR}/${APP_ABS_NAME}"
readonly APP_TARGET_JAR="${TARGET_DIR}/${APP_ABS_NAME}.jar"

echo
echo "        App-Name: ${APP_ABS_NAME}"
echo "   App-Directory: ${APP_ABS_PATH}"
echo "Target-Directory: ${APP_TARGET_DIR}"
echo "   Jar-File-Name: ${APP_TARGET_JAR}"
echo

# 删除原有输出目录
if [ -d "${APP_TARGET_DIR}" ]
then
    rm -rf $APP_TARGET_DIR
fi

# 如果路径还存在，则说明原有输出路径不是一个目录，退出程序
if [ -e "${APP_TARGET_DIR}" ]
then
    echo
    echo "ERROR: ${APP_TARGET_DIR} is not an directory."
    echo
    exit 1
fi

# 删除原有 jar 包
if [ -f "${APP_TARGET_JAR}" ]
then
    rm $APP_TARGET_JAR
fi

# 如果路径依然存在，则说明不是一个文件，退出程序
if [ -e "${APP_TARGET_JAR}" ]
then
    echo
    echo "ERROR: ${APP_TARGET_JAR} is not a file."
    echo
    exit 1
fi

# 创建输出目录
mkdir -p $APP_TARGET_DIR

# 检查输出目录是否创建成功
if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to create directory ${APP_TARGET_DIR}"
    echo
    exit 1
fi

# 复制源代码
cp -r $APP_SRC/* $APP_TARGET_DIR

# 查找所有 .java 文件
cd $APP_TARGET_DIR

readonly TEMP_FILE=$(mktemp)

for filename in $(find . -name "*.java")
do
    if [ -f "${filename}" ]
    then
        echo $filename >> $TEMP_FILE
    fi
done

# 保存 .java 文件列表
readonly SROUCE_FILE_LIST=$(cat $TEMP_FILE)

# 删除临时文件
rm -rf $TEMP_FILE

# 如果没有找到 .java 文件则退出程序
if [ "${SROUCE_FILE_LIST}" == "" ]
then
    echo
    echo "ERROR: No java source file found in ${APP_SRC}"
    echo
    exit 1
fi

# 开始编译
javac $SROUCE_FILE_LIST

# 检查编译是否成功
if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to compile the source."
    echo
    exit 1
fi

# 删除输出目录中的源代码
for filename in $(find . -name "*.java")
do
    if [ -f "${filename}" ]
    then
        rm $filename
    fi
done

# 构建 jar 包
jar cvf $APP_TARGET_JAR *

# 检查构建 jar 包是否成功
if [ $? -ne 0 ]
then
    echo
    echo "ERROR: Failed to build the jar file."
    echo
    exit 1
fi

echo
echo "Build successfully!"
echo
exit
