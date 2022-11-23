---
title: 面试备战-Vue
date: 2022-11-16 00:03:54
tags:
- Vue
categories: 
- 面试备战
---

## Vue2、3响应式原理

Vue2使用Object.defineProperty,而Vue3使用Es6 Proxy 

- 前者无法对数组监听起到很好的效果，且无法监听对象添加了属性，通过下标方式修改数组数据
- 前者只能劫持对象的属性
- 后者不但可以劫持对象，数组，且支持劫持新增的属性

```jsx
let obj = {}
// 数据描述符
Object.defineProperty(obj, 'key', {
    value: 1, // 设置初始值
    writable: false, // 设置是否可写
    enumerable: true, // 设置是否可循环
    configurable: true, // 属性是否可删除
})

obj.key = 2
console.log(obj.key); // 1

let obj2 = {}
Object.defineProperty(obj2, 'key', {
    get() {
        console.log('执行了get操作');
        return 1
    },
    set(val) {
        console.log('执行了set操作');
        val++
    }
})
console.log(obj2.key);
obj2.key = 3
console.log(obj2.key);
```

```jsx
const obj = {
    name: 'aran',
    age: 1,
    school: {
        aign: 'no1'
    }
}

// 封装一个监听数据变化的函数
function defineProperty(obj, key, val) {
    // 如果监听的值是对象，则也需要进行观察

    Object.defineProperty(obj, key, {
        get() {
            observer(val)
            console.log('get');
            return val
        },
        set(newVal) {
            observer(val)
            console.log('set');
            val = newVal
        }
    })
}

function observer(obj) {
    if (typeof obj !== 'object' || obj == null) {
        return
    }
    // 给对象每个属性都设置响应式
    for (let i in obj) {
        defineProperty(obj, i, obj[i])
    }
}
observer(obj)
obj.name = 1
console.log(obj.school);
```

## Hash模式和History模式

更新视图但不重新请求界面，Vue通过监听地址栏的变化，将匹配的组件加载到对应的router-view中。

- 在url表现上hash有#
- 原理上，Hash是浏览器监听**onhashchange**事件的
- history是通过修改浏览器历史记录进行修改，但不会立即对后端进行请求，**pushState()**, **replaceState()** 通过**popState**事件监听
- history模式会占用服务器资源，而hash不利于seo优化

## 什么是MVVM、MVC、MVP

## MVVM

M代表数据

V代表组件

VM代表同步View和Model的对象

MVC与MVVM区别其实并不大，都是一种设计思想，主要是vm与c的不同，vue基于数据驱动，数据改变，自动更新视图，而不是告知view去操作DOM更新视图

## MVC

- M数据
- V视图
- C控制器（用于监听用户与应用的响应操作，一旦用户与页面进行交互，controller触发器会告知model去修改数据，model再通知view更新视图）

## MVP

实现了v与M的解耦，原来的C无法去更新View，但是MVP模式下，P(Presenter)代替了C，可以将视图和数据进行同步更新

## 生命周期

每个Vue组件实例在创建时都会经历一系列的初始化步骤，比如**设置数据侦听**，**编译模板**，挂**载实例到DOM**，**数据更新时修改DOM**。在这些过程中会运行特定的声明周期钩子来做一些事情。

顺序如下：

- setup 第一个调用，此时还没有初始化
- beforeCreate Vue实例创建完毕之前执行
- created Vue实例创建完毕之后执行
- beforeMount 模板渲染在页面之前执行
- mounted 模板渲染在页面之后执行
- beforeUnmount组件销毁前执行
- unmounted组件销毁后执行
- beforeUpdate 数据更新前执行
- updated数据更新后执行

## 常见的事件修饰符

- stop 阻止事件冒泡
- prevent 阻止默认事件
- capture 开启事件捕获模式
- self 只触发自身范围内的事件
- once 只会触发一次

## 如何保存页面当前的状态

分为两种情况：

- 前组件会被卸载
    - 用h5web存储来记录组件卸载前的状态
    - 路由传值
- 前组件不会被卸载
    - 要切换的组件作为子组件全屏渲染，父组件中正常储存页面状态。

keep-alive保存状态

## Data为什么是函数

