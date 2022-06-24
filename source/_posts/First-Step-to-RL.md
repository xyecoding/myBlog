---
title: First Step to Reinforcement Learning
description: An introduction to Reinforcement Learning
tags:
  - Reinforcement Learning
categories:
  - Machine Learning
  - Methods
  - Reinforcement Learning
abbrlink: 1e331e4a
date: 2021-12-03 16:48:41
---

### 什么是强化学习，关于强化学习的几点疑问

<font color=green size=3>强化学习三要素：环境状态，行动，奖励</font>

<font color=green size=3>目标：尽量多的获得奖励</font>

<font color=green size=3>本质：连续决策</font>

基本的强化学习模型包括：

- 环境状态的集合 S
- 动作的集合 A
- 状态之间的转换规则（是环境的一部分）
- 规定转换后“即时奖励”的规则（是环境的一部分）
- 描述主体（智能体）能够观察到什么的规则（是环境的一部分）
- 能够做出决策/动作的主体（智能体）

#### 区别于深度学习，强化学习的本质特点是什么？

**两个定义**

1，强化学习是机器学习的一个重要分支，主要用来解决连续决策问题。

2，强化学习又称 再励学习，评价学习或增强学习，是机器学习的范式和方法论之一，用于
描述和解决智能体（agent）在于环境交互过程中通过学习策略以达成回报最大或实现特定
目标的问题。

强化学习的本质是<font color=deeppink> 描述和解决智能体（agent）在于环境交互过程
中通过学习策略以达成回报最大或实现特定目标的问题。</font>它本质是这样一种场景，
在这种场景中它为了达到某种目的，做出连续的决策。这样符合这种场景，那就是强化学习
。

强化学习和深度学习这两个名词的维度是不一样的。深度学习描述的是算法本身的特点，深
度够不够，是不是连接主义的模型。深度学习可以用来做无监督，也可以用来做半监督，也
可以用来做弱监督，甚至可以用来作为强化学习算法的一部分。深度学习这个名词，不管应
用场景只管模型本身是不是满足深度学习的特点。

而强化学习描述的是应用场景的特点，只要能提供智能体决策的算法，管它是什么模型，什
么结构，那就是强化学习的算法。从这个角度上讲，我现在认为强化学习和监督学习，无监
督学习，弱监督学习，是并列的，是对应用场景的描述。和深度学习不是同一维度的。

<font color=deeppink>强化学习的本质在于目标给定的形式，不像无监督学习那样完全没
有学习目标，也不像监督学习那样有非常明确的目标（label），强化学习的目标一般是变
化的，不明确的，甚至可能不存在绝对正确的目标。，强化学习的问题都可以抽象成，环境
状态，行动和奖励。应该说只要能抽象为这三个要素，目标是获得最大奖励的模型，就是强
化学习的模型。</font>

强化学习的最大的特点是“试错”，是尝试各种可能，而强化结果好的可能。（策略网络的特
点，估值网络的特点是修正和预测获益）

由于强化学习是一种决策学习，这个问题的特点就是离散型。但是离散并不就是强化学习（
连续的决策才是，目标的模糊和不确定性是决策问题的特点）。深度学习本质是函数的拟合
，所以连续可微是它的特点。并不能说连续可微的问题就是深度学习，离散的问题就是强化
学习。

#### 深度学习用梯度下降的算法实现模型的优化，强化学习无法求导，甚至连学习目标都是模糊的如何优化模型参数？

这个问题要了解下一节，具体的强化学习方法。

#### 强化学习与弱监督学习？

弱监督是属于有监督学习，只是它学习的目标不是被给予的标签，而是比被给予标签更强的
标签（强弱是指标签做含有的信息量），也就是说弱监督是根据少量信息的标签，推测出更
多的信息。

强化学习的本质是连续决策。连续决策的特点是目标的模糊和不确定性。

所以，虽然弱监督和强化学习都没有给出最终准确的目标，但是他们任然很不同的

#### 深度学习是死的，没有智能的机器学习算法，强化学习是“活的”，有智能的机器学习算法

深度学习大部分我们用作有监督的学习算法。其实说深度学习是死的，不如说有监督学习是
死的。

