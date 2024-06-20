#!/bin/bash

# 获取当前时间戳
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

# 创建带有时间戳的 Markdown 文件
hexo new post "$timestamp"

# 替换新创建文件中的标题
file="source/_posts/$timestamp.md"

# 随机选择封面和缩略图
randomIndex=$(( (RANDOM % 5) + 1 ))
cover="/gallery/defaultCover${randomIndex}.png"
thumbnail="/gallery/defaultThumbnail${randomIndex}.png"

# 替换封面和缩略图占位符
sed -i "s|cover: COVER_PLACEHOLDER|cover: $cover|" "$file"
sed -i "s|thumbnail: THUMBANAIL_PLACEHOLDER|thumbnail: $thumbnail|" "$file"

echo "Post created: $file"
echo "Cover image: $cover"
echo "Thumbnail image: $thumbnail"
