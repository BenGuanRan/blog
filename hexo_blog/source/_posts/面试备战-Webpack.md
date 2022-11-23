---
title: 面试备战-Webpack
date: 2022-11-12 00:03:54
tags:
- Webpack
- 构建工具
categories: 
- 面试备战
---

[webpack 中文文档 | webpack 中文网 (webpackjs.com)](https://www.webpackjs.com/)

## 五大核心概念

- entry入口
    
    来指示webpack从哪个文件开始打包
    
- output输出
    
    指定打包后的资源位置
    
- modules模块
    
    默认wb只能打包js、json等资源，有了加载器就能识别并打包不同模块
    
- plugins插件
    
    扩展webpack的功能
    
- mode模式
    - 开发模式development
    - 生产模式production

## 基本使用

webpack.config.js

```jsx
const path = require('path')
module.exports = {
    // 入口文件
    entry: './src/main.js',
    // 出口
    output: {
        path: path.resolve(__dirname, "dist"), // 绝对路径
        filename: 'main.js' // 文件名
    },
    // 加载器
    module: {
        rules: [
            // loader的配置
        ]
    },
    plugins: [
        // 插件的配置
    ],
    mode: 'development'
}
```

npx webpack指令进行打包

## 开发模式介绍

- 处理代码让浏览器能够识别并运行
- 代码质量检查，树立代码规范
    
    eslint等代码运行是更加健壮
    

## 处理css资源

```jsx
module: {
        rules: [
            // loader的配置
            {
                test: /\.css$/, // 正则，检测所有以css结尾的文件
                use: [
                    'style-loader', // 将commonjs引入的css文件以创建script标签的方式添加到HTML页面中
                    'css-loader' // 将css资源编译成commonjs资源
                ] // 从右往左（下-上）一次使用css-loader style-loader
            }
        ]
    },
```

less\scss等同理

## 处理图片资源

- wp5与wp4有所不用，处理图片资源时，wp5已经内置了图片处理，不像wb4还得加载file-loader和url-loader

## 插件

### html-webpack-plugin

可以自动生成html文件，并自动修改资源引用路径

### clean-webpack-plugin

自动清理dist文件

## 开发工具devtools（无法用于生产环境）

### source map功能

可以对打包后的代码映回原始代码

### inline-source-map

用于追踪打包前错误出现的原始位置

### 自动编译代码

1. webpack's Watch Mode
    
    开启watch模式，自动编译，但需要手动刷新浏览器
    
2. webpack-dev-server
    
    提供一个简单的web服务器
    
    ```jsx
    devServer: {
        contentBase: './dist'
    },
    // 以上配置告知 webpack-dev-server，在 localhost:8080 下建立服务，将 dist 目录下的文件，作为可访问文件。
    ```
    
3. webpack-dev-middleware

## 总结开发模式的配置

1. entry指定入口文件
2. output指定输出文件
3. module帮助webpack识别其不能识别的东西
4. plugins插件，比如自动填写打包后js文件的引用路径
5. devServer，搭建开发服务器，自动编译打包
6. mode设置开发模式

## 提取CSS形成单独文件

由于webpack打包之后默认将css打包到js中，再通过引入js再引入css，因此需要提取css成单独文件。

MiniCssExtractPlugin 

在使用之前需要修改原来的style-loader

### CSS压缩

css-minimizer-webpack-plugin