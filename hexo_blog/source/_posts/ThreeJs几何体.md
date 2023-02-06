---
title: ThreeJs几何体
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

## BufferGeometry
three中的几何体，例如：长方体BoxGeometry、球体SphereGeometry等几何体都是基于BufferGeometry构建的，BufferGeometry是一个没有任何形状的空几何体，你可以通过BufferGeometry自定义任何几何形状，具体一点说就是定义顶点数据。

## BufferAttribute

### 顶点位置
```js
// 创建一个BUffer类型的几何体对象
const geometry = new THREE.BufferGeometry()
// 类型数组创建顶点数据
var vertices = new Float32Array([
    0, 0, 0, //顶点1坐标
    50, 0, 0, //顶点2坐标
    0, 100, 0, //顶点3坐标
    0, 0, 10, //顶点4坐标
    0, 0, 100, //顶点5坐标
    50, 0, 10, //顶点6坐标
])

// 创建缓冲区对象
var attribute = new THREE.BufferAttribute(vertices, 3) // 三个一组表示顶点的xyz坐标
// 设置几何体attributes属性的位置属性
geometry.attributes.position = attribute;
var material = new THREE.PointsMaterial({
    color: 0x00ff00,
    size: 10.0 //点对象像素尺寸
})
var points = new THREE.Points(geometry, material); //网格模型对象Mesh
scene.add(points)
```
### 顶点颜色
```js
const colors = new Float32Array([
    1, 0, 0, //顶点1颜色
    0, 1, 0, //顶点2颜色
    0, 0, 1, //顶点3颜色
    1, 100, 0, //顶点4颜色
    0, 1, 1, //顶点5颜色
    1, 0, 1, //顶点6颜色
])

geometry.attributes.color = new THREE.BufferAttribute(colors, 3)

// 关于材质的属性.vertexColors可以查看Material文档介绍，
// 属性.vertexColors的默认值是THREE.NoColors，这也就是说模
// 型的颜色渲染效果取决于材质属性.color，如果把材质属性.vertexColors
// 的值设置为THREE.VertexColors,threejs渲染模型的时候就会使用几何体
// 的顶点颜色数据geometry.attributes.color。
// 开启点渲染模式
var material = new THREE.PointsMaterial({
    // color: 0x00ff00,
    vertexColors: true, //以顶点颜色为准
    size: 10.0 //点对象像素尺寸
})
var points = new THREE.Points(geometry, material); //网格模型对象Mesh
scene.add(points)
```
### 顶点索引
网格模型Mesh对应的几何体BufferGeometry，拆分为多个三角后，很多三角形重合的顶点位置坐标是相同的，这时候如果你想减少顶点坐标数据量，可以借助几何体顶点索引geometry.index来实现。
```js
// 没有索引下的顶点位置坐标数据
const vertices = new Float32Array([
    0, 0, 0, //顶点1坐标
    80, 0, 0, //顶点2坐标
    80, 80, 0, //顶点3坐标
    0, 0, 0, //顶点4坐标   和顶点1位置相同
    80, 80, 0, //顶点5坐标  和顶点3位置相同
    0, 80, 0, //顶点6坐标
]);
// 有索引下的顶点坐标数据
const vertices = new Float32Array([
    0, 0, 0, //顶点1坐标
    80, 0, 0, //顶点2坐标
    80, 80, 0, //顶点3坐标
    0, 80, 0, //顶点4坐标
]);
```
索引的写法
```js
// Uint16Array类型数组创建顶点索引数据
const indexes = new Uint16Array([
    // 下面索引值对应顶点位置数据中的顶点坐标
    0, 1, 2, 0, 2, 3,
])
// 索引数据赋值给几何体的index属性
geometry.index = new THREE.BufferAttribute(indexes, 1); //1个为一组
```
### 顶点法线
顶点的法线数据往往描述一个几何体对光照等效果的反应情况。一般不需要程序员自己设置，一般由模型进行导出。

