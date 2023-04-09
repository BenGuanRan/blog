---
title: CSS
date: 2022-11-12 00:03:54
tags:
- CSS


---

## BFC

当一个元素拥有了BFC属性，这个元素就可以看成一个隔离了的容器。容器里面的元素不会影响到外边的元素。

触发BFC的条件:

- html根元素
- 浮动元素
- 绝对定位元素
- 大多数的display
- overflow值不为visible块元素
- contain值为layout、content、paint的元素（可以将页面小饰件和整个页面隔离开）
- 多列容器

用处：

- 清除浮动
- 解决外边距合并问题
- 可以阻止元素被浮动元素覆盖

## CSS3动画

```css
<!DOCTYPE html>
<html lang="en">

<body>
    <div class="a"></div>
</body>
<style>
    .a {
        width: 50px;
        height: 50px;
        background: #f40;
        border-radius: 50%;
        /*动画名称*/
        animation-name: mymove;
        /*动画持续时间*/
        animation-duration: 2s;
        /* 动画效果 */
        animation-timing-function: ease-in-out;
        /* 动画延迟时间 */
        animation-delay: 1s;
        /* 动画执行次数 */
        animation-iteration-count: infinite;
        /* 动画播放情况，正向、反向、正反交替等 */
        animation-direction: normal;
        /* 动画状态，暂停还是播放 */
        animation-play-state: running;
    }

    /* 定义动画帧 */
    @keyframes mymove {
        0% {
            width: 50px;
            height: 50px;
        }

        50% {
            width: 100px;
            height: 100px;
        }

        100% {
            width: 50px;
            height: 50px;
        }
    }
</style>

</html>
```

## 常见图片格式以及使用场景

- BMP，是无损的，通常是较大的文件（直接色与索引色）
- GIF，是无损的，文件小，支持动画以及透明。但是gif色彩值不高（索引色）
- JPEG，有损的，色彩更丰富，常常用来存储企业logo（ 直接色）
- PNG-8，无损的，非常好的gif格式替代者，支持透明度的调节（索引色）
- PNG-24，无损，相当于BMP的压缩版，更小，但还是比其他的大（直接色）
- SVG，无损矢量图，放大不会失真
- WebP，同时支持有损和无损，相同质量的图片，webp有更小的体积

## 像素的知识

物理像素：设备实际像素点个数

逻辑像素：css px

n倍图：一个css像素对应n个物理像素

要想不失真，一个图片像素至少对应一个物理像素也就是倍图

## 优化CSS的方式

**加载性能：**

- css压缩
- 尽量减少使用@import
- css单一样式

**选择器性能：**

合理利用选择器

- 减少使用后代选择器，标签选择器
- 尽量使用类选择器
- 避免使用通配符选择器

渲染性能：

- 减少浮动定位
- 减少浏览器重绘回流

可维护性，健壮性

- 样式抽离
- 外部引入