有监督学习其实是完全的复刻标签里面含有的知识，它的本质就是一个函数拟合的问题，它
无法摆脱对绝对的标签的依赖，无法超越标签。

而强化学习，正由于它的目标是模糊和不确定的。使得算法在设计上必须具有随机性和探索
性，它能够探索出人类从来没有到过的领域。就像在围棋上，下出人类完全无法理解的棋，
人从来没有想过的一些下法。这就是强化学习算法探索出来的知识。所以我觉得它是活着的
，拥有智能的算法。

<font color=green>从感性的层面，强化学习算法很接近人脑的行为：感知环境，探索环境
，强化有益行为</font>

#### 关于深度学习，强化学习，连续可导性和离散不可导性的讨论

1.  从函数的角度，深度学习和强化学习都需要学习一个函数映射。深度学习是从输入到
    target 的映射。强化学习是学从环境状态到 Action 的映射。这两个映射可以看成性
    质一样的，因为深度学习可以作为强化学习的智能体。所以从函数的角度，他们没有连
    续和离散的区别。（PS. 深度学习模型和强化学习的智能体都是连续可导的函数
    。target 和 Action 都可以是离散的或者连续的。）

2.  深度学习作为用梯度下降算法优化的模型，无法优化对 loss 不可导的参数。如在深度
    学习中，设计一个分支来决定模型是否应该包含某个模块，这个分支的参数是不可优化
    的。因为包含和不包含是离散的，对 loss 不可导。

不过假设，如果包含与不包含是连续的。也就是说，可以以 0.1 的权重包含。那么，这些
参数是可以优化的。从这点来看，离散就是导致模型参数不可优化的原因。

3.  强化学习在离散的情况下解决 2 中的问题。由此，我得到了一个概念，强化学习解决
    离散的问题。

4.  下面我们来分析一下这个场景。首先，决定一个模块该不该被使用，这个场景是一次
    Action 的场景，不是连续决策的场景。也就是说 Action 一次，我就能知道最终
    reward 多少了，只有单步的 reward。

限于这个单次决策的场景来看，如果 Action 相对于 reward 是连续可导的，那么深度学习
就能解决这个问题。如果 Action 相对于 reward 是离散的，那么仅仅深度学习无法解决这
个问题，要靠强化学习。

<font color=green>这里单次 Action 就知道 reward，实际上这个问题就退化为了有监督
学习，因为这个单步的 reward 就可以看成我的标签了。所以深度学习解决这个问题是很自
然的。</font>

5.  多次决策的问题，无论是连续的还是离散的都只能用强化学习的方法。因为多次决策，
    这个问题就不可以退化为监督学习的问题了。它是一个真正的强化学习的问题。

综上所诉，强化学习解决深度学习解决不了的离散问题，那只是在单次决策的时候，这个问
题退化为了有监督学习。强化学习的方法，恰好可以提供离散变量的学习。

强化学习方法解决深度学习中的离散问题，仅仅是强化学习附带的一个小福利。

**<font color=green>因为它能把经验转化为可导的目标，就拿策略网络来说，从梯度的角
度，它只管增加当前随机 Action 的概率，而加入 advatage 之后，自动就优化除了想要的
大 reward 的行为。</font>**

#### 深度学习优化和强化学习优化的感性理解

前面说了深度学习优化可导的参数，强化学习可以优化不可导的参数。这里说一下对深度学
习优化方法和强化学习优化方法的感性理解。

还是说前面包不会包含某模块的例子，由于连续可导，对于每一个参数值，深度学习模型其
实都同时参与了两种 Action（包含和不包含）。score = 0.1 包含，其实其中包含了含有
的成分，也包含了不含有的成分。所以我们可以连续的变动 score，看看包含多好，还是不
好含多好。这其实就是梯度下降算法的方式。得益于每一个参数，其实我都对包含和不包含
的情况都有了解，我当然知道哪个更好，就往那边移动（优化）。

然而，对于离散的情况，要么只能包含，要么只能不包含。当选择包含的时候，模型对不包
含的情况完全是无知的。可能更好，也可能差。当不包含的时候，也是一样的。无论哪种情
况，我都没有办法优化，两种情况是完全隔离开的，信息不沟通的，是离散的。所以梯度下
降算法无法优化它。

