---
title: Ts魅力
date: 2022-12-08
tags:
- Ts
- Js
---

## Ts魅力
**本文只适合对Ts有一定基础，想要进一步提升Ts实力的人看！！！**

### keyof
**用于返回指定对象键值的联合类型**
```ts
type p = {
    x: number,
    y: number
}
type b = keyof p
// 类型b的取值只能是x或者y
const a: b = 'x'
```

### extends不只有继承
**extends还可以进行类型判断,如果extends前面的类型能够赋值给extends后面的类型，那么表达式判断为真，否则为假。**
```ts
interface A1 {
    name: string
}

interface A2 extends A1 {
    age: number
}

type A = A2 extends A1 ? true : false
// 无报错说明x类型是true，也就是A1 extends A2成立
const x: A = true
```

### 定义类型时使用[P in K]这种方式
**用于遍历联合类型，作为当前类型的键值**
```ts
type Union = 'name' | 'age' | 'sex'

type X = {
    [K in Union]: string | number
}

const c: X = {
    name: 'Aran',
    age: 12,
    sex: '男'
}
```

### readonly只读修饰符
**实现一个类型，接收一个泛型，返回的该类型就是传入的该泛型的只读模式**
```ts
type MReadonly<T> = {
    readonly [k in keyof T]: T[k]
}
```

### typeof 关键字
**指的是构造出与typeof后边类型一致的类型**
```ts
const cd = {
    x: 1,
    y: 2
}
type P = typeof cd
const po: P = {
    x: 1,
    y: 3
}
```

### Ts断言与类型守卫
**所谓断言就是断定、确定、绝对的意思；所以简单来讲，类型断言就是保证数据类型一定是所要求的类型**
**类型推断：**
1. TypeScript里，在有些没有明确指出类型的地方，类型推论会帮助提供类型
2. 如果定义的时候没有赋值，不管之后有没有赋值，都会被推断成 any 类型而完全不被类型检查
**类型断言：**
1. 类型断言可以将一个联合类型的变量，指定为一个更加具体的类型
2. 不能将联合类型断言为不存在的类型
3. 非空断言!代表对象是非 null 非 undefined
类型守卫函数
```ts
function isUser(arg: any): arg is User {
    if (!arg) {
        return false;
    }
    else {
        if (typeof arg.name == 'string' && typeof arg.age == 'number') {
            return true;
        } else {
            return false;
        }
    }
}
```
经过这样的类型断言后就不会报错了
```ts
if (isUser(errorType)) {
    showUser(errorType);
}
```

### unknow、void、never 类型
**与any类型区别是：当 unknown 类型被确定是某个类型之前,它不能被进行任何操作**
**void代表值为空，因为只能为它赋值null 和 undefined**
**拥有 never 返回值类型的函数无法正常返回，无法终止或会抛出异常**