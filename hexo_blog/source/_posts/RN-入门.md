---
title: React Native-入门
date: 2023-03-12
tags:
- React Native
---

## Why RN 可以跨平台？How To Work？
通过使用js来访问移动平台的API，以及使用React组件来描述UI的外观和行为。
在Android/IOS开发中，视图是UI的最基本组成部分，在web中与之对应的是组件。在运行时，RN会为所有组件创建视图。可以理解为一个翻译的过程。
其中用户编写的RN组件被称为原生组件，核心组件是一种特殊的原生组件，是一种无需编写，RN内置的随时可用的组件。

## 核心组件
| REACT NATIVE UI COMPONENT | ANDROID VIEW | IOS VIEW     | WEB ANALOG           | 说明                                                                                                  |
| ------------------------- | ------------ | ------------ | -------------------- | ----------------------------------------------------------------------------------------------------- |
| View                      | ViewGroup    | UIView       | A non-scrollling div | A container that supports layout with flexbox, style, some touch handling, and accessibility controls |
| Text                      | TextView     | UITextView   | p                    | Displays, styles, and nests strings of text and even handles touch events                             |
| Image                     | ImageView    | UIImageView  | img                  | Displays different types of images                                                                    |
| ScrollView                | ScrollView   | UIScrollView | div                  | A generic scrolling container that can contain multiple components and views                          |
| TextInput                 | EditText     | UITextField  | input type="text"    | Allows the user to enter text                                                                         |

**一个核心组件使用栗子：**
```tsx
import React from 'react';
import { View, Text, Image, ScrollView, TextInput } from 'react-native';

const App = () => {
  return (
    <ScrollView>
      <Text>Some text</Text>
      <View>
        <Text>Some more text</Text>
        <Image
          source={{
            uri: 'https://reactnative.dev/docs/assets/p_cat2.png',
          }}
          style={{ width: 200, height: 200 }}
        />
      </View>
      <TextInput
        style={{
          height: 40,
          borderColor: 'gray',
          borderWidth: 1
        }}
        defaultValue="You can type in me"
      />
    </ScrollView>
  );
}

export default App;
```

### TextInput
TextInput是一个允许用户输入文本的基础组件。它有一个名为onChangeText的属性，此属性接受一个函数，而此函数会在文本变化时被调用。另外还有一个名为onSubmitEditing的属性，会在文本被提交后（用户按下软键盘上的提交键）调用。

### ScrollView
ScrollView是一个通用的可滚动的容器，你可以在其中放入多个组件和视图，而且这些组件并不需要是同类型的。ScrollView 不仅可以垂直滚动，还能水平滚动（通过horizontal属性来设置）。
使用pagingEnabled属性来允许使用滑动手势对视图进行分页，在 Android 上也可以利用ViewPager组件水平滑动视图。
**ScrollView适合用来显示数量不多的滚动元素**。**放置在ScrollView中的所有组件都会被渲染，哪怕有些组件因为内容太长被挤出了屏幕外**。如果你需要显示较长的滚动列表，那么应该使用功能差不多但性能更好的**FlatList组件**。

### 长列表（FlatList/SectionList）
**FlatList**
FlatList组件用于显示一个垂直的滚动列表，其中的元素之间结构近似而仅数据不同。
FlatList更适于长列表数据，且元素个数可以增删。和ScrollView不同的是，FlatList并不立即渲染所有元素，而是优先渲染屏幕上可见的元素。
FlatList组件必须的两个属性是**data**和**renderItem**。data是列表的数据源，而renderItem则从数据源中逐个解析数据，然后返回一个设定好格式的组件来渲染。
**SectionList**
- sections 设置title和data
- renderItem
- renderSectionHeader
- keyExtractor


## 特定平台代码（Platform 模块）
### Platform.OS
在IOS返回ios，Android返回android
### Platform.select
```js
Platform.select({
    ios: {
      backgroundColor: 'red',
    },
    android: {
      backgroundColor: 'blue',
    },
}),
```
### Platform.Version
检测设备版本
### 特定平台后缀
```
BigButton.ios.js
BigButton.android.js
```
可以去掉平台后缀直接引用
```js
import BigButton from './BigButton';
```
如果你还希望在 web 端复用 React Native 的代码，那么还可以使用.native.js的后缀。此时 iOS 和 Android 会使用BigButton.native.js文件，而 web 端会使用BigButton.js。
```
Container.js # 由 Webpack, Rollup 或者其他打包工具打包的文件
Container.native.js # 由 React Native 自带打包工具(Metro) 为ios和android 打包的文件
```
在引用时并不需要添加.native.后缀:
```js
import Container from './Container';
```