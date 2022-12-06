---
title: React-Redux(7)
date: 2022-12-03
tags:
- React
---

## React-Redux
是基于React封装的Redux库，仅支持react
### 三大核心概念
**1. state**
存放公共状态
```js
{
 todos: [{
     text: 'Eat food',
     completed: true
 }, {
     text: 'Exercise',
     completed: false
 }],
 visibilityFilter: 'SHOW_COMPLETED'
 }
```
**2. action**
就是一个普通js对象，用来描述发生了什么。
强制使用 action 来描述所有变化带来的好处是可以清晰地知道应用中到底发生了什么。如果一些东西改变了，就可以知道为什么变。
**action相当于描述发生什么的指示器。**
```js
{ type: 'ADD_TODO', text: 'Go to swimming pool' }
{ type: 'TOGGLE_TODO', index: 1 }
{ type: 'SET_VISIBILITY_FILTER', filter: 'SHOW_ALL' }
```
**3. reducer**
将action和state串联起来，开发一些函数，真正按照action的指示来改变state
```js
function visibilityFilter(state = 'SHOW_ALL', action) {
  if (action.type === 'SET_VISIBILITY_FILTER') {
    return action.filter;
  } else {
    return state;
  }
}

function todos(state = [], action) {
  switch (action.type) {
  case 'ADD_TODO':
    return state.concat([{ text: action.text, completed: false }]);
  case 'TOGGLE_TODO':
    return state.map((todo, index) =>
      action.index === index ?
        { text: todo.text, completed: !todo.completed } :
        todo
   )
  default:
    return state;
  }
}
```
### 三大原则
- 单一数据源
  所有state存放到一起
- State只读
  唯一改变state的方法就是触发action，用于描述已发生事件的普通对象。
- 使用传函数来执行修改
  需要编写reducers真正修改state，Reducer 只是一些纯函数，它接收先前的 state 和 action，并返回新的 state。
### Action
action创建函数，返回一个action对象，一些action示例。
```js
/*
 * action 类型
 */

export const ADD_TODO = 'ADD_TODO';
export const TOGGLE_TODO = 'TOGGLE_TODO'
export const SET_VISIBILITY_FILTER = 'SET_VISIBILITY_FILTER'

/*
 * 其它的常量
 */

export const VisibilityFilters = {
  SHOW_ALL: 'SHOW_ALL',
  SHOW_COMPLETED: 'SHOW_COMPLETED',
  SHOW_ACTIVE: 'SHOW_ACTIVE'
}

/*
 * action 创建函数
 */

export function addTodo(text) {
  return { type: ADD_TODO, text }
}

export function toggleTodo(index) {
  return { type: TOGGLE_TODO, index }
}

export function setVisibilityFilter(filter) {
  return { type: SET_VISIBILITY_FILTER, filter }
}
```
### Reducer
Reducer本质上就是这种形式
```js
(state1, action)=>{
    // 根据action指示生成新的state2
    return stste2
}
```
下面是一个Reducer的示例：
```js
import {
  ADD_TODO,
  TOGGLE_TODO,
  SET_VISIBILITY_FILTER,
  VisibilityFilters
} from './actions'

...

function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    case ADD_TODO:
      return Object.assign({}, state, {
        todos: [
          ...state.todos,
          {
            text: action.text,
            completed: false
          }
        ]
      })
    case TOGGLE_TODO:
      return Object.assign({}, state, {
        todos: state.todos.map((todo, index) => {
          if (index === action.index) {
            return Object.assign({}, todo, {
              completed: !todo.completed
            })
          }
          return todo
        })
      })
    default:
      return state
  }
}
```
**拆分Reducer**
可以将上边的示例代码中对一些逻辑进行单独封装成一个新的reducer
```js
function todos(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        ...state,
        {
          text: action.text,
          completed: false
        }
      ]
    case TOGGLE_TODO:
      return state.map((todo, index) => {
        if (index === action.index) {
          return Object.assign({}, todo, {
            completed: !todo.completed
          })
        }
        return todo
      })
    default:
      return state
  }
}

function visibilityFilter(state = SHOW_ALL, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return action.filter
    default:
      return state
  }
}

function todoApp(state = {}, action) {
  return {
    visibilityFilter: visibilityFilter(state.visibilityFilter, action),
    todos: todos(state.todos, action)
  }
}
```

上述示例只有todoApp返回了完整的state，因此是主Reducer，负责联合子Reducer模块
Redux提供API——**combineReducers**也可以实现该功能。
```js
import { combineReducers } from 'redux'

const todoApp = combineReducers({
  visibilityFilter,
  todos
})

export default todoApp
```

```js
import { combineReducers } from 'redux'
import * as reducers from './reducers'

const todoApp = combineReducers(reducers)
```

### Store
Store负责将reducer、action、state联系到一起
Store有以下职责：
- 维持应用的 state；
- 提供 getState() 方法获取 state；
- 提供 dispatch(action) 方法更新 state；
- 通过 subscribe(listener) 注册监听器;
- 通过 subscribe(listener) 返回的函数注销监听器。
创建一个store
```js
import { createStore } from 'redux'
import todoApp from './reducers'
let store = createStore(todoApp)
// createStore第二个参数可选，用于初始化state
```
发起Action
```js
import {
  addTodo,
  toggleTodo,
  setVisibilityFilter,
  VisibilityFilters
} from './actions'

// 打印初始状态
console.log(store.getState())

// 每次 state 更新时，打印日志
// 注意 subscribe() 返回一个函数用来注销监听器
const unsubscribe = store.subscribe(() =>
  console.log(store.getState())
)

// 发起一系列 action
store.dispatch(addTodo('Learn about actions'))
store.dispatch(addTodo('Learn about reducers'))
store.dispatch(addTodo('Learn about store'))
store.dispatch(toggleTodo(0))
store.dispatch(toggleTodo(1))
store.dispatch(setVisibilityFilter(VisibilityFilters.SHOW_COMPLETED))

// 停止监听 state 更新
unsubscribe();
```

### 数据流
**严格的单项数据流**是Redux架构的设计核心
应用数据生命周期遵循以下四个步骤：
1. 调用store.dispatch
2. Redux store 调用传入的reducer函数
3. 根 reducer 应该把多个子 reducer 输出合并成一个单一的 state 树
4. Redux store 保存了根 reducer 返回的完整 state 树