# 定义半年
$halves = @{
    "H1" = @(1, 2, 3, 4, 5, 6)
    "H2" = @(7, 8, 9, 10, 11, 12)
}

# 获取所有 Markdown 文件
$postsPath = "C:\Users\mumu\Software\Hexo\Hexo\source\_posts"
$mdFiles = Get-ChildItem -Path $postsPath -Filter *.md

# 处理每个 Markdown 文件
foreach ($file in $mdFiles) {
    # 提取日期
    if ($file.Name -match "^(\d{4})-(\d{2})-(\d{2})") {
        $year = $matches[1]
        $month = [int]$matches[2]
        
        # 确定半年
        foreach ($half in $halves.Keys) {
            if ($halves[$half] -contains $month) {
                $halfFolder = "$postsPath\$year-$half"
                if (-not (Test-Path -Path $halfFolder)) {
                    New-Item -ItemType Directory -Path $halfFolder
                }
                
                # 移动 Markdown 文件和对应的资源文件夹
                $newFilePath = "$halfFolder\$($file.Name)"
                Move-Item -Path $file.FullName -Destination $newFilePath
                
                # 如果有对应的资源文件夹，移动资源文件夹
                $resourceFolderName = $file.BaseName
                $resourceFolderPath = "$postsPath\$resourceFolderName"
                if (Test-Path -Path $resourceFolderPath) {
                    Move-Item -Path $resourceFolderPath -Destination $halfFolder
                }
                
                break
            }
        }
    }
}

Write-Output "Markdown files have been organized by halves of the year."
