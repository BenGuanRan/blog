---
title: React-state与生命周期(4)
date: 2022-11-27
tags:
- React
---

引入react官方网的一个例子：
```jsx
class Clock extends React.Component {
    constructor(props) {
        super(props);
        this.state = { date: new Date() };
    }
    componentDidMount() {
        this.timerID = setInterval(
            () => this.tick(),
            1000
        );
    }
    componentWillUnmount() {
        clearInterval(this.timerID);
    }
    tick() {
        this.setState({
            date: new Date()
        })
    }
    render() {
        return (
            <div>
                <h1>Hello, world!</h1>
                <h2>It is {this.state.date.toLocaleTimeStr
            </div>
        );
    }
}
ReactDOM.render(
    <Clock />,
    document.getElementById('root')
);
```

## 使用State的原则
1. 不要直接修改state，要想监听变化，必须使用setState来修改。
2. state值的更新需要对比变化后再更新，因此是异步更新的，所以不应该依赖他们的值来直接更新下一个状态。因此如果需要当前state值来更新之后的state值，可以采用传入回调函数的形式：
```jsx
this.setState((state, props) => ({
  counter: state.counter + props.increment
}));
```
3. state的更新会被合并，而不是直接覆盖。
