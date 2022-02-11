---
title: Experiments
top: false
cover: false
toc: true
mathjax: true
date: 2021-12-17 10:00:56
password:
summary:
description: 发现统计规律，记录一些自己diy的实验。
categories:
- Experiments
tags:
- Personal Thought
- Experiments
- private
---



# Deep Learning

## Feature Map Multiplication

### dataset: Caltech101

[source code](https://github.com/xyegithub/Featrue-map-multiplication)

3号服务器

/media/new_2t/yexiang/image_classification/multiply/from_#1/ffmnst/Caltech101

#### bn，sig

| 配置                                                         | accuracy |
| ------------------------------------------------------------ | -------- |
| `out = self.bn(out) + self.shortcut(x) `                     | 87.62    |
| `out = (out.sigmoid() + 1)* self.bn_s(self.shortcut(x))`     | 78.23    |
| `out = (self.bn(out).sigmoid() + 1) * self.bn_s(self.shortcut(x))` | 78.69    |
| `(self.bn(out).sigmoid() + 0.5) * self.bn_s(self.shortcut(x)) ` | 78.57    |
| `self.bn_s.bias.data[:]=1`<br>`out = (self.bn(out).sigmoid() + 1) * self.bn_s(self.shortcut(x))    ` | 82.26    |
| `self.bn_s.bias.data[:]=1`  <br>`out = (self.bn(out).sigmoid() + 0.5) * self.bn_s(self.shortcut(x)) ` | 84.10    |
| ` self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=1`<br>` out = (self.bn(out).sigmoid() + 0.5) * self.bn_s(self.shortcut(x))             ` | 84.85    |
| `self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=1`<br>`out = (self.bn(out).sigmoid()) * self.bn_s(self.shortcut(x))` | 85.83    |
| `self.bn.bias.data[:]=0`<br>`self.bn.weight.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`out = (self.bn(out).sigmoid()) * self.bn_s(self.shortcut(x))` | 81.57    |

1. 从这个结果看出shortcut的均值为1，会使得优化更好
2. Res分支的sigmoid不需要加0.5或者1，性能提高了。乘以sigmoid本身有恒等的特性。sigmoid分支输出都为0时，sigmoid输入都是0.5。
3. 在Res分支的sigmoid之前，先对out进行bn归一化，会优化的更好，而且让归一化的均值为0，会优化的更好。但是如果同时也控制归一化的方差，效果变差。无参的bn限制了表达能力。

#### sig, bn

| 配置                                                         | accuracy |
| ------------------------------------------------------------ | -------- |
| `out = self.bn(out) + self.shortcut(x) `                     | 87.62    |
| `out = (self.shortcut(x).sigmoid() + 1)* self.bn_s(out)`     | 83.93    |
| `out = (self.bn(self.shortcut(x)).sigmoid() + 1) * self.bn_s(out)` | 85.54    |
| `(self.bn(self.shortcut(x)).sigmoid() + 0.5) * self.bn_s(out) ` | 85.14    |
| `self.bn_s.bias.data[:]=1`<br>`out = (self.bn(self.shortcut(x)).sigmoid() + 1) * self.bn_s(out)    ` | 85.43    |
| `self.bn_s.bias.data[:]=1`  <br>`out = (self.bn(self.shortcut(x)).sigmoid() + 0.5) * self.bn_s(out) ` | 87.44    |
| ` self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=1`<br>` out = (self.bn(self.shortcut(x)).sigmoid() + 0.5) * self.bn_s(out)             ` | 84.39    |
| `self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=1`<br>`out = (self.bn(self.shortcut(x)).sigmoid()) * self.bn_s(out)` | 84.39    |
| `self.bn.bias.data[:]=0`<br>`self.bn.weight.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`out = (self.bn(self.shortcut(x)).sigmoid()) * self.bn_s(out)` | 84.91    |

**sig, bn比bn, sig的效果好。原因可能是，sig本来就有梯度的问题，然而，shortcut分支没有需要优化的参数，所以把sigmoid放在shortcut分支更好？**

#### bn, bn

| 配置                                                         | Accuracy |
| ------------------------------------------------------------ | -------- |
| `out = self.bn(out)* self.bn_s(self.shortcut(x))`            | 77.13    |
| `self.bn_s.bias.data[:]=1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x)) ` | 75.75    |
| `self.bn.bias.data[:] = 1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x))` | 79.55    |
| `self.bn.bias.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x))` | 81.39    |
| `self.bn.bias.data[:]=1`<br>`self.bn.weight.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x))` | 81.05    |
| `self.bn.bias.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`self.bn_s.weight.data[:]=1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x))` | 80.24    |
| `self.bn.bias.data[:]=1`<br>`self.bn.weight.data[:]=1`<br>`self.bn_s.bias.data[:]=1`<br>`self.bn_s.weight.data[:]=1`<br>`out = self.bn(out)* self.bn_s(self.shortcut(x))` | 81.22    |

均值为1的话，一般来说还是会获益。但是bn的效果不是很好。

#### sig, sig

| 配置                                                         | Accuracy |
| ------------------------------------------------------------ | -------- |
| `out = (self.shortcut(x).sigmoid()) * out.sigmoid())`        | 79.44    |
| `out = (self.shortcut(x).sigmoid()) * (out.sigmoid() + 0.5)` | 70.05    |
| `out = (self.shortcut(x).sigmoid() + 0.5) * (out.sigmoid())` | 76.61    |
| `out = (self.shortcut(x).sigmoid()) * (out.sigmoid() + 1)`   | 72.64    |
| `out = (self.shortcut(x).sigmoid() + 1) * (out.sigmoid())`   | 71.77    |

没有加bn，sigmoid会过饱和，效果不是很好。一边加bn

| 配置                                                         | Accuracy |
| ------------------------------------------------------------ | -------- |
| `out = (self.shortcut(x).sigmoid()) * self.bn(out).sigmoid()` | 86.69    |
| `out = (self.bn_s(self.shortcut(x)).sigmoid()) * out.sigmoid()` | 79.90    |
| `self.bn_s.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * out.sigmoid()` | 76.32    |
| `self.bn.bias.data[:]=0`<br>`out = (self.shortcut(x).sigmoid()) * self.bn(out).sigmoid()` | 83.99    |
| `self.bn.bias.data[:]=0 `<br>` out = (self.shortcut(x).sigmoid()) * (self.bn(out).sigmoid() + 0.5)` | 86.52    |
| `self.bn.bias.data[:]=0 `<br>`out = (self.shortcut(x).sigmoid()) * (self.bn(out).sigmoid() + 1) ` | 82.83    |
| `self.bn.weight.data[:]=1`<br>`out = (self.shortcut(x).sigmoid()) * self.bn(out).sigmoid()` | 78.74    |
| `self.bn_s.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid() + 0.5) * out.sigmoid()` | 73.39    |

两边加bn

| 配置                                                         | Accuracy |
| ------------------------------------------------------------ | -------- |
| ` out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 86.23    |
| `self.bn.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 86.41    |
| `self.bn.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * (self.bn(out).sigmoid() + 1)` | 85.83    |
| `self.bn.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * (self.bn(out).sigmoid() + 0.5)` | 86.23    |
| `self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=0`<br/>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 86.52    |
| `self.bn.bias.data[:]=0`<br/>`self.bn_s.bias.data[:]=0`<br/>`self.bn_s.weight.data[:]=1`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 82.49    |
| `self.bn.bias.data[:]=0`<br/>`self.bn.weight.data[:]=1`<br/>`self.bn_s.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 83.47    |
| `self.bn.bias.data[:]=0`<br>`self.bn_s.bias.data[:]=0`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * (self.bn(out).sigmoid() + 0.5)` | 84.91    |
| `self.bn.bias.data[:]=0`<br/>`self.bn_s.bias.data[:]=0`<br/>`out = (self.bn_s(self.shortcut(x)).sigmoid() + 0.5) * self.bn(out).sigmoid())` | 86.92    |
| `self.bn.bias.data[:]=0`<br/>`self.bn_s.bias.data[:]=0`<br/>`out = (self.bn_s(self.shortcut(x)).sigmoid() + 1) * self.bn(out).sigmoid())` | 86.75    |
| `self.bn.bias.data[:]=0`<br/>`self.bn_s.bias.data[:]=0`<br/>`out = (self.bn_s(self.shortcut(x)).sigmoid() + 0.5) * (self.bn(out).sigmoid() + 0.5)` | 84.79    |
| `self.bn.weight.data[:]=1`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 81.91    |
| `self.bn_s.weight.data[:]=1`<br>`out = (self.bn_s(self.shortcut(x)).sigmoid()) * self.bn(out).sigmoid()` | 80.93    |

#### Resdual 分支内部使用乘法

| 配置                                                         | Accuracy |
| ------------------------------------------------------------ | -------- |
| `out_1 = F.relu(self.bn2(out_1))`<br>`out *= self.adap(out_1)` | 86.06    |
| `out_1 = F.relu(self.bn2(out_1))`<br>`out *= self.adap(out_1).sigmoid()` | 87.33    |
| `out_1 = self.bn2(out_1)`<br>`out = self.conv2(out_1)`<br>`out *= self.adap(out_1).sigmoid()` | 85.71    |
| `out_1 = self.bn2(out_1)`<br/>`out = self.conv2(out_1.relu())`<br/>`out *= self.adap(out_1).sigmoid()` | 87.85    |
| `self.bn2.bias.data[:]=0`<br>`out_1 = self.bn2(out_1)`<br>`out = self.conv2(out_1)`<br>`out *= self.adap(out_1).sigmoid()` | 86.64    |
| `self.bn2.bias.data[:]=0`<br/>`out_1 = self.bn2(out_1)`<br/>`out = self.conv2(out_1.relu())`<br/>`out *= self.adap(out_1).sigmoid()` | 81.51    |
| `self.bn2.bias.data[:]=0`<br/>`out_1 = self.bn2(out_1)`<br/>`out = self.conv2(out_1.sigmoid())`<br/>`out *= self.adap(out_1).sigmoid()` | 82.66    |
| `out_1 = F.relu(self.bn2(out_1))`<br>`out = self.conv2(out_1).sigmoid()`<br>`out = self.adap(out_1) * out` | 84.22    |
|                                                              |          |

#### 借鉴NAM

1. 用了sigmoid乘以原矩阵
2. sigmoid之前用了bn
3. 还在每个通道上乘以了和为1的数


$$
\begin{align}
att &= norm(x) \\
att &= att \times \gamma + \delta \\
att &= att \times \frac\gamma{sum(\gamma)} \\
out &= att.sigmoid() \times x
\end{align}
$$

| 配置                                 | Accuracy |
| ------------------------------------ | -------- |
| `out = self.nam(x) + self.bn_s(out)` | 86.41    |
