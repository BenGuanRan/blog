---
title: ThreeJs动画系统
date: 2023-02-06
tags:
- ThreeJs
- WebGL
---

## 动画系统四大要素

- **动画片段（AnimationClip）**
    
    是一个由不同的关键帧轨道组成的数组类型
    
    ```jsx
    // 创建位置关键帧对象
    const posTrack = new t.KeyframeTrack('Box.position', times, values)
    // 创建颜色关键帧对象
    const c = box.material.color
    const colTrack = new t.KeyframeTrack('Box.material.color', [10, 20], [c.r, c.g, c.b, 0, 0, 1])
    // 创建缩放关键帧对象
    const scaTrack = new t.KeyframeTrack('Ball.scale', [0, 20], [1, 1, 1, 3, 3, 3])
    // 动画持续事件
    const duraction = 20
    const clip = new t.AnimationClip('change', duraction, [posTrack, colTrack, scaTrack])
    ```
    
- **关键帧轨道（KeyframeTrace）**
    
    描述网格等某一属性随时间变化的状态
    
    ```jsx
    const c = box.material.color
    const colTrack = new t.KeyframeTrack('Box.material.color', [10, 20], [c.r, c.g, c.b, 0, 0, 1])
    ```
    
- **动画混合器（AnimationMixer）**
    
    可以用来获取主角**Animation Actions，从而操作动画，动画的播放必须要调用mixer.update()方法来推进时间**
    
    ```jsx
    mixer.update(clock.getDelta())
    ```
    
- **动画行为（AniamtionAction）**
    
    主要用来控制动画的行为，从而决定动画何时播放，何时快进等等。
    
    ```jsx
    var AnimationAction = mixer.clipAction(clip);
    //通过操作Action设置播放方式
    AnimationAction.timeScale = 20;//默认1，可以调节播放速度
    // AnimationAction.loop = THREE.LoopOnce; //不循环播放
    AnimationAction.play();//开始播放
    ```