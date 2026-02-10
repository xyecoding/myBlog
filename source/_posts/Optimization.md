---
title: Optimization
top: false
cover: false
toc: true
mathjax: true
description: Optimization
categories:
  - Machine Learning
  - Methods
  - Optimization
tags:
  - Optimization
abbrlink: 6e9b1d38
date: 2022-01-10 14:34:19
password:
summary:
---

# 梯度优化中的吸引子：从数学基础到控制视角

## 1. 引言：为什么需要理解吸引子

在机器学习和优化领域，我们每天都在使用梯度下降及其变体。但你是否思考过：

> 为什么梯度下降会收敛到某个点？它一定会收敛吗？什么决定了它收敛到哪里？

理解**吸引子（Attractor）**的概念，能帮助我们回答这些问题。吸引子是动力系统中的一种基本现象，描述系统状态随时间演化最终趋向的特定区域或点。

在优化中，吸引子对应着**局部最小值**（或某些情况下的鞍点）。掌握吸引子的数学条件，不仅能帮助我们设计更好的优化算法，还能理解为何某些训练过程会失败（如陷入局部最优、发散或震荡）。

## 2. 动力系统基础：什么是吸引子

### 2.1 动力系统的定义

一个**连续时间动力系统**由微分方程描述：

$$\dot{x} = f(x), \quad x \in \mathbb{R}^n$$

其中 $f: \mathbb{R}^n \to \mathbb{R}^n$ 是向量场，$\dot{x} = \frac{dx}{dt}$ 表示状态随时间的变化率。

### 2.2 平衡点（Equilibrium Point）

**定义**：点 $x^* \in \mathbb{R}^n$ 称为平衡点，如果：
$$f(x^*) = 0$$

直观理解：系统到达 $x^*$ 后不再演化，"停"在那里。

### 2.3 吸引子的严格定义

**定义（吸引子）**：集合 $\mathcal{A} \subset \mathbb{R}^n$ 称为吸引子，如果满足：

1. **不变性**：从 $\mathcal{A}$ 内出发的轨迹永远留在 $\mathcal{A}$ 内
2. **吸引性**：存在 $\mathcal{A}$ 的邻域 $\mathcal{U}$，使得对所有 $x_0 \in \mathcal{U}$：
   $$\lim_{t \to \infty} \phi(t, x_0) \in \mathcal{A}$$

   其中 $\phi(t, x_0)$ 表示从 $x_0$ 出发、时刻 $t$ 的状态

3. **极小性**：$\mathcal{A}$ 没有真子集也满足上述条件

**吸引域（Basin of Attraction）**：所有最终收敛到 $\mathcal{A}$ 的初始点集合：
$$\mathcal{B}(\mathcal{A}) = \{x_0 \in \mathbb{R}^n : \lim_{t \to \infty} \phi(t, x_0) \in \mathcal{A}\}$$

## 3. 梯度下降的动力学

### 3.1 从优化到动力学

给定目标函数 $f: \mathbb{R}^n \to \mathbb{R}$，**梯度下降**的连续形式为：

$$\dot{x} = -\nabla f(x)$$

这是一个特殊的动力系统，其中向量场 $f(x) = -\nabla f(x)$ 是某个标量函数的负梯度。

**关键性质**：这种系统称为**梯度流（Gradient Flow）**，具有特殊的动力学行为。

### 3.2 能量递减性质

定义"能量" $V(x) = f(x)$，则：
$$\frac{d}{dt}f(x(t)) = \nabla f \cdot \dot{x} = \nabla f \cdot (-\nabla f) = -\|\nabla f\|^2 \leq 0$$

**结论**：$f(x(t))$ 随时间单调递减（除非到达平衡点）。

这使得梯度下降成为**耗散系统**，能量不断耗散直至到达局部最小值。

## 4. 吸引子的严格数学条件

现在回答核心问题：**什么条件下点 $a$ 是梯度下降的吸引子？**

### 4.1 必要条件：平衡点

**定理**：$a$ 是梯度下降的吸引子 $\Rightarrow$ $\nabla f(a) = 0$

