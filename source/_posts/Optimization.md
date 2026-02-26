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

# 无信标自适应光学的神经网络桥梁：从多平面图像到实时波前控制

传统方案使用Shack-Hartmann传感器直接测量波前斜率。而在无信标场景下，我们必须从**强度图像**反推**相位信息**。本节解析为什么采用**神经网络摊销**(Amortized Inference)策略——即训练网络 $f_2: \mathbf{x} \rightarrow \mathbf{z}$ 作为中间桥梁，而非直接优化从电压到图像的映射。

## 1. 系统架构：三个关键映射

```
电压空间        波前空间         图像空间（多平面）
   d  ──f₁──→   z   ←──f₂───   [x_in, x_defocus]
   ↑__________________________|
            闭环控制
```

| 映射                           | 方向                                | 物理意义               | 关键特性                             |
| ------------------------------ | ----------------------------------- | ---------------------- | ------------------------------------ |
| $f_1(d) = z$ 传统AO，优化z     | $\mathbf{d} \rightarrow \mathbf{z}$ | 变形镜电压→Zernike系数 | 局部线性，响应矩阵 $\mathbf{J}$ 恒定 |
| $f_2(x)=z$ 波前重构            | $\mathbf{x} \rightarrow \mathbf{z}$ | 多平面图像→波前推理    | 神经网络，摊销相位恢复计算           |
| $f_3(d)=x$ 端到端无信标，优化x | $\mathbf{d} \rightarrow \mathbf{x}$ | 电压→多平面图像        | 包含衍射传播，隐式相位编码           |

**闭环目标**：$f_1(\mathbf{d}) = f_2(\mathbf{x})$，即变形镜产生的波前抵消从图像估计的波前误差。

## 2. 相位恢复：从强度到波前

### 2.1 单帧图像的局限

单帧在焦图像记录强度：
$$I(\mathbf{r}) = |E(\mathbf{r})|^2 = \left|\mathcal{F}^{-1}\{\tilde{E}(\mathbf{k})\}\right|^2$$

强度检测保留**模信息**，但**相位符号**和**相对相位关系**的编码变得隐晦。直接从单帧图像反推波前是**欠定问题**。

### 2.2 多平面成像：引入轴向约束

使用**在焦+离焦图像对**（或更多离焦平面），通过**强度传输方程**（Transport of Intensity Equation, TIE）恢复相位：

$$\frac{\partial I}{\partial z} = -\frac{1}{k}\nabla_\perp \cdot (I \nabla_\perp \phi)$$

| 方法                              | 原理                           | 输入             |
| --------------------------------- | ------------------------------ | ---------------- |
| **TIE**                           | 轴向强度变化率与相位梯度相关   | 多平面强度图像   |
| **相位多样性（Phase Diversity）** | 已知离焦作为先验，联合估计相位 | 在焦+离焦图像对  |
| **全息**                          | 参考光干涉                     | 不适用（无信标） |

**关键洞察**：多帧图像提供了**足够的约束条件**，使相位恢复成为**良态的逆问题**。

## 3. 核心问题：为什么需要 $f_2$ 作为桥梁？

#### 可优化的条件（以传统AO为例）

$$\min_{\mathbf{d}} \|\mathbf{z}_{target} - f_1(\mathbf{d})\|^2$$

$f_1$为简单线性函数，
$\min_{\mathbf{d}} \|\mathbf{z}_{target} - f_1(\mathbf{d})\|^2$的
二阶导数全局正定，有全局吸引子，那么对于任意一点都可以通过梯度优化到唯一吸引子点。

因此，变形镜与哈特曼共轭能够模拟并反馈
$\min_{\mathbf{d}} \|\mathbf{z}_{target} - f_1(\mathbf{d})\|^2$的梯度，
而
$\min_{\mathbf{d}} \|\mathbf{z}_{target} - f_1(\mathbf{d})\|^2$的梯度是常数，
因此，提前测量传递函数，全局使用。

