---
title: ThreeJs模型对象
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

[![pScmK29.png](https://s1.ax1x.com/2023/02/06/pScmK29.png)](https://imgse.com/i/pScmK29)
## 点模型Points
THREE.Points渲染点模型
默认是一些正方形的点
- Points
## 线模型Line
实现一些实线虚线效果
- Line线
- LineLoop闭环线
- LineSegments间断线
## 网格模型Mesh
由一个个三角面构成的
- Mesh
## 模型基类Object3D
上述的Points、Line、Mesh都继承自Object3D
## Clone与Copy
Clone是克隆出一个一摸一样的模型
```js
var mesh=new THREE.Mesh(box,material);//网格模型对象
var mesh2 = mesh.clone();//克隆网格模型
```
Copy往往是将某个几何模型的某些属性赋值给另一个几何模型
```js
var p1 = new THREE.Vector3(1.2,2.6,3.2);
var p2 = new THREE.Vector3(0.0,0.0,0.0);
p2.copy(p1)
// p2向量的xyz变为p1的xyz值
console.log(p2);
```