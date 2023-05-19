---
title: Nextjs基本特性
date: 2023-05-09
tags:
- React
- Nextjs
---

## Layouts布局

当页面有多个地方需要复用时，例如header、nav、footer等，这时，就可以写一个高阶组件，来对现有组件进行修饰，具体例子如下：
```jsx
export default function AddHeader(Component) {
    return () => (
        <div>
            <h1>Header</h1>
            <Component />
        </div>
    )
}
```
上述实例AddHeader，作为一个高阶组件，对传入的组件进行一个修饰，从而使得所有传入的组件上面都会添加一个header。
其他组件使用示例如下：
```jsx
import addHeader from '../utils/addHeader'

const Home = addHeader(({ value }: { value: string }) => {
  return (
    <>
      <div>index</div>
      <Link href='/posts/home'>{value}</Link>
      <Link href='/ssr'>进入SSR模式</Link>
      <Button value={'点击'}></Button>
    </>
  )
})

export default Home

export async function getStaticProps(context: any) {
  return {
    props: {
      value: '静态生成传值'
    }
  }
}
```

## Image组件与图片优化
Nextjs中Image组件是DOM中Img标签的一个扩展，其中提供一些性能优化，有利于三大核心指标（LCP最大内容元素可见时间、FID首次输入延迟、CLS视觉稳定性）优化。
其中内置优化包括：
- 提高性能：始终使用现代图像格式为每个设备提供正确大小的图像。
- 视觉稳定性：自动防止累积布局偏移。
- 更快的页面加载：图像只有在进入视口时才加载，带有可选的模糊占位符
- 资产灵活性：根据需要调整图像大小，即使是存储在远程服务器上的图像
其中一些属性值如下：
```
src：需要显示的图像的路径。这个属性是必需的。

alt：图像的描述文字。这个属性是必需的，因为它提高了可访问性，让屏幕阅读器用户能够理解图像的内容。

width 和 height：图像的显示宽度和高度。这些属性是必需的，因为它们提供了图像的尺寸信息，以便在图像加载之前为其分配空间。在使用自适应图像时，可以省略这些属性，因为 Image 组件会自动根据图像的原始大小计算宽度和高度。

layout：指定图像的布局方式。可选的值有fill，fixed，intrinsic和responsive。默认值为responsive，表示图像的宽度和高度会自动根据容器的大小进行调整。如果使用fill布局，则图像会自动缩放以填满其容器。如果使用fixed布局，则图像会以其原始大小显示。如果使用intrinsic布局，则图像会在保持其宽高比的同时，缩放以适应其容器。详细使用方法可参考官方文档

objectFit：指定如何缩放和裁剪图像以适应其容器。可选的值有fill、contain、cover、none、scale-down。默认为cover。详细使用方法可参考官方文档

priority：指定图像的优先级。可选的值为true或false。如果设置为true，则图像会在页面加载时尽可能快地加载。默认值为false。

loading：指定图像的加载方式。可选的值有eager、lazy和auto。默认为lazy，表示图像会在用户滚动到它们时加载。如果使用eager，则图像会在页面加载时立即加载。如果使用auto，则 Image 组件会根据用户的浏览器和设备自动选择最佳的加载方式。
```

## 内置Script组件
在Next中内置了script组件，我们可以这样引入
```jsx
import Script from 'next/script'
```
使用next/script，我们可以使用策略属性决定何时加载第三方脚本，相应策略如下：
- afterInteractive(default)：脚本将在页面交互后加载。这是默认的引入策略，适用于大多数情况。脚本将在页面内容加载完成后才开始加载，以确保不会阻塞页面的呈现和交互。
- beforeInteractive：脚本将在页面交互前尽早加载。使用这个策略，脚本会尽早加载，但可能会阻塞页面的呈现和交互。如果脚本很重要且需要尽早执行，可以选择这个策略。
- lazyOnload：脚本在获取所有资源后以及空闲时间加载。
**注意：该组件的src只能引入public文件夹下的静态js文件。**

Inline Script
```jsx
<Script>
  {`
    // 这是自定义的JavaScript代码
    alert('Hello, world!');
  `}
</Script>
```
必须要定义id属性，nextjs才能跟踪优化脚本

## 静态文件服务
public 目录下存放的静态文件的对外访问路径以 (/) 作为起始路径。
public 目录下存放的静态文件的对外访问路径以 (/) 作为起始路径。

## 环境变量
在 Next.js 中，可以使用环境变量来配置应用程序的行为。Next.js 提供了一种简便的方式来设置和使用环境变量。
在 Next.js 项目中，可以在根目录下创建一个名为 **.env.local** 的文件。这是一个本地环境变量文件，用于存储私密或特定于本地开发环境的变量。
在 .env.local 文件中，按照 **KEY=VALUE** 的格式定义环境变量。例如：
```
API_KEY=abc123
API_URL=https://api.example.com
```
这样就定义了两个环境变量：API_KEY 和 API_URL。

在 Next.js 的代码中，可以通过使用 process.env 对象来访问环境变量的值。例如：
```jsx
Copy code
const apiKey = process.env.API_KEY;
const apiUrl = process.env.API_URL;
```
这样就可以获取环境变量的值并在应用程序中使用。
需要注意的是，环境变量在 Next.js 中有一些特殊的命名规则：
- 环境变量以 NEXT_PUBLIC_ 前缀开头的变量，可以在客户端代码中直接访问。这些变量将被打包到客户端代码中。
- 不以 NEXT_PUBLIC_ 前缀开头的变量，只能在服务端代码中访问。这些变量不会暴露给客户端代码，因此适合存储敏感信息。

除了 .env.local 文件外，Next.js 还支持其他环境变量文件，如 .env.development、.env.production 等。这些文件可以根据不同的环境配置不同的变量。
在生产环境中，你需要在部署应用程序时设置实际的环境变量值。可以通过环境变量的管理工具、云服务平台或配置文件来实现。
总结一下，Next.js 支持使用环境变量来配置应用程序的行为。你可以在项目根目录下的 .env.local 文件中定义环境变量，并使用 process.env 对象在代码中访问这些变量。在 Next.js 中有一些特殊的命名规则和文件约定，可以根据不同的环境配置不同的变量。记得在部署应用程序时设置实际的环境变量值。