### 3.1 直接通过 $f_3$优化 $x$ 的困难

理论上可定义目标函数：
$$\min_{\mathbf{d}} \|\mathbf{x}_{target} - f_3(\mathbf{d})\|^2$$

但与$f_1$的凸性形成**本质对比**：$f_3$包含**菲涅耳衍射传播**与**强度检测非线性**，导致优化 landscape 严重**非凸**且**病态**。传统AO成功的关键在于 $f_1$ 的二阶导数全局正定，存在唯一全局吸引子；而 $f_3$ 的Hessian矩阵条件数极高，存在**连续吸引域**与**局部极小值**，任意初始点无法保证收敛到全局最优。

更根本的是，$f_3$的**有效梯度**并非常数：小电压变化对图像的影响取决于当前波前状态（相位缠绕与散斑干涉），导致响应矩阵 $\mathbf{J}_3 = \partial \mathbf{x}/\partial \mathbf{d}$ **高度动态且不可预测**，无法像传统AO那样提前标定全局传递函数。

| 障碍                   | 说明                                                                  | 与传统AO的对比                                  |
| :--------------------- | :-------------------------------------------------------------------- | :---------------------------------------------- |
| **非凸优化 landscape** | $f_3$含衍射传播与平方律检测，目标函数存在多个局部极小值，无全局吸引子 | $f_1$线性→二阶导数正定；$f_3$非线性→Hessian病态 |
| **动态响应矩阵**       | 梯度 $\partial \mathbf{x}/\partial \mathbf{d}$ 随当前像差变化，非恒定 | 传统AO响应矩阵 $\mathbf{J}$ 恒定，可全局预标定  |
| **计算成本**           | 每步优化需运行迭代相位恢复或数值微分，耗时秒级                        | 传统AO梯度计算为简单矩阵乘法，微秒级            |
| **实时性瓶颈**         | AO闭环要求kHz更新，端到端迭代无法满足                                 | 传统AO因凸性保证可单次牛顿步收敛                |

| 障碍             | $f_3$（端到端优化）                                                                                                      | $f_1$（传统AO）                                                                                                   |
| :--------------- | :----------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- |
| **梯度获取方式** | **物理差分测量**，但面临**维度灾难**：需在百万像素图像空间测 $N$ 组响应，且每次相位恢复需迭代求解（GS/TIE）              | **物理差分测量**，在数十维Zernike空间测 $N$ 组响应，Shack-Hartmann直接输出波前斜率（无迭代）                      |
| **响应矩阵特性** | **高度非线性且时变**：$\partial \mathbf{x}/\partial \mathbf{d}$ 随当前像差状态（散斑图样）剧烈变化，必须**在线反复重测** | **近似线性且时不变**：$\mathbf{J} = \partial \mathbf{z}/\partial \mathbf{d}$ 在小幅值内恒定，**一次标定长期有效** |
| **可行性**       | 物理上**不可实时标定**：测一次梯度需 $N$ 次物理扰动×相位恢复迭代，远超AO带宽                                             | 物理上**可实时标定**：测一次梯度只需 $N$ 次扰动，毫秒级完成                                                       |

**关键洞察**：$f_3$的困难不仅在于"计算慢"，更在于**优化问题的良态性（well-posedness）**丧失。神经网络 $f_2$ 的作用正是将病态的"电压→图像→相位"反演，转化为良态的"图像→相位"推理（摊销计算），使得闭环控制只需处理凸的"电压→波前"匹配问题。

### 3.2 $f_2$ 的核心价值：摊销推理（Amortized Inference）

引入 $f_2$ 后，闭环目标被**解耦**为两个良态子问题：

$$
\underbrace{\mathbf{x} \xrightarrow{f_2} \mathbf{z}_{\text{est}}}_{\text{非线性，但可前向推理}} \quad \text{与} \quad \underbrace{\min_{\mathbf{d}} \|\mathbf{z}_{\text{est}} - f_1(\mathbf{d})\|^2}_{\text{凸优化，解析可解}}
$$