**证明**：若 $\nabla f(a) \neq 0$，则 $\dot{x}\big|_{x=a} = -\nabla f(a) \neq 0$，系统不会在 $a$ 处停留，$a$ 不是平衡点，更不可能是吸引子。

满足 $\nabla f(a) = 0$ 的点称为**临界点（Critical Point）**，包括：

- 局部最小值
- 局部最大值
- 鞍点

### 4.2 充分条件：局部严格凸性

**定理**：若 $\nabla f(a) = 0$ 且 Hessian 矩阵 $H(a) = \nabla^2 f(a)$ **正定**，则 $a$ 是局部渐近稳定的吸引子。

**证明**（Lyapunov方法）：

取 $V(x) = f(x) - f(a)$ 作为Lyapunov函数：

1. **正定性**：由于 $H(a) \succ 0$，$a$ 是严格局部极小值，存在邻域使 $V(x) > 0$ for $x \neq a$，且 $V(a) = 0$

2. **负定导数**：$\dot{V} = -\|\nabla f\|^2 < 0$ for $x \neq a$

根据Lyapunov稳定性定理，$a$ 是渐近稳定的。

### 4.3 一维情况的简洁表达

对于 $f: \mathbb{R} \to \mathbb{R}$：

| 条件     | 数学表达                    | 结论         |
| :------- | :-------------------------- | :----------- |
| 平衡点   | $f'(a) = 0$                 | 必要         |
| 吸引子   | $f'(a) = 0$ 且 $f''(a) > 0$ | 充分         |
| 排斥子   | $f'(a) = 0$ 且 $f''(a) < 0$ | 不稳定       |
| 退化情况 | $f'(a) = 0$ 且 $f''(a) = 0$ | 需更高阶分析 |

**示例**：

- $f(x) = x^2$：$x=0$ 处 $f'=0, f''=2>0$ → 吸引子 ✓
- $f(x) = -x^2$：$x=0$ 处 $f'=0, f''=-2<0$ → 排斥子 ✗
- $f(x) = x^3$：$x=0$ 处 $f'=0, f''=0, f'''=6\neq 0$ → 半稳定（一侧吸引一侧排斥）

## 5. 高维空间与Hessian几何

### 5.1 Hessian矩阵的特征值分解

在临界点 $a$ 处，Hessian $H(a)$ 是实对称矩阵，可对角化：

$$H = Q \Lambda Q^T, \quad \Lambda = \text{diag}(\lambda_1, \lambda_2, ..., \lambda_n)$$

其中 $\lambda_i$ 为特征值，$Q$ 的列为正交特征向量。

### 5.2 临界点的分类

| Hessian特征值      | 几何形状       | 稳定性                     |
| :----------------- | :------------- | :------------------------- |
| 全 $\lambda_i > 0$ | 局部凸（碗状） | **局部最小值（吸引子）** ✓ |
| 全 $\lambda_i < 0$ | 局部凹（倒碗） | 局部最大值（排斥子）✗      |
| 有正有负           | 鞍形（马鞍）   | 不稳定（鞍点）✗            |
| 有零特征值         | 退化/平坦方向  | 需进一步分析               |

### 5.3 梯度下降的局部线性化

在 $a$ 附近令 $x = a + \delta$，线性化：
$$\dot{\delta} = -\nabla f(a+\delta) \approx -H(a)\delta$$

解为 $\delta(t) = e^{-Ht}\delta(0) = Q e^{-\Lambda t} Q^T \delta(0)$

**收敛速率**：由最小特征值 $\lambda_{\min}$ 决定，时间常数 $\tau \sim 1/\lambda_{\min}$

**条件数问题**：若 $\lambda_{\max} \gg \lambda_{\min}$，收敛慢（病态条件）。

## 6. 吸引域与全局收敛

### 6.1 吸引域的复杂性

即使 $a$ 是吸引子，也只有从**吸引域** $\mathcal{B}(a)$ 内出发才能收敛到 $a$。

**示例**：$f(x) = x^4 - 2x^2$

