---
title: React-引入(1)
date: 2022-11-26
tags:
- React
---

## 步骤 1：添加一个DOM容器到HTML
```html
<div id="react-container"></div>
```

## 步骤 2：添加 Script 标签
```html
 <!-- ... 其它 HTML ... -->

  <!-- 加载 React。-->
  <!-- 注意: 部署时，将 "development.js" 替换为 "production.min.js"。-->
  <script src="https://unpkg.com/react@16/umd/react.development.js" crossorigin></script>
  <script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js" crossorigin></script>

  <!-- 加载我们的 React 组件。-->
  <script src="like_button.js"></script>

</body>
```

## 步骤 3：创建一个 React 组件
```js
'use strict';

const e = React.createElement;

class LikeButton extends React.Component {
    constructor(props) {
        super(props);
        this.state = { liked: false };
    }

    render() {
        if (this.state.liked) {
            return 'You liked this.';
        }

        return e(
            'button',
            { onClick: () => this.setState({ liked: true }) },
            'Like'
        );
    }
}

const domContainer = document.querySelector('#react-container');
ReactDOM.render(e(LikeButton), domContainer);
```

## 步骤 4：代替原生，使用jsx
```html
<!-- 1. CDN引入babel -->
<script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
<!-- 2. 修改标签如下 -->
<script type="text/babel" src="like_button.js"></script>
```

```js
// 3. 修改render函数返回值如下
render() {
        if (this.state.liked) { 
            return 'You liked this.';
        }

        return (
            <button onClick={() => this.setState({ liked: true })}>
                Like
            </button>
        )
    }
```
4. 开启服务器模式运行html代码。