为了组件复用，每次获取一个新的data，避免data数据域污染

## $nextTick

由于vue是异步渲染的，因此改变DOM之后，立即获取DOM信息是不准确的，因此需要调用nextTick函数，在DOM异步渲染完毕之后，再调用nextTick中的回调函数来获取DOM信息。

使用场景：

- 在数据变化后执行某个操作
- created钩子中，由于DOM还没渲染，所以此时如果想要操纵DOM，必须将操作代码放在nextTick回调函数中。
- 比如我现在点击按钮，修改组件的文字，然后立即获取该组件，并打印，发现打印出的组件文字并没有修改。想要获取修改之后的组件需要使用nextTick函数，并传递一个回调函数，修改组件之后会调用该回调函数。

## 单页面（spa）多页面（mpa）

- 单页面，只有一个主页面应用，一开始只需要加载一次相关资源。每次切换仅刷新局部资源。
- 多页面，有多个独立页面，每个页面必须重复加载资源，页面跳转需要多次加载资源，整页资源刷新。

[![z3uAOI.png](https://s1.ax1x.com/2022/11/22/z3uAOI.png)](https://imgse.com/i/z3uAOI)

## Vue Template到render的过程

解析、优化、生成

1. 调用parase方法将template解析为AST抽象语法树
2. 对静态节点做优化，进行标记，避免每次重复渲染静态节点
3. 将AST转化为render函数字符串

## Vue data值发生改变会直接同步执行渲染函数吗？

不会立即同步执行重新渲染。 Vue 实现响应式并不是数据发生变化之后 DOM 立即变化，而是按一定的策略进行 DOM 的更新。 Vue 在更新 DOM 时是异步执行的。 只要侦听到数据变化， Vue 将开启一个队列，并缓冲在同一事件循环中发生的所有数据变更。

如果同一个watcher被多次触发，只会被推入到队列中一次。 这种在缓冲时去除重复数据对于避免不必要的计算和 DOM 操作是非常重要的。 然后，在下一个的事件循环tick中，Vue 刷新队列并执行实际（已去重的）工作。

## **mixin、extends**

mixin混入，Vue3明确表示可以使用组合式api代替mixin的使用，目的是复用组件逻辑

extends，组件继承，与mixin类似，复用组件逻辑

## **delete和Vue.delete删除数组的区别**

前者只是将数组当前下标数据置为空，后者是直接移除数组元素，后边往前移

## 如何理解SSR服务端渲染

也就是服务端渲染，将Vue在客户端标签渲染程HTML的工作放到服务端完成后，返回给客户端。

优点：

- SEO优化
- 首屏加载速度更快

缺点：

- 服务端负载
- 对Node.js环境要求更高
- 服务端只支持beforeCreated和created两个钩子

## Vue性能优化

编码阶段

- 尽量减少data中的数据段
- v-if和v-for不能连用，但是v3之后提升了v-if的优先级，使得可以连用
- 使用事件委托的方式为v-for每一项绑定事件
- SPA应用采用keep-alive缓存组件
- 更多情况使用v-if代替v-show
- 懒加载，异步组件
- 防抖节流
- 第三方模块按需引入
- 图片懒加载
- 长列表滚动到可视区域动态加载（可以使用自定义组件的方式）

SEO优化

- 预渲染
- 服务端渲染

用户体验

- 骨架屏

## 解决Vue加载花屏问题

1. 添加v-cloak，当解析完成后，vue会自动删除v-cloak属性，因此可以配合css属性选择器
2. 在根元素添加**style="display: none;" :style="{display: 'block'}"**

## 组件通信

- Vuex
- props/emit
- ingect/provide
- $attrs/$listeners
- $children/$parent
- eventbus事件总线
- $refs获取组件实例

## 路由

## 懒加载

- 箭头函数+import引入
- 箭头函数+require动态加载
- webpack

## Hash与History

Hash实现原理是通过监听onHashChange事件来切换页面，可以称之为严格意义上的前端路由，因为完全不和后端进行交互，浏览器支持度高。

history实现原理是通过H5 history api 新增的pushState() 与 replaceState()方法，对浏览器历史记录进行修改，修改url并不会立即刷新页面，但是手动刷新会报404，必须后端同志配合。

## route与router

route是路由信息对象，包括 path，params，hash，query，fullPath，matched，name 等路由信息参数

router是路由实例对象，包括了路由的跳转方法，钩子函数等。

## 动态路由

1. **params方式**
    
    ```jsx
    //在APP.vue中
    <router-link :to="'/user/'+ userId" replace>用户</router-link>    
    
    //在index.js
    {
       path: '/user/:userid',
       component: User,
    },
    
    // 方法1：
    <router-link :to="{ name: 'users', params: { uname: wade }}">按钮</router-link
    
    // 方法2：
    this.$router.push({name:'users',params:{uname:wade}})
    
    // 方法3：
    this.$router.push('/user/' + wade)
    
    // 参数获取
    $route.params.userid
    ```
    

 2. **query模式**

```jsx
// 配置路由
普通配置即可

// 路由跳转
// 方法1：
<router-link :to="{ name: 'users', query: { uname: james }}">按钮</router-link>

// 方法2：
this.$router.push({ name: 'users', query:{ uname:james }})

// 方法3：
<router-link :to="{ path: '/user', query: { uname:james }}">按钮</router-link>

// 方法4：
this.$router.push({ path: '/user', query:{ uname:james }})

// 方法5：
this.$router.push('/user?uname=' + jsmes)

// 获取参数
$route.query
```

## 触发钩子的完整顺序

假设组件A、B都被keep-alive组件包裹，从A组件首次进入B组件

```jsx
beforeRouteLeave → beforeEach → beforeEnter → beforeRouteEnter → beforeResolve → 
afterEach → beforeCreated → created → beforeMounted → deactivated → mounted → 
activited → beforeRouterEnter-next中的回调函数 
```

## **Vue-router跳转和location.href有什么区别**

location.href 跳转刷新了页面，而router.push()并没有刷新页面

在history模式中，history.pushState(XXX)跳转和router.push(XXX)跳转本质上没区别。

## 对前端路由的理解

起初阶段，每个页面对应一个url，每次切换页面需要从浏览器重新加载资源并刷新页面

随着Ajax(可以在不刷新页面发起请求)的出现，催生出了SPA页面的概念，但是在SPA诞生之初，切换页面url始终保持不变，浏览器无法准确记录访问历时，因此出现了前端路由，也就是浏览器展示的组件与url的一个映射关系，从而实现JS切换展示组件的功能，并且能记录历时记录。

## Vuex

- State用来存放公共状态
- Getter相当于Vuex的计算属性
    - 普通访问
    - 函数访问
- Mutation存放函数用于变更状态
    - Mutation中必须存放同步代码，不可以异步修改State的值
    - 采用commit的方式唤醒Mutation事件
- Action用于异步提交Mutation事件从而变更State状态
    - 采用派发dispatch的方式唤醒Action事件
- Module允许将臃肿的Vuex分模块

## Vue3升级了什么

1. 检测机制改变
    
    有原来的Object.defineProperty变为了ES6 Proxy，Proxy最大的好处就是可以一次对整个对象监听，不用再一次遍历对象属性进行监听。其次就是支持数组、Map、Set等更多的数据类型监听
    
2. 提升了v-if优先级，高于v-for
3. 将作用域插槽改成了函数的方式，当插槽改变，父组件不用跟着重新渲染了
4. 新增了组合式api，更好抽离业务逻辑，解决了原来的this指向问题

## 虚拟DOM

Virtual Dom实际上式一个JS对象，通过对象的方式来表示DOM结构，配合不同的渲染工具，使跨平台成为可能。通过将多次Dom修改的结果一次性更新到页面上，从而减少页面的渲染次数。

再每次数据发生变化之前，虚拟DOM都会将新旧VDOM通过diff算法进行对比，从而改变真实DOM。

## 虚拟DOM对比真实DOM

真实DOM：生成HTML字符串、重建所有DOM元素

虚拟DOM：生成Node、diff算法、更新必要DOM

虚拟DOM首次加载DOM更慢，但是在真实DOM针对特定优化下更快

## diff算法

不会跨级对比，只会在新旧VDOM树的同一层去对比。

深度遍历的过程