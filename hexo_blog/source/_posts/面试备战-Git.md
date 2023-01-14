---
title: 面试备战-Git
date: 2022-11-12 00:03:54
tags:
- Git
categories: 
- 面试备战
---

### git工作流程

四个工作区：

- 工作区
- 暂存区
- 本地仓库
- 远程仓库

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/460ac973-ab43-4181-a63c-0404d22bc5ff/Untitled.png)

### 常见指令

- git clone将存储库克隆到本地
- git init创建新的git仓库
- git remote管理远程仓库
    - git remote -v // 查看连接的远程仓库地址
    git remote add origin [gitUrl] // 为本地仓库添加远程仓库地址
    git push -u origin master // 将本地仓库的master和远程仓库的master进行关联
    git remote origin set-url [gitUrl] // 为本地仓库修改远程仓库地址
    git remote rm origin // 为本地仓库删除远程仓库连接
- git branch查看创建删除分支
- git tag创建查看删除标签
- git add 将本地文件添加到暂存区
- git commit将文件添加到本地仓库
- git push将本地分支推送到远程仓库
- git pull从远端拉取并合并本地分支
- git fetch获取远程代码库
- git merge将其他分支内容合并到当前分支
- git reset用于回退版本
- git revert回滚提交

### git reset --hard XXX 恢复被抹除的版本
思路是：可以使用git reflog命令查看想要恢复的分支版本号，然后在reset以下\

### 巧妙使用git reset -- soft
因为soft模式夏git保留当前工作区中的内容，因此当存在多次无意义的小commit时，可以soft reset到一个主要的commit，也就相当于合并commit

### 撤销修改
git checkout 文件名，可以将修改撤回到上一次add . 或commit的状态 