强化学习用随机探索的方法让两者信息又沟通起来。包含一下试一下，然后，不包含也试一
下。尝试的结果是哪种 reward 多，就增大哪种的概率。

**<font color=green>所以，无论哪种优化方法，信息的沟通都是必要的。要对所有的
action 都了解，才能知道选择哪种 action。 只是深度学习是连续的，它的每一种参数，
都包含了所有 Action 的信息（reward），每一种 Action 都参与了，所以它能直接连续的
梯度下降的优化，不需要随机探索了。而对于离散的，每种 action 只能知道自己的
reward，对其他 Action 一无所知的时候，梯度的优化是不行的。必须要探索各种
Action，还是要知道了每一种 Action 的情况(reward)之后，才能优化。这是方法论
。</font>**

更进一步，离散的地方，相对于 reward 一定是不可导的，所以深度学习不行。而强化学习
，更准确的说是策略网络，相当于给离散的地方加了标签，这样它就在离散的地方有监督了
，它就可以根据增加的标签优化。而标签的设计就是根据探索的结果，增大 reward 大的
Action，reward 大的 Action 就是它的标签，而且这个标签是动态的，是对抗得出的。

强化学习方法算出的梯度是策略梯度。

**<font color=green>强化学习： 不知道选哪边了； 试试呗；按试出来 reward 大的
Action 优化它。</font>**

**<font color=green>强化学习：它离散，对于 reward 不可导；不直接用 reward 优化它
，给它加个标签，把试出来 reward 大的 Action，作为标签去优化</font>**

在不可导的地方加标签。

**<font color=green>由此，强化学习算法的本质是制作标签，无论是连续决策，标签不确
定的情况，还是它能解决离散问题的情况，它都是用制作标签的方法解决的。</font>**

### 策略网络(Policy Network)和估值网络(Value Network)

AlphaGo 使用了快速走子，策略网络，估值网络和蒙特卡洛搜索树等技术。

强化学习算法的一个关键是<font color=green>随机性和探索性</font>，我们需要让算法
通过试验样本自己学习什么才是某个环境状态下比较好的 Action，而不是像有监督学习一
样，告诉模型什么是好的 Action，因为我们也不知道什么是好的 Action.

深度强化学习模型的本质是神经网络，神经网络是工具，根据问题转化以及建模的不同，主
要分为策略网络和估值网络。

强化学习中最重要的两类方法**Policy-based,Value-based**。第一种直接预测在某个环境
下应该采取的行动（直接输出改采取 Action 的概率）。第二种预测在某个环境下所有行动
的期望价值，然后通过选择 q 值最高的行动执行策略。

他们都能完成决策，但由于建模的不同，估值网络包含有更多的信息，它不仅能提供决策，
还预测了决策带来的收益。

<font color=deeppink>策略网络是隐式的学习了某一 Action 所带来的全部获益（当前获
益+后续获益），而估值网络直接显示的学习 Action 所带来的全部获益。</font>强化学习
算法做出最佳抉择只需要知道哪个 Action 全部获益最大，策略网络就是这样做的，估值网
络不仅学习了哪个 Action 全部获益最大，还把每个 Action 的全部获益给计算出来了。

<font color=green>相对来说，策略网络的性能会比估值网络好一些。</font>

<font color=green>Value Based 方法适合仅有少量 Action 的环境，而 Policy Based 方
法更通用，适合 Action 种类非常多，或者具有连续取值的 Action 的环境。结合了深度学
习之后，Policy Based 方法就变成了策略网络，Value Based 方法就变成了估值网络
。</font>

#### 策略网络(Policy Network)