**关键优势**在于 $f_2$ 隔离了非凸性：原本混杂在 $f_3$ 中的**非线性**被限制在离线训练阶段。在线控制回路仅需处理 $f_1$ 的局部线性响应，恢复传统AO的**全局收敛保证**：

- **恒定响应矩阵**：闭环仅需 $\mathbf{J} = \partial \mathbf{z}/\partial \mathbf{d}$（Zernike到电压的线性映射），而非病态的 $\partial \mathbf{x}/\partial \mathbf{d}$
- **单次牛顿步收敛**：因目标函数二阶导数正定，控制律简化为 $\Delta \mathbf{d} = \mathbf{J}^+ (\mathbf{z}_{\text{est}} - \mathbf{z}_{\text{current}})$

### 3.3 隐变量的数学抽象：为什么Zernike系数是桥梁？

#### 3.3.1 问题重述：分解 $f_3$ 的结构

无信标AO的核心映射 $f_3: \mathbf{d} \rightarrow \mathbf{x}$ 是复杂的复合函数：

$$\mathbf{x} = f_3(\mathbf{d}) = \text{Camera}\left\{\left|\mathcal{F}^{-1}\left\{P \cdot e^{i\frac{2\pi}{\lambda}\phi(\mathbf{d})}\right\}\right|^2\right\}$$

直接优化 $f_3$ 困难，我们将其分解为两个子问题：

$$\mathbf{d} \xrightarrow{f_1} \mathbf{z} \xleftarrow{f_2} \mathbf{x}$$

**关键问题**：这个中间变量 $\mathbf{z}$ 必须满足什么数学条件，才能使 $f_1$ 和 $f_2$ 都可高效优化？

#### 3.3.2 隐变量的数学条件

设隐变量 $\mathbf{a} \in \mathbb{R}^m$ 为中间表示，分解为：

$$f_1(\mathbf{d}) = \mathbf{a}, \quad f_2(\mathbf{x}) = \mathbf{a}$$

**优化可行性要求**：

| 条件                            | 数学表述                                                                                                                                   | 物理意义                     |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------- |
| **C1: $f_1$ 可梯度优化**        | $\frac{\partial \mathbf{a}}{\partial \mathbf{d}}$ 存在且计算高效                                                                           | 控制量到隐变量的敏感映射     |
| **C2: $f_2$ 可学习**            | 存在神经网络 $\hat{f}_2(\mathbf{x}; \theta) \approx \mathbf{a}$                                                                            | 从图像提取隐变量的计算可行性 |
| **C3: $f_2$目标状态明确**       | **理论目标明确:** $\exists \mathbf{a}^*$ 对应完美波前（反例：若$f_2(x)$为常值函数0，0无法作为优化目标，并不对应完美波前，不完美波前也是0） | 存在优化目标且有解析表达     |
| **C4: 零空间一致（$f_1$可达）** | **实际可达:**$f_1(\mathbf{d}^*) = \mathbf{a}^* \Leftrightarrow$ 波前校正完成                                                               | 隐变量零状态与物理零像差对应 |

**Zernike系数 $\mathbf{z}$ 的表现**：

| 条件   | Zernike满足情况 | 具体说明                                                                                                               |
| ------ | --------------- | ---------------------------------------------------------------------------------------------------------------------- |
| C1     | ✅              | $\frac{\partial \mathbf{z}}{\partial \mathbf{d}} = \mathbf{J}$ 近似恒定，小信号线性                                    |
| C2     | ✅              | 神经网络可学习 $f_2: [\mathbf{x}_{in}, \mathbf{x}_{def}] \rightarrow \mathbf{z}$                                       |
| **C3** | ✅              | **理论目标明确**：$\mathbf{z}^* = \mathbf{0}$ 完美已知                                                                 |
| **C4** | ✅              | **实际可达一致**：变形镜偏置电压 $\mathbf{d}_{bias}$ 使 $\mathbf{z}=\mathbf{0}$ 可达，且 $\mathbf{z}=0$ 时图像质量最优 |

