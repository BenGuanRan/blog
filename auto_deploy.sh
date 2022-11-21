#!/usr/bin/env sh

set -x  # 这里是为了看错误日志

# 打包项目
cd hexo_blog

hexo g

# git checkout gh-pages
cd public

git add -A

git commit -m 'auto deploy'

git push hexo_src:gh-pages