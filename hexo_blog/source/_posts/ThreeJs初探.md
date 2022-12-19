---
title: ThreeJs初探
date: 2022-12-19
tags:
- ThreeJs
- WebGL
---

## ThreeJs官网DEMO总结
```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>My first three.js app</title>
    <style>
        body {
            margin: 0;
        }
    </style>
</head>

<body>
    <script src="js/three.js"></script>
    <script>
        // 创建场景相机渲染器
        const scene = new THREE.Scene()
        // 使用透视相机
        // paramps1事业角度
        // paramps2 长宽比
        // paramps3 4 近截面与远截面 
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        document.body.appendChild(renderer.domElement);
        // 初始步骤搭建完毕，下面创建绘图
        // 创建一个立方体对象
        const geometry = new THREE.BoxGeometry(1, 1, 1);
        // 创建一个材质
        const material = new THREE.MeshBasicMaterial({ color: 0xffffff });
        // 创建一个网格
        // 之所以会有网格这种东西是因为：几何体是不能被渲染的，只有几何体和材质结合成网格才能被渲染到屏幕上
        const cube = new THREE.Mesh(geometry, material);
        scene.add(cube);
        // 由于默认scene.add会将物体放在0，0，0位置，与相机重叠，因此需要移动相机位置
        camera.position.z = 5;
        // 开始真正渲染场景了
        // 创建渲染函数
        function animate() {
            cube.rotation.x += 0.01;
            cube.rotation.y += 0.01;
            // 会在浏览器下次重绘之前执行该回调函数
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        }
        animate();
    </script>
</body>

</html>
```
## 总结
1. ThreeJs三大要素：场景、相机、渲染器
2. ·