---
title: React-进阶(6)
date: 2022-11-30
tags:
- React
---

## 懒加载

第一种方式
```jsx
import("./math").then(math => {
  console.log(math.add(16, 26));
});
```
第二种方式
```jsx
import React, { Suspense } from 'react';

const OtherComponent = React.lazy(() => import('./OtherComponent'));

function MyComponent() {
  return (
    <div>
    {/* 懒加载组件使用Suspense组件包裹 */}
      <Suspense fallback={<div>Loading...</div>}>
        <OtherComponent />
      </Suspense>
    </div>
  );
}
```

## Context
**Context 提供了一个无需为每层组件手动添加 props，就能在组件树间进行数据传递的方法。**
**Context 提供了一种在组件之间共享值的方式，而不必显式地通过组件树的逐层传递 props。**
### 使用Context的场景
Context 设计目的是为了共享那些对于一个组件树而言是“全局”的数据，例如当前认证的用户、主题或首选语言。举个例子，在下面的代码中，我们通过一个 “theme” 属性手动调整一个按钮组件的样式：

在没使用Conext之前遇到的问题
```jsx
class App extends React.Component {
  render() {
    return <Toolbar theme="dark" />;
  }
}

function Toolbar(props) {
  // Toolbar 组件接受一个额外的“theme”属性，然后传递给 ThemedButton 组件。
  // 如果应用中每一个单独的按钮都需要知道 theme 的值，这会是件很麻烦的事，
  // 因为必须将这个值层层传递所有组件。
  return (
    <div>
      <ThemedButton theme={props.theme} />
    </div>
  );
}

class ThemedButton extends React.Component {
  render() {
    return <Button theme={this.props.theme} />;
  }
}
```

使用Context就可避免这种情况

```jsx
// Context 可以让我们无须明确地传遍每一个组件，就能将值深入传递进组件树。
// 为当前的 theme 创建一个 context（“light”为默认值）。
const ThemeContext = React.createContext('light');
class App extends React.Component {
  render() {
    // 使用一个 Provider 来将当前的 theme 传递给以下的组件树。
    // 无论多深，任何组件都能读取这个值。
    // 在这个例子中，我们将 “dark” 作为当前的值传递下去。
    return (
      <ThemeContext.Provider value="dark">
        <Toolbar />
      </ThemeContext.Provider>
    );
  }
}

// 中间的组件再也不必指明往下传递 theme 了。
function Toolbar() {
  return (
    <div>
      <ThemedButton />
    </div>
  );
}

class ThemedButton extends React.Component {
  // 指定 contextType 读取当前的 theme context。
  // React 会往上找到最近的 theme Provider，然后使用它的值。
  // 在这个例子中，当前的 theme 值为 “dark”。
  render() {
    return (
      <ThemeContext.Consumer>
        {
          (val)=> {
            <Button theme={val} />;
          }
        }
      </ThemeContext.Consumer>
    )
  }
}
```

**要谨慎使用Context，会导致组件复用性变差.**

## 函数式组件
起初的函数式组件的特点：
1. 无生命周期
2. 没有this
3. 没有state状态

### Hooks
**Hook只能用在函数组件的最顶层**

**官方Hook：**
1. useState
```jsx
const [count, setCount] = useState(0)
// 通过setCount修改count值
```
渲染参数只会在组件首次渲染时使用，再次更新时会被忽略。如果初始值需要计算，则可以使用回调函数的方式进行返回值计算。
2. useEffect
副作用，什么是副作用？
对于主作用，就是数据更新，视图重新渲染。其他都是副作用，例如生命周期、ajax、手动修改DOM、localStorage操作等。  
能够模仿以下生命周期钩子
- mounted
- updated
- beforeDestory
第一个参数是回调函数，挂载时会触发该函数，第二个参数是数组，会对数组中变量的变化进行监听，从而调用相应回调函数。**如果第二个参数传一个空数组，则该副作用不会感知变量的更新。**
```jsx
const [count1, setCount1] = useState(0)
const [count2, setCount2] = useState(0)
useEffect(() => {
    console.log('模拟mounted挂载完成');
    console.log('count1和count2初始化或更新');
    return () => {
      console.log('模拟beforeDestory');
    }
}, [count1, count2])
useEffect(() => {
    console.log('模拟mounted挂载完成');
}, [])
```
**执行时机永远都是组件DOM渲染更新之后**
两个参数
- 默认状态，首次执行，每次组件更新执行（无第二个参数）
- 首次执行（添加[]）
- 首次执行，特定依赖项变化后执行（添加形如[count, num]）
3. useContext
```jsx
import React, { createContext, useContext } from 'react'

const MyContext = createContext()
function Father() {
    return <Son></Son>
}
function Son() {
    const val = useContext(MyContext)
    return <div>{'通过Context传递过来的值：' + val}</div>
}

export default function Context() {
    return (
        <MyContext.Provider value={'aaa'}>
            <Father></Father>
        </MyContext.Provider>

    )
}

```

4. useRef
获取DOM节点
使用步骤：
- 导入useRef函数
- 执行useRef函数传入null，返回值为一个对象，内部有current属性存放拿到的DOM对象
- 通过ref绑定要获取的组件或元素
1. useCallback、memo与useMemo
这三者是用来性能优化的


   