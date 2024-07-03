# 获取当前时间戳
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# 创建带有时间戳的 Markdown 文件
hexo new post $timestamp

# 定义半年
$halves = @{
    "H1" = @(1, 2, 3, 4, 5, 6)
    "H2" = @(7, 8, 9, 10, 11, 12)
}

# 确定当前年月
$currentYear = Get-Date -Format "yyyy"
$currentMonth = [int](Get-Date -Format "MM")

# 确定半年
$halfFolder = ""
foreach ($half in $halves.Keys) {
    if ($halves[$half] -contains $currentMonth) {
        $halfFolder = "source/_posts/$currentYear-$half"
        if (-not (Test-Path -Path $halfFolder)) {
            New-Item -ItemType Directory -Path $halfFolder
        }
        break
    }
}

# 构建文件路径
$mdFile = "source/_posts/$timestamp.md"
$newMdFile = "$halfFolder/$timestamp.md"

# 随机选择封面和缩略图
$randomIndex = Get-Random -Minimum 1 -Maximum 6
$cover = "/gallery/defaultCover$randomIndex.png"
$thumbnail = "/gallery/defaultThumbnail$randomIndex.png"

# 读取文件内容，指定编码方式
$mdContent = Get-Content $mdFile -Raw -Encoding utf8

# 替换标题和封面占位符
$mdContent = $mdContent -replace 'cover: COVER_PLACEHOLDER', "cover: $cover"
$mdContent = $mdContent -replace 'thumbnail: THUMBNAIL_PLACEHOLDER', "thumbnail: $thumbnail"

# 将更新后的内容写回文件，指定编码方式
Set-Content -Path $mdFile -Value $mdContent -Encoding utf8

# 移动 Markdown 文件到相应的文件夹
Move-Item -Path $mdFile -Destination $newMdFile

# 如果有对应的资源文件夹，移动资源文件夹
$resourceFolder = "source/_posts/$timestamp"
if (Test-Path -Path $resourceFolder) {
    Move-Item -Path $resourceFolder -Destination $halfFolder
}

Write-Output "Post created and organized: $newMdFile"
Write-Output "Cover image: $cover"
Write-Output "Thumbnail image: $thumbnail"
