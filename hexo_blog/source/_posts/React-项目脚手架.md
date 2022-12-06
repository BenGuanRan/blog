---
title: React-项目脚手架(7)
date: 2022-12-02
tags:
- React
---

## React脚手架

### 使用create-react-app创建react项目
全局安装
```
npm i -g create-react-app
```
构建项目脚手架
```
create-react-app hello-react
```
运行项目
```
npm start
```
react-cli默认隐藏webpack配置，可以通过以下不可逆指令显示webpack配置
```
yarn eject
```
### 目录介绍
**public ---- 静态资源文件夹**

favicon.icon ------ 网站页签图标

**index.html -------- 主页面（1）**

logo192.png ------- logo图

logo512.png ------- logo图

manifest.json ----- 应用加壳的配置文件

robots.txt -------- 爬虫协议文件

**src ---- 源码文件夹**

App.css -------- App组件的样式

**App.js --------- App组件**

App.test.js ---- 用于给App做测试

index.css ------ 全局样式

**index.js ------- 入口文件（1）**

logo.svg ------- logo图

reportWebVitals.js

--- 页面性能分析文件(需要web-vitals库的支持)

setupTests.js

---- 组件单元测试的文件(需要jest-dom库的支持)

### 注意事项
1. 组件名称必须要首字母大写
2. src 必须要有入口文件index.js
3. jsx中html里面的class变成className、for变成htmlFor、行内style使用{}传入一个对象并以前的"-"连字符使用驼峰命名法。