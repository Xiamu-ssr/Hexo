#!/bin/bash

# 获取当前时间戳
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

# 创建带有时间戳的 Markdown 文件
hexo new post "$timestamp"

# 定义半年
declare -A halves
halves=(
    ["H1"]="1 2 3 4 5 6"
    ["H2"]="7 8 9 10 11 12"
)

# 确定当前年月
currentYear=$(date +%Y)
currentMonth=$(date +%m)

# 确定半年
halfFolder=""
for half in "${!halves[@]}"; do
    if [[ "${halves[$half]}" =~ (^|[[:space:]])$((10#$currentMonth))($|[[:space:]]) ]]; then
        halfFolder="source/_posts/$currentYear-$half"
        if [ ! -d "$halfFolder" ]; then
            mkdir -p "$halfFolder"
        fi
        break
    fi
done

# 构建文件路径
file="source/_posts/$timestamp.md"
newFile="$halfFolder/$timestamp.md"

# 随机选择封面和缩略图
randomIndex=$(( (RANDOM % 5) + 1 ))
cover="/gallery/defaultCover${randomIndex}.png"
thumbnail="/gallery/defaultThumbnail${randomIndex}.png"

# 替换封面和缩略图占位符
sed -i "s|cover: COVER_PLACEHOLDER|cover: $cover|" "$file"
sed -i "s|thumbnail: THUMBNAIL_PLACEHOLDER|thumbnail: $thumbnail|" "$file"

# 移动 Markdown 文件到相应的文件夹
mv "$file" "$newFile"

# 如果有对应的资源文件夹，移动资源文件夹
resourceFolder="source/_posts/$timestamp"
if [ -d "$resourceFolder" ]; then
    mv "$resourceFolder" "$halfFolder"
fi

echo "Post created and organized: $newFile"
echo "Cover image: $cover"
echo "Thumbnail image: $thumbnail"
