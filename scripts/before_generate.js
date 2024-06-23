// const path = require('path');

// hexo.extend.filter.register('before_post_render', data => {
//   if (data.layout === 'post') {
//     const postName = path.basename(data.source, '.md');
//     const imgRegex = new RegExp(`!\\[.*?\\]\\(\\.\\/${postName}\\/([^\\)]+)\\)`, 'g');

//     data.content = data.content.replace(imgRegex, (match, p1) => {
//       return `{% asset_img ${p1} %}`;
//     });
//   }
//   return data;
// });

const path = require('path');

hexo.extend.filter.register('before_post_render', data => {
  if (data.layout === 'post') {
    const postName = path.basename(data.source, '.md');
    const imgRegex = new RegExp(`!\\[.*?\\]\\(\\.\\/${postName}\\/([^\\)]+)\\)`, 'g');

    // 原始内容
    const originalContent = data.content;

    // 转换内容
    let match;
    let modifiedContent = originalContent;
    while ((match = imgRegex.exec(originalContent)) !== null) {
      const originalLine = match[0];
      const newLine = `{% asset_img ${match[1]} %}`;
      
      // 打印转换前后的对比
      console.log(`Original line: ${originalLine}`);
      console.log(`Converted line: ${newLine}\n`);

      // 进行替换
      modifiedContent = modifiedContent.replace(originalLine, newLine);
    }

    // 更新数据内容
    data.content = modifiedContent;
  }
  return data;
});


