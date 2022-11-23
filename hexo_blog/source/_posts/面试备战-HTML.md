---
title: 面试备战-HTML
date: 2022-10-12 00:03:54
tags:
- HTML
categories: 
- 面试备战
---
## ****html标签的类型（head， body，！Doctype） 他们的作用是什么****

**!Doctype**

- 声明HTML版本

**Head**

- 文档的头部，一般不展示给用户看
- meta
- title

## src和href的区别

src表示对资源的引用，它指向的内容会嵌入到当前标签所在的位置。src会将其指向的资源下载到对应文档中，例如请求js脚本，img标签，frame等。

href表示对超文本的引入，用在link和a等元素上，将当前元素与引用资源建立联系。

src会等待该资源加载完毕之后再加载其他资源，这也是为什么会将js标签放到文档底部。

## HTML语义化

语义化是指根据标签中的内容的语义，选择合适的标签。例如：header头部、footer尾部、nav导航栏、section区块、main主要区域、article主要内容、aside侧边栏等

## DOCTYPE文档类型的作用

告诉浏览器应该以什么样的方式解析文档，不同的渲染模式会影响CSS甚至js的解析，它必须声明在文档的第一行。

例如：标准模式：浏览器按照W3C标准去解析CSS。怪异模式(混杂模式)：IE盒模型、溢出处理不同。

## 说一下webworker

一般浏览器执行js脚本为单线程， web worker是运行在浏览器后台的js，独立于其他脚本，不会影响页面性能，通过postMessage将结构传回主线程，通过onMessage进行消息监听。

## 常见meta标签的作用

- keywords
- charset
- authorization作者信息
- description
- robots告诉浏览器索引规则
- viewport
- refresh重定向刷新
- http-equiv="X-UA-Compatible"兼容给IE

## h5的更新

- 语义化
- 媒体标签
- 表单控件
- DOM查询
- web存储
- dragAPI
- canvas
- svg

## WebWorker

这是一个h5新增的非常好用的api，解决了浏览器js引擎由于单线程导致高计算量场景下的页面卡顿问题。

主线程

```tsx
// 主线程
const worker = new Worker('worker.js')
// 监听worker信息
worker.onmessage = function (messageEvent) {
    console.log(messageEvent);
    alert(11)
}
// 监听Worker错误信息
worker.onmessageerror = function (messageEvent) {
    console.log(messageEvent)
}
// 为worker传递信息
worker.postMessage({ type: 'start', count: 10000000000 }); // 发送信息给worker
// 终止worker
// worker.terminate();
```

worker线程

```tsx
// 监听事件，主线程可以通过 postMessage 发送信息过来
self.onmessage = (messageEvent) => {
    const { type, count } = messageEvent.data;
    switch (type) {
        case 'start':
            // 通过 type 去区分不同的业务逻辑，payload 是传过来的数据
            let  result = 0;
            for (let i = 0; i < count; i++) {
                result += i
            }
            // ....,通过一系列处理之后，把最终的结果发送给主线程
            this.postMessage(result);
            break;
    }
};
```

**shareWorker**， 普通worker升级版

是的跨tab页面通信成为可能

## dragAPI

[HTML 拖放 API - Web API 接口参考 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/API/HTML_Drag_and_Drop_API)

## Canvas和svg的区别

Canvas使用的是位图，利用像素进行渲染，放大会失真

SVG是采用矢量图，利用XML描述图形，放大不会失真

SVG

- 不依赖分辨率
- 支持事件处理器
- 最适合带有大型渲染区域的应用程序（比如谷歌地图）
- 复杂度高会减慢渲染速度（任何过度使用 DOM 的应用都不快）
- 不适合游戏应用

Canvas

- 依赖分辨率
- 不支持事件处理器
- 弱的文本渲染能力
- 能够以 .png 或 .jpg 格式保存结果图像
- 最适合图像密集型的游戏，其中的许多对象会被频繁重绘