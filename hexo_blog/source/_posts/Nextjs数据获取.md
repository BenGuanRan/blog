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
- revalidate，决定x秒后重新生成还是使用缓存，若为true则每次请求都进行重新生成
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


## getStaticPaths（SG）
如果页面具有动态路由，getStaticsPaths则需要定义一个路径列表。
**如果从使用动态路由的页面导出名为getStaticPaths的异步函数，Next.js将静态预渲染getStaticPath指定的所有路径。**
```jsx
export async function getStaticPaths() {
  return {
    paths: [
      { params: { ... } } // See the "paths" section below
    ],
    fallback: true, false, or 'blocking' // See the "fallback" section below
  };
}
```
一个小栗子如下：
在一个名为[id].tsx文件夹下：
```tsx
export default function Page({ name }: { name: string }) {
    return <div>这是一篇有关{name}的文章</div>
}

export async function getStaticPaths() {
    const posts = ['html', 'css', 'js']
    const paths = posts.map((post) => ({
        params: { id: post },
    }))
    return { paths, fallback: true }
}

export async function getStaticProps({ params }: any) {
    return { props: { name: params.id } }
}
```
**注意：不能将getStaticPaths与getServerSideProps一起使用。**

## getSeverSideProps（SSR）
若页面导出了一个异步函数名为getSeverSideProps，则Next默认会开启SSR模式。
```jsx
export async function getServerSideProps(context) {
  return {
    props: {}, // will be passed to the page component as props
  }
}
```
其中context是一个对象，包含属性如下：
```js
context.req: 该属性是一个 Node.js 的 http.IncomingMessage 对象，它包含了来自客户端的请求信息，例如请求头、请求方法等等。
context.res: 该属性是一个 Node.js 的 http.ServerResponse 对象，它用于向客户端发送响应，例如设置响应头、响应状态码等等。
context.query: 该属性是一个对象，它包含了来自客户端的查询参数，例如 ?id=123 中的 id 参数可以通过 context.query.id 获取。
context.params: 该属性是一个对象，它包含了路由参数，例如路由为 /posts/[id]，则访问 /posts/123 时，context.params 中会包含 { id: '123' }。
context.preview: 该属性是一个布尔值，用于判断是否为预览模式，如果是预览模式，则可以显示未发布的内容。
context.resolvedUrl: 该属性是一个字符串，它表示在 Next.js 内部解析后的 URL，通常与 context.req.url 不同，因为 Next.js 可以通过路由配置将一个 URL 映射到另一个 URL。
```
其中返回对象包含属性如下：
```js
props: 表示页面渲染所需的数据，它是一个对象。
redirect: 表示将用户重定向到另一个页面，它是一个对象，包含以下属性：
  - destination: 表示重定向的目标页面的 URL。
  - permanent: 表示重定向的类型，如果为 true，则表示为永久重定向（301），如果为 false，则表示为临时重定向（302）。
notFound: 表示页面不存在，它是一个布尔值，默认为 false。如果设置为 true，则会显示 404 页面。
revalidate: 表示页面的重新验证时间（revalidation time），它是一个数字，表示在指定的秒数内不需要重新生成页面。如果不设置该属性，则页面将在每个请求时重新生成。设置为 false 则表示该页面不应该被缓存。
dehydratedState: 表示传递给客户端的静态页面数据。如果启用了 hybrid 模式，客户端将使用该数据进行初次渲染。
preview: 表示是否启用预览模式，它是一个对象，包含以下属性：
  - active: 表示是否启用预览模式，它是一个布尔值，默认为 false。
  - data: 表示预览模式所使用的数据，它是一个对象。
```