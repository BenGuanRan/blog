#!/usr/bin/env sh

set -x  # 这里是为了看错误日志

# 打包项目
cd hexo_blog

hexo g

# git checkout gh-pages
cd public

git init
git add -A

git commit -m 'auto deploy'

git push -f git@github.com:BenGuanRan/blog.git master:gh-pages


