---
title: React-Router(8)
date: 2022-12-11
tags:
- React
---

## React-Router
先来一个demo
```jsx
import React from 'react'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom'
import MRouterHome from './MRouterHome'
import MRouterAbout from './MRouterAbout'

export default function MRouter() {
    return (
        // history模式
        <BrowserRouter>
            <Link to="/">首页</Link>
            <Link to="/about">关于</Link>
            <Routes>
                <Route path={"/" | "/home"} element={<MRouterHome></MRouterHome>}></Route>
                <Route path="/about" element={<MRouterAbout></MRouterAbout>}></Route>
            </Routes>
        </BrowserRouter>
    )
}

```
### **HashRouter和BrowerRouter**
也就是Hash模式和History模式
一般一个React应用该标签只引入一次
### **Link**
指定跳转地址
### **Routes**
定义路由出口，满足条件的路由组件会渲染到其内部
### **Route**
完成路由匹配的
### **编程式路由导航**
通过useNavigate钩子函数进行跳转
```jsx
const navigate = useNavigate()
navigate('/login')
```
searchParamps传参
```jsx
// 传参
navigate('/about?id=ae123432sdc4646c')
// 取参
let [paramps] = useSearchParamps()
let id = paramps.get('id')
```
paramps传参
```jsx
// 传参
about/:id
navigate('/about/ae123432sdc4646c')
// 取参
let paramps = useParamps()
let id = paramps.id
```
### 嵌套路由
Route标签里面嵌套Route
Outlet定义二级路由出口

### 路由重定向
使用index代替path

### 404匹配
```jsx
path = "*"
```