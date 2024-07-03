# 获取所有 Markdown 文件
$postsPath = "C:\Users\mumu\Software\Hexo\Hexo\source\_posts"
$mdFiles = Get-ChildItem -Path $postsPath -Filter *.md -Recurse

# 处理每个 Markdown 文件
foreach ($file in $mdFiles) {
    # 提取日期
    if ($file.Name -match "^(\d{4})-(\d{2})-(\d{2})") {
        $year = $matches[1]
        $month = $matches[2]
        $day = $matches[3]

        # 获取当前文件夹路径
        $currentFolder = Split-Path -Parent $file.FullName
        $halfFolder = ($currentFolder -split '\\')[-1] # 获取半年的文件夹名称

        # 获取封面和缩略图路径
        $mdContent = Get-Content $file.FullName -Raw -Encoding utf8

        # 替换封面和缩略图路径
        $mdContent = $mdContent -replace "cover: /$year/$month/$day/", "cover: /$year/$month/$day/$halfFolder/"
        $mdContent = $mdContent -replace "thumbnail: /$year/$month/$day/", "thumbnail: /$year/$month/$day/$halfFolder/"
        
        # 将更新后的内容写回文件，指定编码方式
        Set-Content -Path $file.FullName -Value $mdContent -Encoding utf8
    }
}

Write-Output "Cover and thumbnail paths have been updated."