#### 3.3.3 反例：为什么不是所有隐变量都有效

##### 反例1：图像最大值 $f_2(x)=\mathbf{a} = \max(\mathbf{x})$

| 分析         | 结果                                                                              |
| ------------ | --------------------------------------------------------------------------------- |
| $f_2$ 可行性 | ✅ 简单前向计算                                                                   |
| $f_1$ 可行性 | ❌ $\max(\mathbf{x})$ 与 $\mathbf{d}$ 的关系高度非凸、多峰值                      |
| 优化困境     | 梯度 $\frac{\partial \max(\mathbf{x})}{\partial \mathbf{d}}$ 几乎处处为零或不确定 |
| 物理意义     | 图像亮度受光源强度、探测器增益干扰，不与像差唯一对应                              |

**结论**：违反C1，无法用于闭环控制。

#### 反例2：图像锐度 $\mathbf{a} = \sum|\nabla \mathbf{x}|^2$

| 分析         | 结果                                           |
| ------------ | ---------------------------------------------- |
| $f_2$ 可行性 | ✅ 可计算                                      |
| $f_1$ 可行性 | ⚠️ 与 $\mathbf{d}$ 非凸，存在局部极小值        |
| 优化困境     | 像差空间中存在多个锐度相同的波前（对称性简并） |
| 物理意义     | 无法区分正负像差（如正负离焦可能产生相似锐度） |

**结论**：违反C3和C4，目标状态不唯一，优化收敛到伪解。

---

### 3.3.4 Zernike选择的物理根源

**关键洞察**：Zernike系数不是任意的数学选择，而是**物理系统的自然坐标**。

#### 物理结构匹配

```
大气湍流统计：Kolmogorov谱 → 能量集中在低阶模式
                    ↓
变形镜机械响应：驱动器影响函数 → 主要耦合低阶形变
                    ↓
光学传播：近场相位 → 远场强度（PSF）
                    ↓
Zernike基：圆形口径正交多项式 → 自然分离像差模式
```

| 物理层级       | Zernike的适配性                                     |
| -------------- | --------------------------------------------------- |
| **变形镜控制** | 电压→位移→低阶形变近似线性                          |
| **波前传播**   | 相位在Zernike基下稀疏表示                           |
| **图像形成**   | 低阶Zernike主导PSF形态                              |
| **像质评价**   | RMS波前误差 = $\|\mathbf{z}\|^2$ 直接对应斯特列尔比 |

**数学本质**：Zernike基是**变形镜可控子空间**与**大气扰动主要子空间**的交集的自然坐标。

---

### 3.3.5 能否学习其他隐变量？

#### 理论可能性

Zernike满足条件C1-C4，但**数学上不唯一**。可能存在其他 $\mathbf{a}$ 同样满足：

$$\exists \mathbf{T} \in \mathbb{R}^{m \times m}, \text{可逆}: \quad \mathbf{a} = \mathbf{T}\mathbf{z}$$

即Zernike系数的任意**线性可逆变换**也是有效隐变量。

#### 自监督学习框架

如何发现（或学习）替代隐变量？需要约束优化：

```python
# 理想的学习目标
a_learned = encoder(x; φ)  # 参数化编码器

# 联合训练目标
minimize  L_recon + λ_1·L_linear + λ_2·L_cycle + λ_3·L_physical

其中：
- L_recon: ||decoder(a_learned) - x||²     (重建一致性, C2)
- L_linear: ||a_learned - J·d||²           (与控制线性对齐, C1)
- L_cycle: ||encoder(f3(d)) - J·d||²      (闭环一致性, C3)
- L_physical: TIE_constraint(a_learned, x) (相位恢复物理, C4)
```

#### 关键约束详解

