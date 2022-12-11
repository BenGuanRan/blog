---
title: Ts类型体操
date: 2022-12-08
tags:
- Ts
- Js
---
## Ts类型体操
**该篇博文主要记录自己刷Ts类型体操的过程。**
[附上刷题链接](https://github.com/type-challenges/type-challenges/blob/main/README.zh-CN.md)

### 实现Pick
实现 TS 内置的 Pick<T, K>，但不可以使用它。从类型 T 中选择出属性 K，构造成一个新的类型。
```ts
type Pick<T, K extends keyof T> = {
    [p in K]:T[p]
}
```

### 实现Readonly
该 Readonly 会接收一个 泛型参数，并返回一个完全一样的类型，只是所有属性都会被 readonly 所修饰。也就是不可以再对该对象的属性赋值。
```ts
type MyReadonly<T> = {
    readonly [k in keyof T]: T[k]
}
```

### 元组转换为对象
传入一个元组类型，将这个元组类型转换为对象类型，这个对象类型的键/值都是从元组中遍历出来。
例如：
```ts
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const
type result = TupleToObject<typeof tuple> // expected { 'tesla': 'tesla', 'model 3': 'model 3', 'model X': 'model X'}
```
```ts
type TupleToObject<T extends readonly any[]> = {
    [i in T[number]]: T[number]
}
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const
type result = TupleToObject<typeof tuple>
const aa: result = {
    'tesla': 'tesla', 'model 3': 'model 3', 'model X': 'model X',
    "model Y": "tesla"
}
```

### 第一个元素
实现一个通用First<T>，它接受一个数组T并返回它的第一个元素的类型。
```ts
type First<T extends any[]> = T['length'] extends 0 ? never : T[0] 
```

### 获取元组长度
创建一个通用的Length，接受一个readonly的数组，返回这个数组的长度。
```ts
type Length<T extends readonly unknown[]> = T['length']
```

### Exclude
从联合类型T中排除U的类型成员，来构造一个新的类型。
例如：
```ts
type Result = MyExclude<'a' | 'b' | 'c', 'a'> // 'b' | 'c'
```
```ts
type MyExclude<T, U extends T> = T extends U ? never : T
```
是不是很反直觉？
对于联合类型使用extends，ts会进行分配类型，也就是将T的每一个累心与extends后边类型进行extends，返回每一个结果的联合类型。

### Awaited
假如我们有一个 Promise 对象，这个 Promise 对象会返回一个类型。在 TS 中，我们用 Promise 中的 T 来描述这个 Promise 返回的类型。请你实现一个类型，可以获取这个类型。
```ts
type ExampleType = Promise<string>
type Result = MyAwaited<ExampleType> // string
```
```ts
type MyAwaited<T extends Promise<any>> = Awaited<T>

```

### If
实现一个 IF 类型，它接收一个条件类型 C ，一个判断为真时的返回类型 T ，以及一个判断为假时的返回类型 F。 C 只能是 true 或者 false， T 和 F 可以是任意类型。
```ts
type If<C extends boolean, T, F> = C extends true ? T : F
```

### Concat
在类型系统里实现 JavaScript 内置的 Array.concat 方法，这个类型接受两个参数，返回的新数组类型应该按照输入参数从左到右的顺序合并为一个新的数组。
```ts
type Concat<T extends any[], U extends any[]> = [...T, ...U]
```

### Includes
在类型系统里实现 JavaScript 的 `Array.includes` 方法，这个类型接受两个参数，返回的类型要么是 `true` 要么是 `false`。
例如：
```ts
type isPillarMen = Includes<['Kars', 'Esidisi', 'Wamuu', 'Santana'], 'Dio'> // expected to be `false`
```
```ts
type Includes<T extends readonly unknown[], U> =
  T extends [infer First, ...infer Rest] 
    ? Equal<First, U> extends true ? true : Includes<Rest, U>
    : false
```

### Push
在类型系统里实现通用的 ```Array.push``` 。
```ts
type Push<T extends any[],  U extends any[]|any> = [...T,U]
```