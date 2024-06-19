# 获取当前时间戳
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# 创建带有时间戳的 Markdown 文件
hexo new post $timestamp

# 提示输入文章标题
$title = Read-Host "Enter the post title"

# 替换新创建文件中的标题
$file = "source/_posts/$timestamp.md"
(Get-Content $file) -replace 'title:.*', "title: $title" | Set-Content $file

Write-Output "Post created: $file"
