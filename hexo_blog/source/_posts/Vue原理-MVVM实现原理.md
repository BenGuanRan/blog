---
title: Vue原理-MVVM原理
date: 2022-11-28
tags:
- Vue
---

## 概览
[![zUHbon.png](https://s1.ax1x.com/2022/11/28/zUHbon.png)](https://imgse.com/i/zUHbon)

Vue是采用数据劫持监听变化，配合发布订阅设计模式来通知观察者更新视图。

**Observer**通过Object.defineProperty()来劫持各个属性的setter和getter，在数据变动时，发布消息给以来收集器(**Dep**)，用以来收集器告知观察者(**Watcher**)，调用更新器(**Updater**)来更新视图，**Compile**也会利用Watcher订阅数据变化，绑定更新函数。

MVVM作为绑定的入口，整合Observer、Compile、Watcher三者，通过Observer劫持各个属性，从而监听各个属性的变化，通过Compile来编译模板指令，最终通过Watcher来搭起Observer与Compile之间的桥梁，从而实现数据变化 -> 视图更新的效果。

## 关键类功能介绍
### Compile类
负责编译el指向的代码片段上的指令、插值表达式。

拥有CompileUtil工具类，负责对每个以v-开头的指令进行处理，例如：v-on绑定函数、v-html渲染html等。

## Updater
负责初始化视图、更新视图。例如当Compile解析到v-html或插值表达式时，就需要使用Uprater来更新视图。

## Observer类
负责劫持vm实例上data上属性，从而感知data上属性的操作。

## Dep
订阅器，负责存储所有观察者，以用来后续数据更新时告知观察者。

## Watcher类
每个Watcher上可以绑定响应回调函数，一般是视图更新函数，当Observer监听到变化后，会告知Dep，Dep从而通知相应Watcher去更新视图。