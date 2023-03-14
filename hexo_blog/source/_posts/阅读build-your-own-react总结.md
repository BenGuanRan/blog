---
title: 阅读build-your-own-react总结
date: 2023-03-11
tags:
- React
---

## 概要
原文出处：[build-your-own-react](https://pomb.us/build-your-own-react/)
该文章旨在通过以下几步引导读者创建自己的React：
- Step I: The createElement Function
- Step II: The render Function
- Step III: Concurrent Mode
- Step IV: Fibers
- Step V: Render and Commit Phases
- Step VI: Reconciliation
- Step VII: Function Components
- Step VIII: Hooks

## Step I: The createElement Function
**createElement 函数的作用是根据指定的第一个参数创建一个React元素，可以用JSX来替代**
```jsx
//JSX写法：

class Hello extends React.Component {
    render() {
        return <div>Hello, { this.props.toWhat }</div>
    }
}

ReactDOM.render(
    <Hello toWhat=‘world’>,
    document.getElementById(‘root’)
)
```

```js
// 转化为原生JS后的写法

class Hello extends React.Component {
    render(){
        return React.createElement(‘div’,null, `Hello,${this.props.toWhat}`)
    }
}

ReactDOM.render(
    React.createElement(‘Hello’, { toWhat: ‘world’ }, null),
    document.getElementById(‘root’)
)
```