| 约束                                    | 作用                                             | 实现方式                                                                                                            |
| --------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **线性对齐损失** $\mathcal{L}_{linear}$ | 强制学到的 $\mathbf{a}$ 与 $\mathbf{d}$ 线性相关 | 联合训练 $f_1': \mathbf{d} \rightarrow \mathbf{a}$，要求 $\frac{\partial \mathbf{a}}{\partial \mathbf{d}}$ 近似恒定 |
| **循环一致性** $\mathcal{L}_{cycle}$    | 确保 $\mathbf{a}=0$ 对应完美像质                 | 输入完美平面波仿真数据，约束编码器输出零                                                                            |
| **物理先验** $\mathcal{L}_{physical}$   | 防止表示坍塌到非物理解                           | 加入TIE或衍射传播约束                                                                                               |

#### 学习隐变量的充分条件

若要自监督学习替代Zernike的 $\mathbf{a}$，需确保：

| 条件           | 数学要求                                                                      | 物理保证                         |
| -------------- | ----------------------------------------------------------------------------- | -------------------------------- |
| **可控性**     | $\text{rank}\left(\frac{\partial \mathbf{a}}{\partial \mathbf{d}}\right) = m$ | 隐变量维度不超过变形镜自由度     |
| **可观测性**   | $\text{rank}\left(\frac{\partial \mathbf{x}}{\partial \mathbf{a}}\right) = m$ | 隐变量变化在图像中可检测         |
| **目标可达性** | $\mathbf{a}^* \in \text{Im}(f_1)$                                             | 变形镜能产生的波前包含零像差状态 |
| **唯一性**     | $f_2^{-1}(\mathbf{a}^*)$ 单值                                                 | 完美像质对应唯一的控制目标       |

---

### 3.3.6 前沿方向与挑战

| 方向                   | 方法                                              | 核心困难                                     |
| ---------------------- | ------------------------------------------------- | -------------------------------------------- |
| **端到端隐空间学习**   | 自编码器+控制映射联合训练                         | 表示坍塌，学到的 $\mathbf{a}$ 可能与像差无关 |
| **物理信息神经网络**   | PINN约束衍射方程                                  | 计算成本高，实时性难保证                     |
| **对比学习表示**       | 相似像质样本聚类                                  | 缺乏显式物理对应，控制映射难学习             |
| **强化学习绕过隐变量** | 直接策略 $\pi: \mathbf{x} \rightarrow \mathbf{d}$ | 样本效率低，收敛慢                           |

**当前共识**：在实时AO应用中，物理启发的Zernike基仍是最实用的选择。学习替代表示的研究主要在仿真验证阶段，尚未证明在实际系统中的优势。

---

### 3.3.7 小结

| 问题               | 结论                                                     |
| ------------------ | -------------------------------------------------------- |
| 隐变量是否唯一？   | **不唯一**，任何满足C1-C4的表示都可行                    |
| 为何选择Zernike？  | **物理自然性**：匹配变形镜线性响应和湍流低阶统计         |
| 能否学习其他表示？ | **理论上可以**，需强约束确保线性可控性和目标唯一性       |
| 自监督学习的关键？ | **联合优化**编码器、解码器和控制映射，加入物理一致性约束 |

> **核心洞察**：Zernike系数的优势不在于数学唯一性，而在于它恰好是**物理系统可控子空间与可观测子空间的自然交集坐标**。学习替代表示需要"重新发现"这些物理结构，目前仍是开放的研究方向。

# 自适应光学的本质：一场波前的梯度下降优化

从**优化视角**：将AO控制重新表述为Zernike空间中的梯度下降问题。这种视角不仅简化理解，更为现代AO算法设计（机器学习、预测控制）提供理论基础。

## 1. 核心映射：电压 → Zernike系数

定义控制问题：

$$\mathbf{z} = f(\mathbf{d})$$