- 临界点：$f'(x) = 4x^3 - 4x = 0 \Rightarrow x = -1, 0, 1$
- $f''(-1) = 8 > 0$，$f''(1) = 8 > 0$ → 两个局部最小（吸引子）
- $f''(0) = -4 < 0$ → 局部最大（排斥子）

吸引域：

- $\mathcal{B}(-1) = (-\infty, 0)$
- $\mathcal{B}(1) = (0, +\infty)$
- $x=0$ 是分界线（稳定流形）

### 6.2 全局收敛的条件

**严格凸函数**：若 $f$ 全局严格凸（$H(x) \succ 0$ for all $x$），则：

- 存在唯一临界点（全局最小值）
- 吸引域为整个空间 $\mathbb{R}^n$
- 梯度下降从任意初值收敛

**非凸优化**：深度学习中的损失函数通常非凸，存在：

- 多个局部最小值（多个吸引子）
- 鞍点（数量通常远多于局部最小值）
- 平坦区域（近似退化）

## 7. 控制视角：PID如何塑造吸引子

### 7.1 带PID的梯度下降

将PID控制引入优化，系统变为：

$$\dot{x} = -K_p \nabla f(x) - K_i \int_0^t \nabla f(x(\tau)) d\tau - K_d \frac{d}{dt}\nabla f(x)$$

或离散形式：
$$x_{k+1} = x_k - \eta_p \nabla f_k - \eta_i \sum_{j=0}^k \nabla f_j - \eta_d (\nabla f_k - \nabla f_{k-1})$$

### 7.2 各分量的作用

| 分量          | 优化对应      | 对吸引子的影响                         |
| :------------ | :------------ | :------------------------------------- |
| **比例（P）** | 标准梯度      | 决定吸引子位置（仍需 $\nabla f = 0$）  |
| **积分（I）** | 动量/自适应   | 消除稳态误差，对抗噪声，可能改变吸引域 |
| **微分（D）** | 二阶信息/阻尼 | 抑制振荡，改善收敛速度，影响稳定性边界 |

### 7.3 PID对稳定性的扩展

**纯梯度下降的局限**：

- 学习率需满足 $\eta < 2/\lambda_{\max}$ 以保证稳定
- 在病态条件下收敛极慢

**PID的优势**：

- 积分项可"记忆"历史梯度，帮助穿越平坦区域
- 微分项提供"预测"，减少在吸引子附近的震荡
- 适当整定可扩大稳定区域，甚至稳定原本不稳定的点（需谨慎）

**注意**：PID引入后，平衡点仍需 $\nabla f = 0$，但稳定性条件变为特征值分析闭环系统，参数选择不当可能导致失稳或极限环。

## 8. 实际案例与可视化

### 8.1 示例：Rosenbrock函数

$$f(x,y) = (a-x)^2 + b(y-x^2)^2$$

- 全局最小值在 $(a, a^2)$，位于狭长平坦山谷底部
- 条件数极差，标准梯度下降收敛极慢
- 带 momentum（类I项）或自适应学习率的方法显著改善

### 8.2 深度学习中的吸引子现象

**损失景观（Loss Landscape）**研究揭示：

- 局部最小值通常具有相近的损失值（并非坏事）
- 鞍点更成问题：梯度下降会缓慢穿越
- 大批量训练倾向于收敛到"尖锐"最小值（吸引域小，泛化差），小批量到"平坦"最小值（吸引域大，泛化好）

## 9. 总结与延伸阅读

### 核心要点

1. **吸引子三要素**：平衡点（一阶为零）+ 局部凸性（二阶正定）+ 吸引域内初值

2. **几何直觉**：梯度下降沿最陡下降方向"滑向"能量碗底，碗的曲率决定滑动速度

3. **高维复杂性**：鞍点和退化方向使分析复杂，但Hessian特征值提供局部完整信息

4. **控制增强**：PID类方法通过引入记忆和阻尼，可塑造更有效的吸引动力学

### 延伸阅读

