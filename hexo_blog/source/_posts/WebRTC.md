---
title: WebRTC初体验
date: 2022-11-12 00:03:54
tags:
- WebRTC
---

## 定义

一项实时通讯技术，允许互联网应用或站点，在不借助中间媒体的情况下，建立浏览器点对点之间的连接，实现视频流，音频流等其他任意数据的传输。用户在无需安装任何插件或第三方软件的情况下，创建点对点的**数据分享**和**电话会议**成为可能。

## 底层协议与连接原理

基于**ICE（交互式连接建立）协议**，穿透防火墙，从而实现端到端建立连接。

### 媒体协商(SDP)

由于不同浏览器媒体编解码能力不同，因此需要协商出共有的编解码方案。

### 网络协商(CANDIDATE)

理想情况下，每个浏览器都有一个自己的公网IP但实际上需要NAT技术动态分配IP

**STUN（NAT会话穿越程序）**允许位于NAT后的客户端找到自己的公网地址。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/84abfcee-f515-4664-9f87-3a8ba7fa6e37/Untitled.png)

**TURN** 当STUN会话穿越失败时，TURN会请求公网IP地址作为中继服务器进行分配。

**ICE整合了STUN与TURN**

### 信令服务器

两个设备建立WebRTC连接需要一个信令服务器来实现双方通过网络进行连接。其作用是帮助连接双方在尽可能少暴露隐私的情况下建立连接。

内容对信令服务器而言一点也不重要，其只负责传递这些内容。

## 基本使用

### 打开摄像头

**navigator.mediaDevices.getUserMedia(**`constraints`**)**

返回一个promise，其中constraints传参如下：

```jsx
{ audio: true, video: true } // 音视频
{
  audio: true,
  video: { width: 1280, height: 720 } // 设置分辨率
}
。。。
```

```jsx
navigator.mediaDevices.getUserMedia(constraints).then(stream => {
    document.querySelector('#local-video').srcObject = stream
}).catch(err => {
    alert(err)
})
```

### 拍照

原理实现就是通过canvas  **drawImage**方法，将当前视频画面绘制入canvas页面，通过**toDataURL**方法，将画面转化为base64格式，放入Image src中。

```jsx
function takePhoto(vdo, pto) {
    const canvas = document.createElement('canvas')
    canvas.width = vdo.videoWidth
    canvas.height = vdo.videoHeight
    const ctx = canvas.getContext('2d')
    ctx.drawImage(vdo, 0, 0, canvas.width, canvas.height)
    pto.src = canvas.toDataURL('image/png')
}
```

### 切换摄像头

思路是通过**navigator.mediaDevices.enumerateDevices()**方法，获取所用设备，再进行筛选，通过设备ID引用设备。

```jsx
// 获取所有视频输入设备
async function getDevices() {
  const devices = await navigator.mediaDevices.enumerateDevices()
  console.log('🚀🚀🚀 / devices', devices)
  let videoDevices = devices.filter((device) => device.kind === 'videoinput')
}
// 切换设备
function handleDeviceChange(deviceId: string) {
  getLocalStream()
  const stream = await navigator.mediaDevices.getUserMedia({
    audio: false,
    video: {
      deviceId: { exact: deviceId },
    },
  })
}
```

### 共享屏幕

思路是通过**navigator.mediaDrvices.getDisplayMedia()**方法，获取屏幕视频流，再通过video的**srcObject**属性展示。

```jsx
async function shareScreen(vdo) {
    try {
        const localStream = await navigator.mediaDevices.getDisplayMedia({
            audio: true,
            video: {
                width: 350
            },
        })
        vdo.srcObject = localStream
    } catch (error) {
        alert(error)
    }
}
```

### 录制媒体流

先查看浏览器支持的编码格式，通过**navigator.mediaDevices.MediaRecorder.isTypeSupported()**方法，再通过**mediaRecorder = new MediaRecorder(localStream, options)**进行录制。

