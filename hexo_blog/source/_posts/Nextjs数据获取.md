---
title: Nextjs数据获取（Data Fetching）
date: 2023-04-13
tags:
- React
- Nextjs
---

## 前言

在Nextjs入门中我们说过，Next分为两种渲染模式，SSR/SG。针对这两种不同的渲染模式，Nextjs提供给了不同的API进行服务端的数据获取操作。
- `getStaticProps`：（SG）build时获取数据
- `getStaticPaths`：（SG）获取动态路由数据
- `getServerSideProps`：（SSR）获取每次请求的数据

## getStaticProps（SG）
Next会在build时自动调用此函数，并且将返回值注入到组件的props参数中。
```jsx
export async function getStaticProps(context) {
  return {
    props: {}, // will be passed to the page component as props
  }
}
```
返回值是一个对象，允许有以下属性：
- props，向组件props属性中注入
- revalidate，决定x秒后重新生成还是使用缓存
- notFound，允许返回一个404页面
```js
export async function getStaticProps() {
    try {
        const data = await requestData(500)
        return {
            props: {
                data
            }
        }
    } catch (error) {
        return { notFound: true }
    }
}
```

**Incremental Static Regeneration（ISG）**
允许在静态页面生成之后进行创建或更新静态页面，这就要利用getStaticProps返回值中的**revalidate**属性。


## getStaticProps（SG）
如果页面具有动态路由，getStaticsProps则需要定义一个路径列表。
**如果从使用动态路由的页面导出名为getStaticPaths的异步函数，Next.js将静态预渲染getStaticPath指定的所有路径。**