## Curve
Curve并不是几何体，它可以通过给定点绘制一条曲线，然后再通过getPoints(n)将点数据拿到，并通过setFromPoints将点数据赋值给BufferGeometry
### 样条曲线CatmullRomCurve3
样条曲线是穿过所有样例点的
```js
// 三维样条曲线  Catmull-Rom算法
var curve = new THREE.CatmullRomCurve3([
  new THREE.Vector3(-50, 20, 90),
  new THREE.Vector3(-10, 40, 40),
  new THREE.Vector3(0, 0, 0),
  new THREE.Vector3(60, -60, 0),
  new THREE.Vector3(70, 0, 80)
]);
//getPoints是基类Curve的方法，返回一个vector3对象作为元素组成的数组
var points = curve.getPoints(100); //分段数100，返回101个顶点
// setFromPoints方法从points中提取数据改变几何体的顶点属性vertices
geometry.setFromPoints(points);
```
### 贝塞尔曲线CubicBezierCurve3
与样条曲线不同的是，贝塞尔曲线多了一个控制点，控制点不在贝塞尔曲线上。
[![pScU3qO.png](https://s1.ax1x.com/2023/02/06/pScU3qO.png)](https://imgse.com/i/pScU3qO)
```js
// 三维三次贝赛尔曲线
var curve = new THREE.CubicBezierCurve3(p1, p2, p3, p4);
```
### 组合曲线CurvePath
将多个曲线组合，形成一条曲线
```js
// 创建组合曲线对象CurvePath
var CurvePath = new THREE.CurvePath();
// 把多个线条插入到CurvePath中
CurvePath.curves.push(line1, arc, line2);
```

## 一些特殊的几何体
### 曲线管道成型TubeGeometry
形成一条曲线形状的管道
```js
var geometry = new THREE.TubeGeometry(path, 40, 2, 25);
```
参数	值
path	扫描路径，基本类是Curve的路径构造函数
tubularSegments	路径方向细分数，默认64
radius	管道半径，默认1
radiusSegments	管道圆弧细分数，默认8
closed	Boolean值，管道是否闭合

### 旋转成型LatheGeometry
[![pScauTg.png](https://s1.ax1x.com/2023/02/06/pScauTg.png)](https://imgse.com/i/pScauTg)
```js
var geometry = new THREE.LatheGeometry(points,30);
```

### 轮廓填充ShapeGeometry
```js
// 通过顶点定义轮廓
var shape = new THREE.Shape(points);
// shape可以理解为一个需要填充轮廓
// 所谓填充：ShapeGeometry算法利用顶点计算出三角面face3数据填充轮廓
var geometry = new THREE.ShapeGeometry(shape, 25);
```

### 拉伸扫描成型ExtrudeGeometry
[![pScaI1I.png](https://s1.ax1x.com/2023/02/06/pScaI1I.png)](https://imgse.com/i/pScaI1I)

参数	含义
amount	拉伸长度，默认100
bevelEnabled	是否使用倒角	
bevelSegments	倒角细分数，默认3
bevelThickness	倒角尺寸(经向)
curveSegments	拉伸轮廓细分数
steps	拉伸方向细分数
extrudePath	扫描路径THREE.CurvePath，默认Z轴方向
material	前后面材质索引号
extrudeMaterial	拉伸面、倒角面材质索引号
bevelSize	倒角尺寸(拉伸方向)
```js
/**
* 创建扫描网格模型
*/
var shape = new THREE.Shape();
/**四条直线绘制一个矩形轮廓*/
shape.moveTo(0,0);//起点
shape.lineTo(0,10);//第2点
shape.lineTo(10,10);//第3点
shape.lineTo(10,0);//第4点
shape.lineTo(0,0);//第5点
/**创建轮廓的扫描轨迹(3D样条曲线)*/
var curve = new THREE.SplineCurve3([
   new THREE.Vector3( -10, -50, -50 ),
   new THREE.Vector3( 10, 0, 0 ),
   new THREE.Vector3( 8, 50, 50 ),
   new THREE.Vector3( -5, 0, 100)
]);
var geometry = new THREE.ExtrudeGeometry(//拉伸造型
   shape,//二维轮廓
   //拉伸参数
   {
       bevelEnabled:false,//无倒角
       extrudePath:curve,//选择扫描轨迹
       steps:50//扫描方向细分数
   }
);
```