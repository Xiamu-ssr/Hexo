#!/bin/bash

# 获取当前时间戳
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

# 创建带有时间戳的 Markdown 文件
hexo new post "$timestamp"

# 提示输入文章标题
read -p "Enter the post title: " title

# 替换新创建文件中的标题
file="source/_posts/$timestamp.md"
sed -i "s/title:.*/title: $title/" "$file"

echo "Post created: $file"
