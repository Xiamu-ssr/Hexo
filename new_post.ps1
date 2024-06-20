# 获取当前时间戳
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# 创建带有时间戳的 Markdown 文件
hexo new post $timestamp

# 替换新创建文件中的标题
$file = "source/_posts/$timestamp.md"

# 随机选择封面和缩略图
$randomIndex = Get-Random -Minimum 1 -Maximum 6
$cover = "/gallery/defaultCover$randomIndex.png"
$thumbnail = "/gallery/defaultThumbnail$randomIndex.png"

# 读取文件内容，指定编码方式
$mdContent = Get-Content $file -Raw -Encoding utf8

# 替换标题和封面占位符
$mdContent = $mdContent -replace 'cover: COVER_PLACEHOLDER', "cover: $cover"
$mdContent = $mdContent -replace 'thumbnail: THUMBANAIL_PLACEHOLDER', "thumbnail: $thumbnail"

# 将更新后的内容写回文件，指定编码方式
Set-Content -Path $file -Value $mdContent -Encoding utf8

Write-Output "Post created: $file"
Write-Output "Cover image: $cover"
Write-Output "Thumbnail image: $thumbnail"
