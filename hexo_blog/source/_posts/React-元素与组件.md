---
title: React-元素与组件(3)
date: 2022-11-26
tags:
- React
---
## 元素
**元素是构成React应用的最小砖块，元素可以是HTML标签，也可以是React组件**
与浏览器DOM不同，React元素是创建开销极小的普通对象。ReactDOM只负责更新DOM来与React元素保持一致。

**ReactDOM.render()**函数用来将React元素**渲染**到根DOM中，也负责**更新**已渲染的元素。

**React只会更新它需要更新的部分**
React DOM 会将元素和它的子元素与它们之前的状态进行比较，并只会进行必要的更新来使 DOM 达到预期的状态。

## 组件
### 函数组件
```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```
该函数是一个有效的 React 组件，因为它接收唯一带有数据的 “props”（代表属性）对象与并返回一个 React 元素。这类组件被称为“函数组件”，因为它本质上就是 JavaScript 函数。

### 类式组件
```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

### 组件传参
```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

const root = ReactDOM.createRoot(document.getElementById('root'));
const element = <Welcome name="Sara" />;
root.render(element);
```
**Props是只读的，组件不能修改自身props的值。**