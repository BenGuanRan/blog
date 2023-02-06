---
title: ThreeJs层级模型
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

## 什么是层级模型
对于前端而言，层级模型并不陌生，例如HTML的DOM树结构，一些MVVM框架的父子组件组成的树结构等等。
Threejs中也有树结构，场景scene为根节点，Group、Object3D、Mesh等组成的树结构。
如下图所示:
[![pSctfts.png](https://s1.ax1x.com/2023/02/06/pSctfts.png)](https://imgse.com/i/pSctfts)

## 层级模型中的增删改查
### 增add
```js
group.add()
```
### 删remove
```js
group.remove(mesh1)
```
### 模型命名.name
```js
mesh1.name = '机器人眼睛'
```
### 查找.getObjectById()、.getObjectByName()
```js
// 遍历查找scene中复合条件的子对象，并返回id对应的对象
var idNode = scene.getObjectById ( 4 );
console.log(idNode);
// 遍历查找对象的子对象，返回name对应的对象（name是可以重名的，返回第一个）
var nameNode = scene.getObjectByName ( "左腿" );
nameNode.material.color.set(0xff0000);
```
### 遍历traverse
```js
scene.traverse(function(obj) {
  if (obj.type === "Group") {
    console.log(obj.name);
  }
  if (obj.type === "Mesh") {
    console.log('  ' + obj.name);
    obj.material.color.set(0xffff00);
  }
  if (obj.name === "左眼" | obj.name === "右眼") {
    obj.material.color.set(0x000000)
  }
  // 打印id属性
  console.log(obj.id);
  // 打印该对象的父对象
  console.log(obj.parent);
  // 打印该对象的子对象
  console.log(obj.children);
})
```
## 本地位置坐标与世界位置坐标
获取本地坐标.position()
获取世界坐标.getWorldPosition()
由于上文所讲的树结构的关系，本地坐标可以理解为：子组件的世界观里只有父组件，其position是基于父组件而言的。而世界坐标是基于全局的坐标系而言的。