| 符号         | 含义                                 | 维度       |
| ------------ | ------------------------------------ | ---------- |
| $\mathbf{d}$ | 变形镜驱动电压                       | $N_{act}$  |
| $\mathbf{z}$ | 波前Zernike系数（残余误差）          | $N_{zern}$ |
| $f(\cdot)$   | 系统响应函数（含光学、机械、传感器） | 映射函数   |

**物理意义**：施加电压 $\mathbf{d}$，系统输出波前，投影到Zernike基得到系数 $\mathbf{z}$。

## 2. 线性假设与雅可比矩阵

### 2.1 关键假设：局部线性

在小信号区域，响应函数可线性化：

$$\mathbf{z} \approx \mathbf{J} \cdot \mathbf{d} + \mathbf{z}_0$$

其中 **雅可比矩阵** $\mathbf{J} = \frac{\partial \mathbf{z}}{\partial \mathbf{d}}$ 正是AO系统的**响应矩阵**（灵敏度矩阵）。

### 2.2 为什么"梯度不变"？

$$\mathbf{J}_{ij} = \frac{\partial z_i}{\partial d_j} \approx \text{const}$$

这是AO系统的**核心工程假设**：

- 压电陶瓷工作在线性区（小迟滞）
- 变形镜表面应力不变（小形变）
- 光学路径固定（共轭稳定）

> **类比**：就像训练神经网络时假设损失函数局部光滑，使得梯度下降可行。AO假设响应局部线性，使得梯度下降可行，不同之处在于神经网络每更新到一个新的点要重新计算梯度（没有假定梯度不变），而AO系统一直使用同一个梯度，假设梯度不变。

| 特性         | 神经网络训练                                     | AO闭环控制                    |
| ------------ | ------------------------------------------------ | ----------------------------- |
| **梯度获取** | 每步反向传播重新计算 $\nabla_\theta \mathcal{L}$ | 固定使用预标定的 $\mathbf{J}$ |
| **梯度变化** | 允许任意变化（非凸、多峰）                       | 假设恒定（线性时不变）        |
| **更新目标** | 寻找全局/局部最优                                | 实时跟踪动态扰动（湍流）      |
| **时间尺度** | 分钟到小时（离线）                               | 毫秒（在线，kHz）             |

| 神经网络         | AO系统                        |
| ---------------- | ----------------------------- |
| 损失景观复杂未知 | 物理系统有明确线性工作区      |
| 参数空间高维抽象 | 电压→形变有机械确定性         |
| 可以离线慢慢算   | 必须实时（湍流相干时间~10ms） |

神经网络每步主动重算梯度以适应任意损失景观；AO系统被动固定梯度以换取实时性，依赖物理线性假设和闭环反馈保证有效。

## 3. 优化视角：梯度下降 = 闭环控制

### 3.1 目标函数

最小化波前误差（以Zernike系数度量）：

$$\min_{\mathbf{d}} \mathcal{L}(\mathbf{d}) = \frac{1}{2}\|\mathbf{z}\|^2 = \frac{1}{2}\|\mathbf{J}\mathbf{d} + \mathbf{z}_{turb}\|^2$$

### 3.2 梯度下降迭代

$$\mathbf{d}_{k+1} = \mathbf{d}_k - \eta \cdot \nabla \mathcal{L} = \mathbf{d}_k - \eta \cdot \mathbf{J}^T \cdot \mathbf{z}_k$$

### 3.3 与传统AO控制的对应

| 优化视角                      | 传统AO控制                      | 等价形式                                                                            |
| ----------------------------- | ------------------------------- | ----------------------------------------------------------------------------------- |
| 学习率 $\eta$                 | 闭环增益 $g$                    | $\eta \leftrightarrow g$                                                            |
| 梯度 $\mathbf{J}^T\mathbf{z}$ | 重构电压 $\mathbf{R}\mathbf{s}$ | $\mathbf{J}^T\mathbf{z} = \mathbf{R}\mathbf{s}$（当$\mathbf{z}$从$\mathbf{s}$重构） |
| 迭代步数 $k$                  | 时间帧 $t$                      | 离散时间对应                                                                        |

