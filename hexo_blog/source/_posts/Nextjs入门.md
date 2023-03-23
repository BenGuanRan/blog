---
title: Nextjs入门（翻译自官网）
date: 2023-03-23
tags:
- React
- Nextjs
---

## 导航
### 基本原理
Nextjs的导航不同于React的配置式导航，是采用基于pages文件夹下页面路径与导航进行一个映射关系。
例如：
/ ----> /pages/index.js
/a/1 ----> /pages/a/[id].js
### 路由跳转
需要引入Next种的Link组件，来包裹a标签：
```jsx
import Link from 'next/link'

export default function FirstPost() {
  return (
    <>
      <h1>First Post</h1>
      <h2>
        <Link href="/">
          <a>Back to home</a>
        </Link>
      </h2>
    </>
  )
}
```
### 代码的分割与预取操作
Next.js会自动对代码进行拆分，因此每个页面只加载页面所需的js代码和资源。这意味着当主页被呈现时，其他页面的代码最初不会被提供。
这样可以确保即使添加了数百个页面，主页也能快速加载。
只加载您请求的页面的代码也意味着页面将被隔离。如果某个页面抛出错误，那么应用程序的其余部分仍然可以工作。
此外，在Next.js的生产版本中，每当链接组件出现在浏览器的视口中时，Next.js都会自动在后台预取链接页面的代码。当你点击链接时，目标页面的代码已经在后台加载，页面转换将接近即时！

### 总结
Next.js通过代码拆分、客户端导航和预取（在生产中）自动优化您的应用程序以获得最佳性能。    
您可以将路由创建为页面下的文件，并使用内置的“链接”组件。不需要路由库。

## 资源、元数据和CSS
### 简介
本章节将学会：
- 如何将静态文件（图像等）添加到Next.js。
- 如何为每个页面自定义＜head＞中的内容。
- 如何创建一个可重用的React组件，该组件使用CSS模块进行样式设计。
- 如何在pages/_app.js中添加全局CSS。
- 在Next.js中设置样式的一些有用提示。

### 如何修改head中的内容
可以引入Next中的Head组件，Next在页面生成时会自动帮助我们替换掉原head标签为Head组件。
```jsx
import Head from 'next/head'

export default function FirstPost() {
  return (
    <>
      <Head>
        <title>First Post</title>
      </Head>
      …
    </>
  )
}
```

### CSS样式引入
Nextjs内置styled-jsx库，使用如下：
```jsx
<style jsx>{`
  …
`}</style>
```
Nextjs也支持其他CSS-in-JS库，例如 styled-components 、 emotion.

### 创建可复用组件
1. 创建顶层文件夹components
2. 创建XXX.js文件（XXX组件名）
3. 其他文件导入组件

### 全局样式文件
1. 在pages页面下创建一个_app.js文件，并添加以下内容：
```js
export default function App({ Component, pageProps }) {
    return <Component {...pageProps} />
}
```
2. 创建全局样式css文件
3. 在_app.js文件中引入全局样式文件
```jsx
import '../styles/global.css'

export default function App({ Component, pageProps }) {
  return <Component {...pageProps} />
}
```
**注意：全局css样式文件只能在_app.js文件中引入！！！**