```jsx
// 获取浏览器支持的媒体类型
    function getSupportedMimeTypes() {
        const media = 'video'
        // 常用的视频格式
        const types = [
            'webm',
            'mp4',
            'ogg',
            'mov',
            'avi',
            'wmv',
            'flv',
            'mkv',
            'ts',
            'x-matroska',
        ]
        // 常用的视频编码
        const codecs = ['vp9', 'vp9.0', 'vp8', 'vp8.0', 'avc1', 'av1', 'h265', 'h264']
        // 支持的媒体类型
        const supported = []
        const isSupported = MediaRecorder.isTypeSupported
        // 遍历判断所有的媒体类型
        types.forEach((type) => {
            const mimeType = `${media}/${type}`
            codecs.forEach((codec) =>
                [
                    `${mimeType};codecs=${codec}`,
                    `${mimeType};codecs=${codec.toUpperCase()}`,
                ].forEach((variation) => {
                    if (isSupported(variation)) supported.push(variation)
                }),
            )
            if (isSupported(mimeType)) supported.push(mimeType)
        })
        return supported
    }
    // 开始录制
    function recordingScreen(localStream) {
        blobs = []
        const kbps = 1024
        const Mbps = kbps * kbps
        const options = {
            audioBitsPerSecond: 128000,
            videoBitsPerSecond: 2500000,
            mimeType: 'video/webm; codecs="vp8,opus"',
        }
        mediaRecorder = new MediaRecorder(localStream, options)
        mediaRecorder.start(100)
        mediaRecorder.ondataavailable = (e) => {
            // 将录制的数据合并成一个 Blob 对象
            // const blob = new Blob([e.data], { type: e.data.type })

            // 🌸重点是这个地方，我们不要把获取到的 e.data.type设置成 blob 的 type，而是直接改成 mp4
            blobs.push(e.data)
        }

    }
    // 暂停录制
    function stopRecord() {
        mediaRecorder && mediaRecorder.stop();

    }
    // 回放
    function replay(replayer, blobs) {
        const blob = new Blob(blobs, { type: 'video/mp4' });
        console.log(blobs);
        replayer.src = URL.createObjectURL(blob);
    }
    // 下载
    function downloadVideo() {
        var blob = new Blob(blobs, { type: 'video/mp4' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'record.mp4';
        a.click();
    }
```

### 总体demo代码

