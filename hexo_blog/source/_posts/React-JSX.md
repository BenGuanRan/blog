---
title: React-JSX(2)
date: 2022-11-26
tags:
- React
---

## 一个简单的组件
```js
ReactDOM.render(
    <h1>Hello, world!</h1>,
    document.getElementById('root')
);
```
## 什么是JSX
jsx可以理解为是js语言的一个扩展，React建议使用jsx，jsx拥有js的全部功能。

## 在JSX中嵌入表达式
```jsx
// 花括号中甚至可以是函数表达式等
const name = 'Josh Perez';
const element = <h1>Hello, {name}</h1>;

ReactDOM.render(
  element,
  document.getElementById('root')
);
```

## JSX添加属性
```jsx
// 普通字符串
const element = <div tabIndex="0"></div>;
// 使用花括号在属性值中插入一个js表达式
const element = <img src={user.avatarUrl}></img>;
```

## JSX防注入
可以安全地在jsx中插入用户输入内容
因为ReactDOM在渲染所有输入内容之前会进行转移，所有内容在渲染之前都会转成字符串，防止XSS攻击。