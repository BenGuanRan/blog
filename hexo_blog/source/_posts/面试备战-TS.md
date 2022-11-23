---
title: 面试备战-TS
date: 2022-11-12 00:03:54
tags:
- TS
- JS
categories: 
- 面试备战
---

## **声明数组**

```tsx
var numlist:number[] = [2,4,6,8]
```

## **如果元素不同，则是元组**

## **联合类型**

```jsx
Type1|Type2|Type3
```

## 接口（interface）

一系列抽象方法的声明，是一些方法特征的集合

```jsx
interface IPerson {
    firstName: string,
    lastName: string,
    sayHi: () => string
}

var customer: IPerson = {
    firstName: "Tom",
    lastName: "Hanks",
    sayHi: (): string => { return "Hi there" }
} 
// 也可以这样写
// var customer = <IPerson>{
//     firstName: "Tom",
//     lastName: "Hanks",
//     sayHi: (): string => { return "Hi there" }
// }
console.log(customer);
```

**联合类型+接口**

```jsx
interface IPerson {
    name: string | string[]
    sayHi: () => string | void
}

var customer: IPerson = {
    name: ["Hanks", 'aa'],
    sayHi: (): void => { }
}
console.log(customer);
```

**数组+接口**

```jsx
interface A {
    [index: number]: string | number
}
const a: A = ['1', 1]
const b = {
    '0': '1',
    '1': 1
}
console.log(a,b);

interface namelist {
    [index: number]: string
}

// 类型一致，正确
const list2: namelist = ["Google", "Runoob", "Taobao"]
```

**接口继承**

```jsx
Child_interface_name extends super_interface1_name, super_interface2_name,…,super_interfaceN_name
```

## 类

```jsx
class class_name { 
    // 类作用域
}
```

```jsx
class Car { 
   // 字段
   engine:string; 
   
   // 构造函数
   constructor(engine:string) { 
      this.engine = engine 
   }  
   
   // 方法
   disp():void { 
      console.log("函数中显示发动机型号  :   "+this.engine) 
   } 
} 
 
// 创建一个对象
var obj = new Car("XXSY1")
 
// 访问字段
console.log("读取发动机型号 :  "+obj.engine)  
 
// 访问方法
obj.disp()
```

**TS一次只支持继承一个类，并不支持一次继承多个类，这一点区别于TS接口**

**继承**

super是对父类的直接引用

```tsx
class Father {
    name: string
    job: string
    constructor(name: string, job: string) {
        this.name = name
        this.job = job
    }
    doJob(job: string | void): string {
        job = job || this.job
        console.log('我正在做' + job);
        return '我正在做' + job
    }
}

class Son extends Father {
    constructor(name: string, job: string) {
        super(name, job)
    }
    doJob(): string {
        console.log('我正在学' + this.job);
        return '我正在学' + this.job
    }
    fatherJob(): void {
        super.doJob('监督儿子' + this.job + '的工作')
    }
}

const f = new Father('Bob', '司机')
f.doJob()
const s = new Son('Mack', 'Ts')
s.doJob()
s.fatherJob()
```

**访问控制**

- **public（默认）** : 公有，可以在任何地方被访问。
- **protected** : 受保护，可以被其自身以及其子类访问。
- **private** : 私有，只能被其定义所在的类访问。

**实现接口（implements）**

```tsx
interface ILoan { 
   interest:number 
} 
 
class AgriLoan implements ILoan { 
   interest:number 
   rebate:number 
   
   constructor(interest:number,rebate:number) { 
      this.interest = interest 
      this.rebate = rebate 
   } 
} 
 
var obj = new AgriLoan(10,1) 
console.log("利润为 : "+obj.interest+"，抽成为 : "+obj.rebate )
```

## 对象

```tsx
ts中对象是事先定义好的模板，不能自己再添加属性
const m = {
    x: 1,
    // a: (): void => { }
}
m.a = () => {
    console.log(1);

}
// 上述是不被允许的
```

## type类型别名

```tsx
type AB = {
    name?: string,
    age: number,
    c: '1' | 2
}
const d: AB = {
    age: 1,
    c: 2
}
```