- **经典教材**：Khalil《Nonlinear Systems》（Lyapunov稳定性）
- **优化视角**：Nesterov《Introductory Lectures on Convex Optimization》
- **深度学习**：Goodfellow et al. 《Deep Learning》第8章（优化）
- **前沿研究**：Loss Landscape papers（如 Li et al., "Visualizing the Loss Landscape of Neural Nets", NIPS 2018）

# Gumbel function

## The probability density function（概率密度函数）

The probability density function (PDF) of gumbel distribution is,

$$f(x,\mu, \beta) = e^{-z-e^{-z}}, z = \frac{x - \mu}{\beta},$$

where $\mu$ is the position index and the mode （众数）and $\beta$ is the scale
index. The variance of gumbel distribution is $\frac{\pi^2}{6}{\beta}^2$.

## The Cumulative density function （累计密度函数）

The cumulative density function (CDF) of gumbel distribution is,

$$F(x, \mu, \beta) = e^{-e^{-(x-\mu)/\beta}}$$

CDF's inverse function is,

$$F^{-1}(y, \mu, \beta) = \mu - \beta \ln(-\ln(y))$$

# KL (Kullback-Leibler) Divergence

## Some Concepts

### Self-Information

It can be thought of as an alternative way of expressing probability, much like
odds or log-odds, but which has particular mathematical advantages in setting of
information theory. It can be interpreted as quantifying the level of 'surprise'
of a particular outcome. As it is such a basic quantify, it also appears in
several other settings, such as the length of a message needed to transmit the
event given an optimal source coding of random variable.

#### Two Axiom

1. A thing which more likely to happen contains less information. The thing
   definitely happen contains no information.
2. Two things happen independently contains the information which is the sum of
   their information.

Thus the Self-Information is defined as

$$I(x) = - \log P(x) = \log \frac 1{P(x)}$$

## Entropy

The Expectation of Self-Information

$$H(P) = \sum_x P(x) \log(\frac 1{P(x)})$$

## Cross-Entropy

$$H_P(Q) = \sum_x Q(x) \log(\frac 1{P(x)})$$

## KL Divergence

$$
\begin{aligned}
D_P(Q) &=  KL(Q||P)\\
&= H_P(Q) - H(Q) \\
&= \sum_x Q(x) \log(\frac 1{P(x)}) - \sum_x Q(x) \log(\frac 1{Q(x)}) \\
&= \sum_x Q(x) \log(\frac {Q(x)}{P(x)})
\end{aligned}
$$

If Q is known and P is learn-able, $argmin(D_P(Q)) = argmin(H_P(Q))$.

For more read the book _Deep Learning_ page 47.

# Balance Multitask Training

## 论文中有的方法

Task Learning Using Uncertainty to Weigh Losses for Scene Geometry and Semantics

Multi-Task Learning as Multi-Objective Optimization

Multi-Task Learning Using Uncertainty to Weigh Losses for Scene Geometry and
Semantics

Bounding Box Regression with Uncertainty for Accurate Object Detection

这些论文主要是一种不确定性的方法，从预测不确定性的角度引入 Bayesian 框架，根据各
个 loss 分量当前的大小自动设定其权重。

## 利用 Focal loss

Dynamic Task Prioritization for Multitask Learning

这里主要想讲的是利用 focal loss 的方法，比较简单。

每个 task 都有一个 loss 函数和 KPI (key performance indicator)。KPI 其实就是任务
的准确率，kpi 越高说明这个任务完成得越好。

对于每个进来的 batch，每个$Task_i$ 有个 $loss_i$。每个 Task i 还有个不同的
$KPI: k_i$。那根据 Focal loss 的定义
，$FL(k_i, \gamma_i) = -(1 - k_i)^{\gamma_i} * \log(k_i)$。一般来说我们 $\gamma$
取 2。

最后 $loss = \sum(FL(k_i, \gamma_i) * loss_i)$，loss 前面乘以得这个系数 FL，就是
一个自适应的权重，当任务完成得很好的时候，权重就比较小，不怎么优化这个 loss 了，
当任务完成得不好的时候，权重就会比较大。
