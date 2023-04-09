---
title: JS
date: 2022-11-11 00:03:54
tags:
- JS


---

## 类型转换
[https://juejin.cn/post/6844903983429976078](https://juejin.cn/post/6844903983429976078)

一些例子

```jsx
0 + '1' === '01'            // true
true + true === 2           // true
false === 0                 // false
false + false === 0         // true
{} + [] === 0               // true
[] + {} === 0               // false
```

- 类型种类
    - 简单类型
        - number
        - string
        - boolean
        - null
        - undefined
        - bigint
        - symbol
    - 复杂类型
        - 对象
- 强制类型转换
    - toString
        
        ```jsx
        String(4)                    // "4"
        String(false)                // "false"
        String(true)                 // "true"
        String(null)                 // "null"
        String(undefined)            // "undefined"
        String(Symbol('s'))          // "Symbol(s)"
        // 对于复杂数据类型，toString()会调用原型上的toString方法，
        // 因此可以重写该方法
        var arr = [1, 2];
        arr.toString()             // "1,2"
        String(arr)                // "1,2"
        // 重写toString
        arr.toString = function() { return this.join('/') };
        String(arr)                // "1/2"
        ```
        
    - toNumber
        
        ```jsx
        Number("4")                  // 4
        Number("4a")                 // NaN
        Number("")                   // 0
        Number(false)                // 0
        Number(true)                 // 1
        Number(null)                 // 0
        Number(undefined)            // NaN
        Number(Symbol('s'))          // TypeError...
        
        // 对于引用类型，会先看对象中是否有valueOf()方法，若有则先调用valueOf
        // ，否则调用toString，最后才返回NaN。
        
        ```
        
- 隐式转换
    
    js隐式转换都遵循强制转换规则的
    
    在隐式转换中最令人迷惑的应该就是+操作符和==操作符导致的隐式转换
    ，因为对于其他类型的操作符，类型四则运算的-、*、÷和位运算符&、^、|在设计目标就是对数字进行操作。
    
    - **+的隐式转换**
        
        **两边都能转换成数字才进行数字相加，否则就进行字符串拼接**
        
    - **==的隐式转换**
        
        ```jsx
        NaN == NaN        // false，这算是个坑吧，没啥聊的
        null == undefined // true，属于ecma规范
        [1] == 1      // true
        false == '0'  // true
        false == ''   // true
        '' == '0'     // false
        true == 1     // true
        false == 0    // true
        true == []    // false
        [] == {}      // false
        
        var obj = {
            valueOf: function() { return 1 }
        }
        
        obj == 1     // true
        // 绝望
        [] == ![]    // true
        
        ```
        
    
    **对于数字和字符串的抽象比较，将字符串进行ToNumber操作后再进行比较**
    
    **对于布尔值和其他类型的比较，将其布尔类型进行ToNumber操作后再进行比较**
    
    **对于对象和基础类型的比较，将对象进行ToPrimitive操作后在进行比较**
    
    **对象之间的比较，引用同一个对象则为true，否则为false**

**总结：**
对于+而言，若出现字符串，则进行字符串拼接，否则两边尽可能转化成Number类型进行运算。
对于==而言，对于object而言，进行toPrimitive操作，先看valueOf是否转换普通类型，再看toString是否转换普通类型，否则报错。

## 作用域与作用域链
### 全局作用域

- 最外层函数和最外层变量
- 未直接声明就赋值的变量
- window对象的属性

### 函数作用域

- 定义在函数内部的变量

### ES6块级作用域

- let const {}

### 作用域链

在当前作用域中查找所需变量，但是该作用域没有这个变量，那这个变量就是自由变量。如果在自己作用域找不到该变量就去父级作用域查找，依次向上级作用域查找，直到访问到window对象就被终止，这一层层的关系就是作用域链。

作用域链的作用是**保证对执行环境有权访问的所有变量和函数的有序访问，通过作用域链，可以访问到外层环境的变量和函数。**

作用域链的本质上是一个指向变量对象的指针列表。变量对象是一个包含了执行环境中所有变量和函数的对象。作用域链的前端始终都是当前执行上下文的变量对象。全局执行上下文的变量对象（也就是全局对象）始终是作用域链的最后一个对象。

当查找一个变量时，如果当前执行环境中没有找到，可以沿着作用域链向后查找。

### 执行上下文

- 全局执行上下文
- 函数执行上下文
- eval函数执行上下文

**执行上下文栈**

JavaScript引擎使用执行上下文栈来管理执行上下文当JavaScript执行代码时，首先遇到全局代码，会创建一个全局执行上下文并且压入执行栈中，每当遇到一个函数调用，就会为该函数创建一个新的执行上下文并压入栈顶，引擎会执行位于执行上下文栈顶的函数，当函数执行完成之后，执行上下文从栈中弹出，继续执行下一个上下文。当所有的代码都执行完毕之后，从栈中弹出全局执行上下文。

在执行一点JS代码之前，需要先解析代码。解析的时候会先创建一个全局执行上下文环境，先把代码中即将执行的变量、函数声明都拿出来，变量先赋值为undefined，函数先声明好可使用。这一步执行完了，才开始正式的执行程序。

**总结**：作用域分为全局、块级、函数，函数执行上下文在执行时入栈，执行完出栈（执行栈），全局执行上下文最后出栈。

## 闭包以及闭包的应用
**闭包就是一个函数，能够访问另一个函数作用域内的变量。**

- **产生原因**
    
    作用域链，每个函数都会拷贝上一级的作用域链+本地的作用域来形成自身的作用域链。
    
    当一个函数，在另一个函数的作用域内，就会访问父函数作用域内的自由变量。
    
- **闭包的表现形式**
    - 返回一个函数
    - 作为函数参数传递
    - 使用了回调函数
    - 立即执行函数
### 基础（Base）函数装饰器

**函数修饰器，都是基于此变化而来。**

```jsx
function Base(fn) {
    return function (...args) {
        return fn.apply(this, args)
    }
}
```

### 防抖（Debounce）

**就是一个函数执行两次需要指定间隔时间，若不能满足，则重新计算间隔时间。**

```jsx
// 防抖，被装饰的函数每隔一定时间间隔才能运行，若强制运行，则会重新计算间隔时间
export function Debounce(fn, delay_time) {
    let timer = null
    return function (...args) {
        if (timer){ clearTimeout(timer); timer = null}
        timer = setTimeout(fn.bind(this, ...args), delay_time)
    }
}
```

### 节流（Throttle）

**节流， 函数在特定时间内只能执行一次。**

```jsx
// 节流， 函数在特定时间内只能执行一次
export function Throttle(fn, time) {
    let timer = null
    return function (...args) {
        if (timer) return
        timer = setTimeout(() => {
            fn.apply(this, args)
            timer = null
        }, time)
    }
}
```

### 万斯（Once）

**函数只执行一次**

```jsx
// 函数只执行一次
export function Once(fn) {
    let flag = true
    return function (...args) {
        if (flag) {
            flag = false
            return fn.apply(this, args)
        }
    }
}
```

### 限制（Limit）

**限制函数执行指定次数。**

```jsx
// 函数只执行限定次数
export function Limit(fn, num) {
    let count = 0
    return function (...args) {
        count++
        if (count <= num)
            return fn.apply(this, args)
    }
}
```

### 消耗（Consumer）

**定义操作栈，间隔某个时间从操作栈取出执行(延迟执行效果)**

```jsx
// 定义操作栈，间隔某个时间从操作栈取出执行(延迟执行效果)
export function Consumer(fn, time) {
    const ops = []
    let timer = null
    return function (...args) {
        ops.push(fn.bind(this, ...args))
        if (timer) return
        timer = setInterval(() => {
            if (ops.length === 0) {
                clearInterval(timer)
                timer = null
                return
            }
            return (ops.shift())() // 立即执行函数
        }, time)
    }
}
```
## 数组扁平化
- arr.flat()方法
- 先转化为字符串再字符串操作
- 转化为JSON字符串，再正则替换
- 递归
```js
let a = [1, 2, [3, [4, 5, [6, 7, { a: 1 }]]]]
console.log(a.flat(1));

let res = []
function myFlat(item, n) {
    for (let i of item) {
        if (Array.isArray(i) && n > 0) {
            n--
            myFlat(i)
        } else {
            res.push(i)
        }
    }
}
myFlat(a, 1)
console.log(res);
```

## 数组中常用的高阶函数
- map
- reduce
- filter
- sort
  内部是利用递归进行冒泡排序的，传入一个Compare函数，根据返回bool判断是否交换两个数。
- some
- every

## var与let
- var无块级作用域
- var存在变量提升
- var重复声明变量依然照常运行
- 全局定义的var变量会成为window的属性，let和const则不会

## 深拷贝与浅拷贝
手动实现：
```js
function clone(target) {
    if (typeof target === 'object' && target !== null) {
        let cloneTarget = Array.isArray(target) ? [] : {}
        for (let i in target) {
            cloneTarget[i] = clone(target[i])
        }
        return cloneTarget
    } else {
        return target
    }
}
const target = {
    field1: 1,
    field2: null,
    field3: 'ConardLi',
    field4: {
        child: 'child',
        child2: {
            child2: 'child2',
            a: [1, 2, 23, 3]
        }
    }
};


console.log(clone(target));

```

## 浏览器输入URL发生了什么
浏览器先去服务器找真实IP -> 与客户端建立连接 -> 缓存协商 -> 获取页面 -> 渲染页面

## this指向问题
1. 全局上下文

    this默认指向window，严格模式指向undefined
    
2. 对象中的方法
    
    谁调用指向谁，若在全局调用则指向按照全局上下文
    
3. 事件绑定
    
    指向绑定事件的dom元素
    
4. 箭头函数
    
    指向最近一级作用域，若外部有非箭头函数包裹，则this指向箭头函数this，否则指向window（严格模式undefined）

## 数据是如何存储的
一般来说，普通数据类型存放在栈中，引用数据类型，也就是对象，存放在堆中。

但是闭包例外，闭包变量存放在堆中。

栈不仅仅存放临时数据类型，同时也用来记录当前程序的执行状态，也就是将程序执行上下文的指针存放到栈中。

## 垃圾回收（GC）
并行回收，浏览器垃圾清理线程会开启多个辅助线程来帮助浏览器进行垃圾清理，缩短垃圾清理时间，也就是主线程**全停顿**时间

**v8堆内存大小**

64位系统而言，新生代64MB，老生代1.4G

无法控制垃圾回收时间

**变量 → 新生代 → 老生代**

### 新生代

采用**Copy(复制)**、**Scavenge(新生代互换)**

### 老生代

采用**Mark-Sweep(标记清除)**、**Mark-Compact(标记整理)**

**Mark-Compact先整理再清除**

在那之后，由于统一时间进行内存清理，因此用户体验比较差，也就出现了之后的增量标记，但是又出现一个问题，也就是1.暂停后如何恢复；2.暂停后引用关系修改了怎么办。解决办法：
- 三色标记法
  - 黑：被引用对象，且成员函数均被标记
  - 白：未引用对象
  - 灰：自身被引用，但成员对象指向的引用未被标记
- 写屏障法
  - 强制将被改变对象的颜色变为灰色

## 浏览器如何运行js代码
1. 首先通过词法分析，语法分析，生成**AST（抽象语法树）**
2. 其次，将AST转换为字节码
3. 最后，**解释器**逐行执行**字节码**，当遇到某一部分代码重复出现，v8则会启动**编译器**，将**热点代码**编译成机器码，以优化执行效率。（这也就是为什么js并不是严格意义上的解释性语言，因为有编译器的参与。）

**为什么需要先转换成字节码，直接转换成机器码不好吗？**

这是因为机器码占据内存大，这样做减轻了内存的负荷。

## 浏览器事件循环机制
**浏览器的事件循环机制图解**

[![z3ZS2R.md.png](https://s1.ax1x.com/2022/11/22/z3ZS2R.md.png)](https://imgse.com/i/z3ZS2R)

由于js是单线程模式，因此有了同步任务，异步任务之分

异步任务又分为宏任务、微任务

执行顺序是:

**同步任务** → **微任务** → **宏任务**

### 宏任务

- setTimeout\setInterval\setImmediate(这三个是由定时器模块控制，当到达事件后，进入宏任务队列，等待任务队列读取执行)
- 渲染事件
- 用户交互事件
- js脚本执行
- 网络请求、文件读写完成等等

### 微任务

- Promise
- V8垃圾回收
- MutationObserver

## Promise
Promise有一下三大特性：

- 回调函数延迟绑定
    
    回调函数并不是直接声明，而是从后面的.then方法传入
    
- 返回值穿透
    
    可以把返回的Promise穿透到外层
    
- 错误冒泡
    
    返回的错误会一直向后传递，被catch接收到
    

Promise解决的问题：

实现链式调用，解决多层嵌套的问题

错误的一站式处理，解决每次代码中判断错误，减少代码混乱度

#### Promise.then()参数必须是函数，如果是其他，则会传递下去

#### 现在有一个p，是一个Promise，p的所有返回值不可以是p本身

#### Promise.all()会等待Promise数组里面的都完成，或第一个失败，若都成功，则返回一个成功的数组，若有一个失败，则只catch出第一次失败的返回值，结束时间取决于最后所有Promise0完成的时间. 其他函数依然执行，但不会被捕获了。

#### Promise.race()会返回最快的Promise，完成时间与最后一个Promise执行时间相同，只捕获最早返回的函数，其他函数依然执行，只是不被捕获。

#### Async Await 可以理解为await后面的语句被放到new Promise中，之后的语句会放到Promise.then中

## 生成器Generator
调用Generator函数时，函数并不直接执行，而是返回一个指向函数内部状态的指针

**Generator相当于一个状态机，迭代器对象中，每次遇到 yield 或 return 时，就相当于一个状态，会暂停函数执行，调用next()才会向下运行，改变状态。**

**注意yield只能用在Generator函数里面，用在普通函数中会报错**

```jsx
function* foo() {
    yield '状态1'
    yield '状态2'
    return '终止状态'
}
const f = foo()
console.log(f);
console.log(f.next()); // { value: '状态1', done: false }
console.log(f.next()); // { value: '状态2', done: false }
console.log(f.next()); // { value: '终止状态', done: false }
```

**next可以传递参数,作为yield执行返回值**

```jsx
function* foo() {
    let a = undefined
    console.log(a);
    a = yield '状态1'
    console.log(a);
    a = yield '状态2'
    console.log(a);
    return '终止状态'
}
const f = foo()
console.log(f.next(12));
console.log(f.next(14));
console.log(f.next(24));
// undefined
// { value: '状态1', done: false }
// 14
// { value: '状态2', done: false }
// 24
// { value: '终止状态', done: true }
```

**for…of可以遍历Generator**

```jsx
function* foo() {
    let a = undefined
    a = yield '状态1'
    a = yield '状态2'
    return '终止状态'
}
const f = foo()
for (let i of f) {
    console.log(i);
}
// 状态1
// 状态2
```

**异步使用Generator函数**

[![z3ZPr6.md.png](https://s1.ax1x.com/2022/11/22/z3ZPr6.md.png)](https://imgse.com/i/z3ZPr6)
## 协程
Generator是如何然函数暂停执行后又再次恢复的呢，这里就涉及到协程的概念。

**什么是协程？**

协程是一种比线程更加轻量的存在，一个线程可以有多个协程。可以将协程理解为线程中的一个个任务。协程不由操作系统管理，而是通过被具体的应用程序代码所控制

**协程运作过程？**

协程之间是互斥执行的，比如当前执行A协程，要想此时执行B协程，需要先将A协程的控制权交给B，等待协程B运行完毕之后，再将协程控制权交给A。

```jsx
// 协程A
function* A() {
    console.log('我是协程A');
    yield B() // 将控制权交给协程B
    console.log('结束了');
}
function B() {
    console.log('我是协程B');
    return '我是B传给A的值'
}
const a = A()
a.next()
a.next()
```

## clientHeight、innerHeight、offsetHeight、scrollHeight联系和区别
- clientHeight返回视口高度，包括padding
- offsetHeight返回实际元素占用的像素高度
- innerHeight浏览器内部高度
- outerHeight浏览器包括工具栏
- scrollHeight包括由于滚动被抹去的部分元素高度
- scrollTop指的是滚动条滚动的长度

## js脚本延迟加载的方式

- defer属性 异步加载，最后执行，顺序不保证
- async属性 异步加载，加载后立即执行
- 动态注入script标签
- 使用setTimeout延迟方法
- 将js写到文档底部

## 变量提升

**变量提升，是指在 JavaScript 代码执行过程中，JavaScript 引擎把变量的声明部分和函数的声明部分提升到代码开头的“行为”。**

**函数先于变量进行提升**

## 尾调用

尾调用指的是函数的最后一步调用另一个函数。代码执行是基于执行栈的，所以当在一个函数里调用另一个函数时，会保留当前的执行上下文，然后再新建另外一个执行上下文加入栈中。使用尾调用的话，因为已经是函数的最后一步，所以这时可以不必再保留当前的执行上下文，从而节省了内存，这就是尾调用优化。但是 ES6 的尾调用优化只在严格模式下开启，正常模式是无效的。

## ES6 Module 与 CommonJS模块的异同

ES6相当于对模块的引用，不能改变其值 （const a = {}）

CommonJs相当于指针指向当前模块，可以改变指针指向 (let a = {})

## 常见的DOM操作

### 增加

采用先创建后添加的方式

createElement创建

appendChild添加

### 删除

removeChild删除

### 修改

*// 交换两个元素，把 content 置于 title 前面*

container.**insertBefore**(content, title)

### 查询

略

## 原型、原型链

每个构造函数（类）的内部都有一个原型属性prototype，属性值是一个对象，里面存放者所有实例（对象）所共有的属性和方法。每创建一个新的对象实例时，其内部有个指针（__proto__）指向构造函数的原型属性prototype。

**最好不要使用__proto__来获取原型，因为不规范，应该使用Object.getPrototypeOf()方法**

eg:

```jsx
function Person(name) {
	this.name = name
}
// 修改原型
Person.prototype.getName = function () { }
var p = new Person('hello')
console.log(p.__proto__ === Person.prototype) // true
console.log(p.__proto__ === p.constructor.prototype) // true
// 重写原型
Person.prototype = {
	getName: function () { }
}
var p = new Person('hello')
console.log(p.__proto__ === Person.prototype)        // true
console.log(p.__proto__ === p.constructor.prototype) // false
```

导致最后输出false的原因是：由于Person原型被修改，导致存放在原型中的构造函数（constructor）丢失，实例p在自身原型中查找自身构造函数未找到，于是继续向上查找吗，找到了Object的构造函数，类Object的prototype与修改之后的实例对象__proto__肯定不同，因此返回false

eg:

```jsx
p.__proto__  // Person.prototype
Person.prototype.__proto__  // Object.prototype
p.__proto__.__proto__ //Object.prototype
p.__proto__.constructor.prototype.__proto__ // Object.prototype
Person.prototype.constructor.prototype.__proto__ // Object.prototype
p1.__proto__.constructor // Person
Person.prototype.constructor  // Person
```

## Proxy

实际上重载了**.**运算符，即自己的定义覆盖了语言的原始定义，所有对对象的操作，都会会被Proxy感知。

```jsx
const p = new Proxt(target, handler)
// target是目标对象，handler是处理器
```

### handler的选项

- get(target, key, receiver)拦截取值
    
    get函数中必须有返回值或reflect操作才能返回值
    
- set(target, key, value, receiver)拦截赋值
    - 可用于实现数据验证
- apply(target, ctx, arg) 用于拦截函数调用
- has() 可用于隐藏属性
- 。。。详见文档[15. Reflect - 实例：使用 Proxy 实现观察者模式 - 《阮一峰 ECMAScript 6 (ES6) 标准入门教程 第三版》 - 书栈网 · BookStack](https://www.bookstack.cn/read/es6-3rd/spilt.3.docs-reflect.md)

## Reflect

- Reflect上的方法与Proxy上的选项一一对应，目的是找到改变之前的默认方法
- 将一些Object上明显属于语言内部的方法放到reflect上
- 修改某些Object上的方法，让其变得合理
- 将Object上的一些命令式行为变成函数式行为放在Reflect上