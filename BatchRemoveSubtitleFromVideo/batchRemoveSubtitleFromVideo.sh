#!/usr/bash

videoList=("$1"/*)
targetDir=$2

# 檢查是否已安裝 ffmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo "尚未安裝 ffmpeg"
    exit
fi

# 檢查目標資料夾是否存在
if [ ! -d "$2" ]; then
    echo "輸出資料夾不存在"
    exit
fi

# 使用 ffmpeg 處理字幕
for ((i = 0; i <= ${#videoList[@]}; i++)); do

    if [ -z "${videoList[$i]}" ]; then
        continue
    fi

    echo "開始處理 '$(basename "${videoList[$i]}")'"

    if ! ffmpeg -i "${videoList[$i]}" -sn -c copy "$targetDir/$(basename "${videoList[$i]}")"; then
        echo "執行失敗"
        exit
    fi
done

echo "完成"
