---
title: React-基础(5)
date: 2022-11-27
tags:
- React
---

## 事件绑定
react中事件绑定如下：
```jsx
<button onClick={activateLasers}>
  Activate Lasers
</button>
```
### 事件绑定中的this指向问题
示例如下：
```jsx
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};

    // 为了在回调中使用 `this`，这个绑定是必不可少的
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }

  render() {
    return (
        // 这里面handleClick的this指向是undefined
      <button onClick={this.handleClick}>
        {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}
```

你必须谨慎对待 JSX 回调函数中的 this，在 JavaScript 中，class 的方法默认不会绑定 this。如果你忘记绑定 this.handleClick 并把它传入了 onClick，当你调用这个函数的时候 this 的值为 undefined。
该问题可以通过三种方式解决：
1. 使用bind绑定this
```jsx
<button onClick={this.handleClick.bind(this)}>
    {this.state.isToggleOn ? 'ON' : 'OFF'}
</button>
```
2. 使用回调函数的方式
```jsx
<button onClick={() => this.handleClick()}>
    {this.state.isToggleOn ? 'ON' : 'OFF'}
</button>
```
3. 在定义handelClick函数时使用箭头函数
```jsx
handleClick = () => {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }
```
### 传参问题
正常传参即可
## 条件渲染
在渲染组件时插入条件逻辑：
```jsx
if (isLoggedIn) {
    button = <LogoutButton onClick={this.handleLogoutClick} />;
} else {
    button = <LoginButton onClick={this.handleLoginClick} />;
}
```
可以通过return null的方式组织组件渲染
## 列表 & Key
可以通过map的方式，将数组中的元素渲染成React中的元素：
```jsx
const listItems = numbers.map((number) =>
    <li key={number.toString()}>
      {number}
    </li>
);
```
**数组的每一项必须加上一个唯一的标识Key**
### Key的作用
key帮助react识别哪些元素改变了，比如被添加或删除。不建议使用index作为key值，这样做会导致性能变差，还可能引起组件的状态问题。
## 表单
此表单具有默认的 HTML 表单行为，即在用户提交表单后浏览到新页面。如果你在 React 中执行相同的代码，它依然有效。但大多数情况下，使用 JavaScript 函数可以很方便的处理表单的提交， 同时还可以访问用户填写的表单数据。实现这种效果的标准方式是使用“受控组件”。
### 受控组件
也就是将表单组件原来已有的内部数据源移交给React state进行管理，这样React能感知表单数据变化。

一个受控组件的例子：
```jsx
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    alert('提交的名字: ' + this.state.value);
    // 阻止默认提交事件 
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          名字:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>
        <input type="submit" value="提交" />
      </form>
    );
  }
}
```

## 状态提升
在 React 应用中，任何可变数据应当只有一个相对应的唯一“数据源”。通常，state 都是首先添加到需要渲染数据的组件中去。然后，如果其他组件也需要这个 state，那么你可以将它提升至这些组件的最近共同父组件中。你应当依靠自上而下的数据流，而不是尝试在不同组件间同步 state。

## 组合VS继承
React更希望使用组合的方式确立组件之间的关系，而非继承。

### 特殊的children props
```jsx
// 容器组件
function FancyBorder(props) {
  return (
    <div className={'FancyBorder FancyBorder-' + props.color}>
      {props.children}
    </div>
  );
}
// 组件
function WelcomeDialog() {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">
        Welcome
      </h1>
      <p className="Dialog-message">
        Thank you for visiting our spacecraft!
      </p>
    </FancyBorder>
  );
}
```
也就是放在容器组件之间的React元素都默认放在了容器组件的props.children属性中。
### React里面的"插槽"
插槽的概念是在Vue中的，但是在React中并没有插槽的概念，但是React props属性的强大完全代替了Vue里面的插槽的概念，由于React使用jsx，因此props可以传递一些类似HTML片段的对象。
```jsx
function SplitPane(props) {
  return (
    <div className="SplitPane">
      <div className="SplitPane-left">
        {props.left}
      </div>
      <div className="SplitPane-right">
        {props.right}
      </div>
    </div>
  );
}

function App() {
  return (
    <SplitPane
      left={
        <Contacts />
      }
      right={
        <Chat />
      } />
  );
}
```
## React哲学
也就是教你封装组件的思想。