**PID控制**可视为带动量项和积分项的加速梯度下降：

$$\mathbf{d}_{k+1} = \mathbf{d}_k + K_p \mathbf{e}_k + K_i \sum \mathbf{e}_k + K_d \Delta \mathbf{e}_k$$

## 4. 收敛性保证

### 4.1 线性情况

更新律：
$$\mathbf{z}_{k+1} = (\mathbf{I} - \eta \mathbf{J}\mathbf{J}^T) \mathbf{z}_k$$

收敛条件：

- $\mathbf{J}\mathbf{J}^T$ 正定（满秩或正则化）
- $0 < \eta < \frac{2}{\lambda_{max}(\mathbf{J}\mathbf{J}^T)}$

#### z=0 是全局吸引子

海森矩阵定义：对于标量函数 $f: \mathbb{R}^n \to \mathbb{R}$，海森矩阵 $H(x)$ 是 $n \times n$ 的对称矩阵：

$$H_{ij}(x) = \frac{\partial^2 f}{\partial x_i \partial x_j}(x)$$

写成矩阵形式：

$$
H(x) = \nabla^2 f(x) = \begin{bmatrix}
\frac{\partial^2 f}{\partial x_1^2} & \frac{\partial^2 f}{\partial x_1 \partial x_2} & \cdots \\
\frac{\partial^2 f}{\partial x_2 \partial x_1} & \frac{\partial^2 f}{\partial x_2^2} & \cdots \\
\vdots & \vdots & \ddots
\end{bmatrix}
$$

- **一维类比**：$f''(x) > 0$ 表示"碗状"（凸），$f''(x) < 0$ 表示"拱状"（凹）
- **高维推广**：海森矩阵的特征值告诉你，在**各个方向**上是"碗"还是"拱"

| 海森特征值 | 几何形状     | 优化含义               |
| ---------- | ------------ | ---------------------- |
| 全 $> 0$   | 严格凸（碗） | 局部最小值，稳定吸引子 |
| 有正有负   | 鞍形（马鞍） | 不稳定，梯度下降会逃逸 |
| 有 $= 0$   | 柱面或平坦   | 退化，需更高阶分析     |

目标函数（波前方差）：
$$V(\mathbf{d}) = \frac{1}{2}\|\mathbf{z}\|^2 = \frac{1}{2}(\mathbf{J}\mathbf{d} + \mathbf{z}_0)^T(\mathbf{J}\mathbf{d} + \mathbf{z}_0)$$

展开后：
$$V(\mathbf{d}) = \frac{1}{2}\mathbf{d}^T\underbrace{\mathbf{J}^T\mathbf{J}}_{\text{海森矩阵}} \mathbf{d} + \mathbf{z}_0^T\mathbf{J}\mathbf{d} + \text{const}$$

**海森矩阵**：
$$H_{\mathbf{d}} = \mathbf{J}^T\mathbf{J} \quad (N \times N \text{矩阵}, N=\text{驱动器数})$$

因此

- $\mathbf{J}\mathbf{J}^T$ 正定（满秩或正则化）保证了海森矩阵全局正定，z=0为全局吸引子

##### 直观理解：为什么 $\mathbf{J}\mathbf{J}^T$ 正定保证收敛？

$\mathbf{J}\mathbf{J}^T$ 正定的物理意义：

- **可控性**：每个Zernike模态都能被驱动器组合影响（无"失控"模态）
- **可观测性**：从Zernike系数可以唯一反推控制效果

这保证了无论当前波前误差 $\mathbf{z}$ 是什么，都存在唯一的"下坡方向"指向 $\mathbf{z}=0$，且能量景观是**严格的抛物面**（而非波浪形或平坦峡谷）。

## 5. 非线性扩展：当线性假设失效

