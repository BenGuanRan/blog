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

## 预渲染和数据获取
### 什么是预渲染
默认情况下，Next会对每个页面进行预渲染，也就是说Next为每个页面提前生成HTML，而不是像传统的框架那样，全部用js来实现，不利于SEO。
也就是说一个html页面对应最小化确保交互的js代码。

### 预渲染的两种形式

两种形式：静态生成（Static Generation）、服务端渲染（Sever-side Rendering）
SG是在打包时静态生成，然后预渲染的HTML在每个请求上重复使用。
SSR是在每次向服务端请求后，再生成代码。

![](https://secure2.wostatic.cn/static/pL5j3zq1UYkzn83rnEPZwz/1EFF175C-16DC-484B-8A05-720ADDE36F7C.png?auth_key=1679903860-rHggJm5Aj7eqiXJtkuKbhi-0-18a918fd04cfdc94244d6958da9d9d3a)

适合静态生成的页面：不经常更新改变的页面
适合服务端渲染的页面：每次请求，页面大概率改变
### 有数据和无数据的静态生成

**无数据的静态生成**
直接构建就好

**有数据的静态生成**
也就是说静态生成之前必须要异步获取数据。
其中有一个异步方法'getStaticProps'，将会在生产环境构建页面时运行。在这个方法中，可以去额外的数据，并通过props注入到组件中。
getStaticProps代码不会返回给客户，因此，可以直接在getStaticProps代码中填写一些私密性代码，例如sql语句，等等。

### 服务端渲染（SSR）
[![ppsq1ds.md.png](https://s1.ax1x.com/2023/03/27/ppsq1ds.md.png)](https://imgse.com/i/ppsq1ds)

关键函数`getServerSideProps`,区别于SG中的getStaticProps，前者是用于SSR，后者是用于SG，执行时间不一样。前者是每次请求执行，后者是构建时执行。
```jsx
export async function getServerSideProps(context) {
  return {
    props: {
      // props for your component
    }
  }
}
```
其中context包含特定的请求参数。getServerSideProps要比getStaticProps慢，因为服务器必须计算每个请求的结果，并且没有额外配置，CDN不会缓存。

## 动态路由
一个页面的路由取决于页面的内容（额外的数据）。↓
[![ppsLvjO.md.png](https://s1.ax1x.com/2023/03/27/ppsLvjO.md.png)](https://imgse.com/i/ppsLvjO)

**pages/posts/[id].js**这种形式的路径。
