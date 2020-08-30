#!/usr/bash

videoList=("$1"/*)
subtitleList=("$2"/*)
targetDir=$3

# 檢查是否已安裝 ffmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo "尚未安裝 ffmpeg"
    exit
fi

# 檢查影片及字幕數量是否相同
if [ ${#videoList[@]} != ${#subtitleList[@]} ]; then
    echo "影片數量與字幕數量不同"
    exit
fi

# 給使用者檢查影片對應是否正確
echo "影片及字幕對應清單:"
for ((i = 0; i <= ${#videoList[@]}; i++)); do

    if [ -z "${videoList[$i]}" ]; then
        continue
    fi

    echo "影片: '$(basename "${videoList[$i]}")'"
    echo "字幕: '$(basename "${subtitleList[$i]}")'"
    echo
done
echo "請確認影片對應是否正確？ [y|N]"
read -r reply
if [ "$reply" != "y" ]; then
    exit
fi

# 檢查目標資料夾是否存在
if [ ! -d "$3/output" ]; then
    mkdir "$3/output"
fi

# 使用 ffmpeg 結合影片及字幕
for ((i = 0; i <= ${#videoList[@]}; i++)); do

    if [ -z "${videoList[$i]}" ]; then
        continue
    fi

    echo "開始合併 '$(basename "${videoList[$i]}")' 與 '$(basename "${subtitleList[$i]}")'"
    extension="${videoList[$i]##*.}"

    if [[ "$extension" == "mp4" ]] || [[ "$extension" == "m4v" ]]; then
        if ! ffmpeg -i "${videoList[$i]}" -i "${subtitleList[$i]}" \
            -metadata:s:s:0 language=chi -disposition:s:0 default \
            -c:s mov_text -c:v copy -c:a copy \
            "${targetDir}/output/$(basename "${videoList[$i]}")"; then
            echo "執行失敗"
            exit
        fi
    else
        if ! ffmpeg -i "${videoList[$i]}" -i "${subtitleList[$i]}" \
            -metadata:s:s:0 language=chi -disposition:s:0 default \
            -c:s mov_text -c:v copy -c:a copy -scodec copy \
            "${targetDir}/output/$(basename "${videoList[$i]}")"; then
            echo "執行失敗"
            exit
        fi
    fi
done

echo "完成"