| 场景         | 问题                              | 解决方案                     |
| ------------ | --------------------------------- | ---------------------------- |
| 大行程变形镜 | $\mathbf{J}$ 随 $\mathbf{d}$ 变化 | 牛顿法 / 拟牛顿法            |
| 强压电迟滞   | 梯度方向历史依赖                  | 电荷驱动 / 迟滞补偿模型      |
| 未建模动态   | 响应延迟、谐振                    | 模型预测控制（MPC）          |
| 完全未知响应 | 无解析模型                        | 无导数优化（SPGD）、强化学习 |

## 6. 为什么这个视角重要？

### 6.1 理论统一

将AO控制纳入**标准优化理论框架**，可直接借用：

- 随机梯度下降（SGD）→ 用于无波前传感AO
- 自适应学习率（Adam）→ 用于时变湍流
- 正则化技术（L1/L2）→ 用于驱动器耦合抑制

### 6.2 算法创新

| 传统AO局限              | 优化视角解决方案                    |
| ----------------------- | ----------------------------------- |
| 固定重构器 $\mathbf{R}$ | 在线学习 $\mathbf{J}$（自适应梯度） |
| 单帧反馈                | 多步预测（MPC损失函数）             |
| 线性模型                | 神经网络替代 $f(\mathbf{d})$        |

## 7. 总结

> **自适应光学的本质**：通过测量波前误差（Zernike系数或斜率），利用响应矩阵（雅可比/梯度）计算电压调整方向，迭代最小化残余像差。

| 层级       | 核心概念                                                                   |
| ---------- | -------------------------------------------------------------------------- |
| **物理层** | 变形镜产生共轭波前                                                         |
| **数学层** | $\mathbf{z} = \mathbf{J}\mathbf{d}$，最小化 $\|\mathbf{z}\|^2$             |
| **算法层** | 梯度下降：$\mathbf{d} \leftarrow \mathbf{d} - \eta \mathbf{J}^T\mathbf{z}$ |
| **实现层** | 高速闭环（kHz）、实时计算、硬件延迟补偿                                    |

## 参考

- **经典AO**：Roddier, _Adaptive Optics in Astronomy_ (1999)
- **优化控制**：Kulesár et al., "Optimal control for adaptive optics" (2006)
- **机器学习AO**：Swanson et al., "Deep learning for wavefront sensing" (2020)

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

$$x(t_1) \approx x(t_0) + \underbrace{f(x(t_0))}_{\text{变化率}} \cdot (t_1 - t_0)$$
或
$$x(t_1) \approx x(t_0) + \underbrace{\dot{x}(t_0))}_{\text{变化率}} \cdot (t_1 - t_0)$$

风就是场，蒲公英在风中的变化就是动力系统。

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

## 3. 梯度下降，从优化到动力学

给定目标函数 $f: \mathbb{R}^n \to \mathbb{R}$，**梯度下降**的连续形式为：

$$\dot{x} = -\nabla F(x)$$

这是一个特殊的动力系统，其中向量场 $f(x) = -\nabla F(x)$ 是某个标量函数的负梯度。

**关键性质**：这种系统称为**梯度流（Gradient Flow）**，具有特殊的动力学行为。

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

## 7. 深度学习中的吸引子现象

**损失景观（Loss Landscape）**研究揭示：

- 局部最小值通常具有相近的损失值（并非坏事）
- 鞍点更成问题：梯度下降会缓慢穿越
- 大批量训练倾向于收敛到"尖锐"最小值（吸引域小，泛化差），小批量到"平坦"最小值（吸引域大，泛化好）

## 8. 参考

1. **吸引子三要素**：平衡点（一阶为零）+ 局部凸性（二阶正定）+ 吸引域内初值

2. **几何直觉**：梯度下降沿最陡下降方向"滑向"能量碗底，碗的曲率决定滑动速度

3. **高维复杂性**：鞍点和退化方向使分析复杂，但Hessian特征值提供局部完整信息

4. **控制增强**：PID类方法通过引入记忆和阻尼，可塑造更有效的吸引动力学

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
