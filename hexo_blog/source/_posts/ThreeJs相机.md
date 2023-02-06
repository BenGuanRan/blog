---
title: ThreeJs相机
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

[![pScax9s.png](https://s1.ax1x.com/2023/02/06/pScax9s.png)](https://imgse.com/i/pScax9s)
## 正交相机（正投影相机）OrthographicCamera
影子相机就是一个正交相机
[![pScdiHU.png](https://s1.ax1x.com/2023/02/06/pScdiHU.png)](https://imgse.com/i/pScdiHU)
参数(属性)	含义
left	渲染空间的左边界
right	渲染空间的右边界
top	渲染空间的上边界
bottom	渲染空间的下边界
near	near属性表示的是从距离相机多远的位置开始渲染，一般情况会设置一个很小的值。 默认值0.1
far	far属性表示的是距离相机多远的位置截止渲染，如果设置的值偏小小，会有部分场景看不到。 默认值1000

## 透视相机PerspectiveCamera
模拟人眼近大远小的特点，符合透视规律
[![pScdQHO.png](https://s1.ax1x.com/2023/02/06/pScdQHO.png)](https://imgse.com/i/pScdQHO)
参数	含义	默认值
fov	fov表示视场，所谓视场就是能够看到的角度范围，人的眼睛大约能够看到180度的视场，视角大小设置要根据具体应用，一般游戏会设置60~90度	45
aspect	aspect表示渲染窗口的长宽比，如果一个网页上只有一个全屏的canvas画布且画布上只有一个窗口，那么aspect的值就是网页窗口客户区的宽高比	window.innerWidth/window.innerHeight
near	near属性表示的是从距离相机多远的位置开始渲染，一般情况会设置一个很小的值。	0.1
far	far属性表示的是距离相机多远的位置截止渲染，如果设置的值偏小，会有部分场景看不到	1000

## 窗口大小变化自适应渲染
```js
// 正交相机
// onresize 事件会在窗口被调整大小时发生
window.onresize=function(){
  // 重置渲染器输出画布canvas尺寸
  renderer.setSize(window.innerWidth,window.innerHeight);
  // 重置相机投影的相关参数
  k = window.innerWidth/window.innerHeight;//窗口宽高比
  camera.left = -s*k;
  camera.right = s*k;
  camera.top = s;
  camera.bottom = -s;
  // 渲染器执行render方法的时候会读取相机对象的投影矩阵属性projectionMatrix
  // 但是不会每渲染一帧，就通过相机的属性计算投影矩阵(节约计算资源)
  // 如果相机的一些属性发生了变化，需要执行updateProjectionMatrix ()方法更新相机的投影矩阵
  camera.updateProjectionMatrix ();
};

// 透视相机
// onresize 事件会在窗口被调整大小时发生
window.onresize=function(){
  // 重置渲染器输出画布canvas尺寸
  renderer.setSize(window.innerWidth,window.innerHeight);
  // 全屏情况下：设置观察范围长宽比aspect为窗口宽高比
  camera.aspect = window.innerWidth/window.innerHeight;
  // 渲染器执行render方法的时候会读取相机对象的投影矩阵属性projectionMatrix
  // 但是不会每渲染一帧，就通过相机的属性计算投影矩阵(节约计算资源)
  // 如果相机的一些属性发生了变化，需要执行updateProjectionMatrix ()方法更新相机的投影矩阵
  camera.updateProjectionMatrix ();
};
```