直接看一个例子，学习的目标是，左右用力使得木棍不倒地
[Policy_Network.py](https://github.com/xyegithub/myBlog/blob/main/posts/1e331e4a/policy_network.py)

关键代码

```python
score = tf.matmul(layer1,W2)
probability = tf.nn.sigmoid(score)#网络输出采取Action 1的概率。
input_y = tf.placeholder(tf.float32,[None,1], \\
name="input_y")# 输入采取过的行为，这个行为是随机生成的。
advantages = tf.placeholder(tf.float32,name="reward_signal")
# 输入获益
loglik = tf.log(input_y*(input_y - probability) + \\
(1 - input_y)*(input_y + probability))
# 损失函数，如果行为是1，则增大

#概率，如果行为是 0，则减小概率（相当于也是增加0的概率），也就是说这个损
#失函数无论当前行为是什么都会增大当前行为的概率。
loss = -tf.reduce_mean(loglik * advantages) # 这行代码很关键，
#相当于给损失函数成了一个权重advantages，得到最终的损失函数。
#advantages是当前试验的全部获益。如果全部获益大，将以更大的权重，增加
#当前行为的概率。

#所以，策略网络其实也是一个对抗学习的过程，增加所有采取过行为的概率，只是
#获益多的行为以更大的权重增加。

#一个试验： 由初始状态开始，随机采取一连串的行为
#（Policy_Network.py 中是根据当前模型输出的概率,来生成随机的行为，但
#是我感觉直接用0.5的概率随机生成一连串的0和1的行为也是可以的，下面将实
#验一下），直到任务结束。

## 由于每个试验，都可以一直行为到任务结束，所以每个action，我们都可以得
#到它在该试验中的全部获益（当前获益 + 之后所有行为的获益）

## 随机生成了n个试验，其中又各种各样的决策（随机探索），全部获益大的
#action，它的advantages也大，那么它的概率就增大的多，它被强化的厉害。

##试验生成的过程，实际上就是数据集构建的过程。策略网络的数据集是由环境
#和一系列随机的行为构成的。它提供了环境在各种行为下的反应（获益）。模型
#学习为环境带来高获益的行为的规律。
```

由上面的代码可知，从策略网络的角度看强化学习的话，强化学习的关键其实是对数据集的
构建---如何构建数据集。

在构建数据集的时候，随机探索肯定是必要的。随机探索的结果会得到一系列好的行为，也
会得到一系列不好的行为。如何强化好的行为就是算法设计的时候需要注意的。

上面的代码在探索阶段借用了当前的模型，即根据当前模型输出的概率随机生成行为，从而
形成数据集。如果完全的随机（一直使用 0.5 的概率随机的生成 Action）会什么样呢？

##### 数据集是否可以和模型无关（不随着模型变化）？

关键修改代码

```python
###基于当前模型，根据当前的状态x，生成Action 1的概率
tfprob = sess.run(probability,feed_dict={observations: x})
### 基于预测概率，随机生成行为，并试探环境。生成数据集。
action = 1 if np.random.uniform() < tfprob else 0
```

修改后

```python
### 注释掉这句，并不需要根据当前模型生成概率
### tfprob = sess.run(probability,feed_dict={observations: x})
### 直接设置概率为0.5，随机完全随机探索生成数据集。
tfprob = 0.5
action = 1 if np.random.uniform() < tfprob else 0
```

结果：修改后，模型无法收敛。

完全随机很小的概率能探索出很好的试验，这些好的行为也很难持续的得到强化。

所以，强化学习也有一种效果叠加的感觉。在完全随机的情况下 ，探索出相对好的
action，再在这个相对好的 action 的基础上，在探索探索出更好的 action。

如果数据集不依赖模型，就是一直在完全随机的基础上探索。这样很难收敛。

也可以这样看，完全随机的话，最多能学到前几步的策略（因为完全随机就走不了几步，探
索的经验就只有那几步）。依赖于模型，探索的行为更有价值，因为是依赖于学到过的知识
的，一方面确认了，按学到的知识走，确实获益多，一方面又在学到的知识的基础上，做了
一些随机，探索更好的知识。

#### 估值网络(Value Network，Q-learning)

Q-Learing 用神经网络实现，得到的模型就是估值网络。

也看一个例子
，[Value_Network.py](https://github.com/xyegithub/myBlog/blob/main/posts/1e331e4a/q_learning.py)

学习每个 Action 所对应的 reward 的期望。

我们先看看数据集的结构

```python
###Save the experience to our episode buffer.
episodeBuffer.add(np.reshape(np.array([s,a,r,s1,d]),[1,5]))
### 其中s是当前时刻的环境状态，a是当前随机采取的Action，r是这个Action的当前reward
### s1是采取Action之后的下一状态，d是布尔型表示是否任务结束。
```

1.  现在目标是学习 Q(s<sub>t</sub>, a<sub>t</sub>)，也就是当前环境状态，采取行为
    a 的全部 reward 的期望。

2.  现在假设我们有模型 Q<sub>desird</sub>，可以预测全部 reward 了，那么这个模型
    应该满足条件，Q<sub>desired</sub>(s<sub>t</sub>, a<sub>t</sub>) = r +
    $\lambda$ Max<sub>a</sub> Q<sub>desired</sub>(s<sub>t+1</sub>, a)，这有点递
    归的感觉了。

3.  现在我们能不能根据这个公式 ， 来优化出 Q<sub>desired</sub>。肯定是能的。对于
    探索过的所有试验，公式都满足的话，此时的模型就可以看成我们想要的模型了。我感
    觉这就是估值网络方法的核心。

直接看关键代码

```python
###Choose an action by greedily (with e chance of random action)
### from the Q-network
if np.random.rand(1) < e or total_steps < pre_train_steps:
a = np.random.randint(0,4)
else:
a = sess.run(mainQN.predict,feed_dict={mainQN.scalarInput:[s]})[0]
### 这段代码其实是探索的代码，当最开始的时候是完全随机探索（total_steps < pre_train_steps的时候）
### 当total_steps >= pre_train_steps之后呢，就不是完全随机探索了。
### 有e的概率是随机探索的，（1-e）的概率是由训练好的模型决定之后的Action。
### 这里是估值网络和策略网络的不同，策略网络本身就具有随机性，所以不需要引入
### 额外的参数e和pre_train_steps来控制随机探索的强度。
### 策略网络在训练的过程中，本身就是由随机性大，到慢慢的收敛到好的Action
### 所以可以直接得到好的探索的训练样本。估值网络没有这样好的性质，它连
### 随机性都没有，就需要人为的制造，满足从完全随机探索，到在好的Action的
### 基础上具有一定的随机性进行探索。
```

**这是策略网络和估值网络的共通之处，其实这也最上面那个注释"by greedily (with e
chance of random action) from the Q-network"的意思。**

**<font color=green>“贪心”两个字完美的诠释了强化学习，无论是策略网络还是估值网络
，在探索阶段，在生成数据集上的特点。</font>**

在策略网络那一节，我做的那个试验，和模型无关生成数据集。其实就是不贪心了，不贪心
不行。

```python
if total_steps > pre_train_steps:
if e > endE:
e -= stepDrop
### 完全随机了之后，开始慢慢减小随机性。
### 模型约不可靠的时候，探索性和随机性越强。后来模型慢慢变得可靠就减弱随机性。
### 因为模型越来越可靠的时候，随机性大就会得到很多远远低于当前模型性能的试验
### 这些试验都是早就被pass了的，学不到什么东西，损坏模型的探索。
### endE=0.1 说明无论训练的多好，模型都保持了随机性，保持了探索性
###　人永远要有好奇心，永远要觉得自己的知识还可能不是最好的
```

下面的代码是将在数据集弄好的情况下，如何训练模型的。

```python
if total_steps % (update_freq) == 0:
trainBatch = myBuffer.sample(batch_size) #Get a random batch of experiences.
#Below we perform the Double-DQN update to the target Q-values
# 主网络预测了下一刻需要采取的Action，trainBatch[:,3]是当前的下一刻的环境
# 回顾公式，Q(st, at) = r + $\lambda$ Max Q(s_t+1, a)
# 这里主函数预测的Action就是t+1时刻（下一时刻）获益值最大的Action
Q1 = sess.run(mainQN.predict,feed_dict={mainQN.scalarInput:np.vstack(trainBatch[:,3])})
# target网络预测了下一时刻的reward
Q2 = sess.run(targetQN.Qout,feed_dict={targetQN.scalarInput:np.vstack(trainBatch[:,3])})
end_multiplier = -(trainBatch[:,4] - 1)
# 用主网络预测出的Action以及target网络预测出的所有行为的reward
# 选择了最大的reward,也就是公式中的 Max Q(s_t+1, a)
doubleQ = Q2[range(batch_size),Q1]
# 这里得到的就是公式Q(st, at) = r + $\lambda$ Max Q(s_t+1, a)
# 的右边，当前reward加上乘以衰减系数之后的，下一步最大reward
targetQ = trainBatch[:,2] + (y*doubleQ * end_multiplier)
#Update the network with our target values.
# 公式右边得到了之后，在把真正的当前状态输入进去，得到左边
# 左边以右边作为标签进行学习。更新主网络的参数
_ = sess.run(mainQN.updateModel, \
feed_dict={mainQN.scalarInput:np.vstack(trainBatch[:,0]),mainQN.targetQ:targetQ, mainQN.actions:trainBatch[:,1]})
# 更新target网络的参数。
updateTarget(targetOps,sess) #Update the target network toward the primary network.
```

target 网络参数的更新方式代码

````python
def updateTargetGraph(tfVars,tau):
total_vars = len(tfVars)
op_holder = []
# 主网络是和target网络一样的，前一半参数正好是主网络的参数
for idx,var in enumerate(tfVars[0:total_vars//2]):
# idx+total_vars对应的时候后一半的参数也就是target网络的参数
# 这里相当于是target参数 = 主网络参数 * tau + （1- tau）*target参数
# 也就是说target网络在以一定的速度向主网络靠近
# 结合前面的代码，主网络才是真正学习的网络，target网络的作用仅仅是得到等式
# 右边的值，即标签，即使是等式右边，也不是target网络完全决定的
# target网络得到了所有Action的reward，最大的Action是主网络选择的
# 为什么要这么做，target网络也是在模仿主网络，只用主网络也能得到等式的右边
# 理论上其实右边也应该是主网络决定，现在搞了个主网络的模仿者target网络
# 是出于优化的考虑。我们后面叙述。
op_holder.append(tfVars[idx+total_vars//2].assign\\
((var.value()*tau) \\
                      + ((1-tau)*tfVars[idx+total_vars//2].value())))
                      return op_holder

                      def updateTarget(op_holder,sess):
                      for op in op_holder:
                      sess.run(op)

                      ```

                      现在其实我们把关键的代码都看了，在这段代码实现中，引入了一些state of the art的trick，下面我们结合看过的代码在提一遍。

                      1.  引入卷积层，这段代码比较简单，我们没有看。环境状态是用图片的形式给的，用CNN提取特征是比较自然的。
                      2.  Experience replay。估值网络不像策略网络一样得到试验之后，用一次就扔掉再去制作新的试验（数据集）来训练。它把每次试验都放在一个试验池里面。试验池长度为N，如果超过了N，那就把最老的试验样本扔掉。每次 训练的时候从试验池里面随机选择batchsize个样本进行训练，保持了对样本的利用率，同时其实也增加了模型的稳定性，因为数据集是相对稳定的（相比于N=1而言，每次训练了就扔掉，进来的都是新的，不那么稳定）。
                      3.  使用target网络来辅助训练。\*\*之所以要用target网络来制造训练目标，用主网络来实际训练，是为了让Q-Learing训练的目标保持平稳。\*\*强化学习不像普通的监督学习，它的目标是变化的，\*\*因为学习目标的一部分就是模型本身输出的。\*\*每次更新模型参数都会导致学习目标发生变化，如果更新频繁，幅度很大，我们的训练过程就会变得非常不稳定并且失控。\*\*DQN的训练会陷入目标Q与预测Q的反馈循环中，震荡发散。\*\*所以用target网络来制造目标，target网络和主网络又不是矛盾的，因为target网络会逼近主网络，它是主网络的模仿者，所以它提供的目标Q也是有权威的。
                      4.  Double DQN。这个trick源于target网络选的最大Action不准。模仿的不够好，现在就让主网络来帮它选。也就是上面代码中我们看过了主网络输出action，选择target网络输出的reward，得到公式的右边。
                      5.  Dueling DQN。上代码

                      ```python
                      self.AW = tf.Variable(xavier_init([h_size//2,env.actions]))
                      self.VW = tf.Variable(xavier_init([h_size//2,1]))
                      self.Advantage = tf.matmul(self.streamA,self.AW)
                      self.Value = tf.matmul(self.streamV,self.VW)

###Then combine them together to get our final Q-values.
### 看这里Qout是网络最终预测的所有Action的reward。它由两部分组成Value和Advantage
### 由最上面两行可以看出Value是一维的，是实数，advantage是#action维度的向量
### 所以，Dueling DQN就是将reward裁成了两部分，一部分是环境状态本身具有的价值Value
### 另一部分就是Action本身具有的价值，相加起来就是在这个环境下Action具有的价值。
### 其实我感觉这些解释都是人为的，具体是不是这样谁也不知道，可能只是这样优化的好。
###　因为即使不分为两部分，网络输出Ｑout的时候，输入也是环境状态，肯定都会把环境考虑
### 进去才有Action的价值。然而直接输出这个价值，发现优化的不好，分为两部分之后，发现
### 优化的好了。其实谁也不知道其中到底是什么原因起作用。
self.Qout = self.Value + tf.subtract(self.Advantage,tf.reduce_mean(self.Advantage,axis=1,keep_dims=True))

````

#### 策略网络和估值网络的不同

从策略网络和估值网络看，强化学习都有探索和对抗两个过程。通过探索，得到数据集，包
含了各种可能性。通过对抗，让数据集中好的（reward 高的试验胜出）。他们的不同点在
于对抗的方法。

1.  策略网络：对抗的焦点在于选择 Action 的概率。
2.  估值网络：对抗的焦点在于评估 Action 的 reward。
3.  两者都会影响数据集的制作，而且影响的方式是相同的：贪心和随机探索
4.  比起策略网络，估值网络更加没有对抗的感觉。因为策略网络在提高某一个 Action 的
    概率的时候，会抑制其他 Action 的概率（总的概率为 1）。而估值网络在提高某一个
    Action 的 reward 的时候，和其他 Action 是无关的。**而且其实不能说是提高
    reward，它是预测出正确的 reward。**（这是两者的很大的不同处，策略网络更像是
    一个分类问题，而估值网络像是一个回归问题）

### 回顾

强化学习的本质是连续决策。强化学习算法的关键是标签制作，数据集制作。

连续决策问题是没有确定的标签的，它通过探索试验得到数据集和标签，为没有提供标签的
问题，做了标签，让问题可以解决。

深度学习无法优化离散的不可导的参数，强化学习也可以通过在离散的地方做数据集做标签
，把它转换为可导的，可用 sgd 优化的问题。

做标签和数据集的关键是随机性以及贪心，贪心让它立足于以往的知识，随机让它不刚愎自
用，保持谦卑，给新的可能保留空间。

无论是策略网络还是估值网络，在数据集的制作上都是一样的，随机性和贪心。估值网络的
数据集制作，可以看出强化学习探索的本质（由于估值网络本身没有随机性，它在制作数据
集的时候，显示的暴露了，探索和贪心的本质。策略网络这方面还不太好看出来，因为它是
隐式的利用探索和贪心）。

策略网络，增大所有行为的概率，但是对于 reward 大 的行为增大的权重大。这个思路在
我得感觉上更加符合强化两个字。强化好的行为嘛。

估值网络的本质是公式 Q<sub>desired</sub>(s<sub>t</sub>, a<sub>t</sub>) = r +
$\lambda$ Max<sub>a</sub> Q<sub>desired</sub>(s<sub>t+1</sub>, a)，有点递归的感
觉。

策略网络和估值网络数据集也有一点不同，策略网络的数据集是纵向的，一串行为一起的。
而估值网络的数据集是单个单个的。

由下面代码可以看出，策略网络中，每一窜试验就会训练一次，只是网络参数更新会积累了
好几次试验之后才更新。策略网络关心从开始到结束一系列行为。而估值网络只关心当前和
下一状态。

```python
if done:
episode_number += 1
epx = np.vstack(xs)
epy = np.vstack(ys)
epr = np.vstack(drs)
tfp = tfps
xs,hs,dlogps,drs,ys,tfps = [],[],[],[],[],[]

discounted_epr = discount_rewards(epr)
discounted_epr -= np.mean(discounted_epr)
discounted_epr //= np.std(discounted_epr)

tGrad = sess.run(newGrads,feed_dict={observations: epx, input_y: epy, advantages: discounted_epr})
for ix,grad in enumerate(tGrad):
gradBuffer[ix] += grad

if episode_number % batch_size == 0:
sess.run(updateGrads,feed_dict={W1Grad: gradBuffer[0],W1_1Grad:gradBuffer[1],W2Grad:gradBuffer[2]})
```

估值网络人为的控制随机强度，也是一个值得考虑的问题。