```jsx
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <video id="test-video" autoplay playsinline muted> </video>
    <button id="open-btn">打开摄像头</button>
    <button id="close-btn">关闭摄像头</button>
    <button id="takephoto-btn">拍照</button>
    <button id="change-cinema-btn">切换设备</button>
    <button id="share-screen-btn">共享屏幕</button>
    <button id="recording-btn">开始录制</button>
    <button id="stop-recording-btn">停止录制</button>
    <button id="review-recording-btn">回放</button>
    <button id="download-btn">下载录制视频</button>
    <img id="photo" src="" alt="">
    <video id="replay-player" autoplay playsinline muted></video>
</body>
<script>
    const vdo = document.querySelector('#test-video')
    const o_btn = document.querySelector('#open-btn')
    const c_btn = document.querySelector('#close-btn')
    const t_btn = document.querySelector('#takephoto-btn')
    const g_btn = document.querySelector('#change-cinema-btn')
    const s_btn = document.querySelector('#share-screen-btn')
    const r_btn = document.querySelector('#recording-btn')
    const b_btn = document.querySelector('#stop-recording-btn')
    const l_btn = document.querySelector('#review-recording-btn')
    const pto = document.querySelector('#photo')
    const replayer = document.querySelector('#replay-player')
    const d_btn = document.querySelector('#download-btn')
    let blobs = []; // 用于存放录制视频的二进制文件
    let mediaRecorder = null; // 录制对象
    // 获取视频流
    async function getVideoStream(vdo) {
        const content = {
            video: {
                width: 300,
                heigth: 150
            },
            audio: true
        }
        try {
            const videoStream = await navigator.mediaDevices.getUserMedia(content)
            vdo.srcObject = videoStream
        } catch (error) {
            alert(error)
        }

    }
    // 删除视频流
    function removeVideoStream(vdo) {
        vdo.srcObject = null
    }
    // 拍照
    function takePhoto(vdo, pto) {
        const canvas = document.createElement('canvas')
        canvas.width = vdo.videoWidth
        canvas.height = vdo.videoHeight
        const ctx = canvas.getContext('2d')
        ctx.drawImage(vdo, 0, 0, canvas.width, canvas.height)
        pto.src = canvas.toDataURL('image/png')
    }
    // 切换摄像头
    async function changeCinema() {
        try {
            const devices = await navigator.mediaDevices.enumerateDevices()
            const videoDevices = devices.filter((device) => device.kind === 'videoinput')
            console.log(videoDevices);
        } catch (error) {
            alert(error)
        }
    }
    // 共享屏幕
    async function shareScreen(vdo) {
        try {
            const localStream = await navigator.mediaDevices.getDisplayMedia({
                audio: true,
                video: {
                    width: 350
                },
            })
            vdo.srcObject = localStream
        } catch (error) {
            alert(error)
        }
    }
    // 获取浏览器支持的媒体类型
    function getSupportedMimeTypes() {
        const media = 'video'
        // 常用的视频格式
        const types = [
            'webm',
            'mp4',
            'ogg',
            'mov',
            'avi',
            'wmv',
            'flv',
            'mkv',
            'ts',
            'x-matroska',
        ]
        // 常用的视频编码
        const codecs = ['vp9', 'vp9.0', 'vp8', 'vp8.0', 'avc1', 'av1', 'h265', 'h264']
        // 支持的媒体类型
        const supported = []
        const isSupported = MediaRecorder.isTypeSupported
        // 遍历判断所有的媒体类型
        types.forEach((type) => {
            const mimeType = `${media}/${type}`
            codecs.forEach((codec) =>
                [
                    `${mimeType};codecs=${codec}`,
                    `${mimeType};codecs=${codec.toUpperCase()}`,
                ].forEach((variation) => {
                    if (isSupported(variation)) supported.push(variation)
                }),
            )
            if (isSupported(mimeType)) supported.push(mimeType)
        })
        return supported
    }
    // 开始录制
    function recordingScreen(localStream) {
        blobs = []
        const kbps = 1024
        const Mbps = kbps * kbps
        const options = {
            audioBitsPerSecond: 128000,
            videoBitsPerSecond: 2500000,
            mimeType: 'video/webm; codecs="vp8,opus"',
        }
        mediaRecorder = new MediaRecorder(localStream, options)
        mediaRecorder.start(100)
        mediaRecorder.ondataavailable = (e) => {
            // 将录制的数据合并成一个 Blob 对象
            // const blob = new Blob([e.data], { type: e.data.type })

            // 🌸重点是这个地方，我们不要把获取到的 e.data.type设置成 blob 的 type，而是直接改成 mp4
            blobs.push(e.data)
        }

    }
    // 暂停录制
    function stopRecord() {
        mediaRecorder && mediaRecorder.stop();

    }
    // 回放
    function replay(replayer, blobs) {
        const blob = new Blob(blobs, { type: 'video/mp4' });
        console.log(blobs);
        replayer.src = URL.createObjectURL(blob);
    }
    // 下载
    function downloadVideo() {
        var blob = new Blob(blobs, { type: 'video/mp4' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'record.mp4';
        a.click();
    }
    o_btn.onclick = () => {
        return getVideoStream(vdo)
    }
    c_btn.onclick = () => {
        return removeVideoStream(vdo)
    }
    t_btn.onclick = () => {
        return takePhoto(vdo, pto)
    }
    g_btn.onclick = () => {
        return changeCinema()
    }
    s_btn.onclick = () => {
        return shareScreen(vdo)
    }
    r_btn.onclick = () => {
        return recordingScreen(vdo.srcObject)
    }
    b_btn.onclick = () => {
        return stopRecord()
    }
    l_btn.onclick = () => {
        return replay(replayer, blobs)
    }
    d_btn.onclick = () => {
        return downloadVideo(blobs)
    }
</script>

</html>
```

### 搭建信令服务器