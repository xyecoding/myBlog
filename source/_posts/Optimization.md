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
