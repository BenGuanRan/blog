---
title: ThreeJs光与影
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

## 常见的光的种类
[![pScJxa9.png](https://s1.ax1x.com/2023/02/06/pScJxa9.png)](https://imgse.com/i/pScJxa9)
### 环境光AmbientLight
环境光是没有特定方向的光源，主要是均匀整体改变物体表面的敏感效果。
环境光的颜色与物体的颜色rgb分别相乘，形成了我们看到的颜色
### 点光源PointLight
可以理解为生活中的白炽灯，position可以设置光源的位置
### 平行光DirectionalLight
可以模拟太阳光，**position只是确定平行光的照射方向的**
### 聚光灯SpotLight
就是类似手电筒的效果，舞台聚光灯
## 设置影子
想要物体产生影子，需要进行四个步骤
1. 渲染器开启影子渲染
    ```js
    renderer.shadowMap.enabled = true
    ```
2. 被投影物体设置可接收影子
   ```js
   plane.receiveShadow = true
   ```
3. 物体设置可产生影子
   ```js
   ball.castShadow = true
   ```
4. 光源可产生影子
   ```js
   light.castShadow = true
   ```
若上述步骤依然未产生影子，可能是正交影子相机的问题！
设置正交影子相机
```js
directionalLight.shadow.camera.near = 10
directionalLight.shadow.camera.far = 400
directionalLight.shadow.camera.left = -100; //产生阴影距离位置的最左边位置
directionalLight.shadow.camera.right = 100; //最右边
directionalLight.shadow.camera.top = 400; //最上边
directionalLight.shadow.camera.bottom = -400; //最下面
//这两个值决定使用多少像素生成阴影 默认512
directionalLight.shadow.mapSize.height = 1024;
directionalLight.shadow.mapSize.width = 1024;
```
