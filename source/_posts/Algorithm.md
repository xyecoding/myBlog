---
title: Algorithm
top: false
cover: false
toc: true
mathjax: true
description: 遇到过精巧的算法设计
categories:
  - Programming
  - Algorithm
tags:
  - Algorithm
  - Programming
abbrlink: 17f44e1a
date: 2021-12-17 16:26:10
password:
summary:
---

# Backtrack

We can cope with only simple tasks. But there is only a complex task.

If we can transfer it into a relative simpler one, do it again and again till we
can cope with it.

When transfer, the simpler task may have some relationship with the complex one,
e.g., the complex task gives some restrictions to to the simpler one.

## N-Queens II <font color=magenta>[2022-06-20]</font>

[Hard](https://leetcode.cn/problems/n-queens-ii/)

```python
class Solution:
    def totalNQueens(self, n: int) -> int:
        def backtrack(row: int) -> int:
            # fill the row
            # two kinds of return

            # when row == n, the last row (n - 1) is filled
            # thus it must be only 1 solution to reach here so return 1

            # if row < n - 1, the solution there is may be multiple solutions
            # clear the count (count = 0), then find the number of solutions
            # and return it

            # thus this function calculates the number of  solutions when the first
            # row - 1 rows is filled, how they are filled are recorded by columns,
            # diagonal1 and giagonal2

            # two key points:
            # 1. How the backtrack end: that is the condition return 1
            # 2. How to transfer the task to a smaller one, that is else.

            # we can crop it if  and only if row == n, thus we only need
            # to transfer the task to a simpler one till we can crop it
            if row == n:
                return 1
            else:
                count = 0
                for i in range(n):
                    # i is the columns if it is used continue
                    # two position A and B, if their row -/+ i is the same number
                    # they are in one diagonal then continue
                    if i in columns or row - i in diagonal1 or row + i in diagonal2:
                        continue
                    columns.add(i)
                    diagonal1.add(row - i)
                    diagonal2.add(row + i)
                    count += backtrack(row + 1)
                    columns.remove(i)
                    diagonal1.remove(row - i)
                    diagonal2.remove(row + i)
                return count

        columns = set()
        diagonal1 = set()
        diagonal2 = set()
        return backtrack(0)
```

# Wide First Search

## Count Complete Tree Nodes <font color=magenta>[2022-07-01]</font>

[Medium](https://leetcode.cn/problems/count-complete-tree-nodes/)

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def countNodes(self, root: TreeNode) -> int:
        res = [1, 0]

        def wide_first_search(cur_nodes):
            res[0] += 1
            nex_nodes = []
            flag = True

            for i in cur_nodes:
                if i.left and i.right:
                    nex_nodes.append(i.left)
                    nex_nodes.append(i.right)
                else:
                    flag = False
                    res[1] = len(nex_nodes)
                    if i.left or i.right:
                        res[1] += 1
                    break
            if flag:
                wide_first_search(nex_nodes)

        if  not root:
            return 0
        wide_first_search([root])
        return 2 ** (res[0] - 1) -1 + res[1]
```

# Depth First Search

## Closest Dessert Cost <font color=magenta>[2022-06-30]</font>

[Medium](https://leetcode.cn/problems/closest-dessert-cost/)

```python
class Solution:
    def closestCost(self, baseCosts: List[int], toppingCosts: List[int], target: int) -> int:
        baseCosts.sort()
        toppingCosts.sort()
        res = []
        cost = 0
        def check_cost(cost):
            if not res:
                min_distance = float('inf')
            else:
                min_distance = abs(target - res[-1])
            distance = abs(target - cost)
            if distance < min_distance:
                res.clear()
                res.append(cost)
            if distance == min_distance:
                res.append(cost)
        def choose_cur(j, cost):
            if j == len(toppingCosts):
                return
            price = toppingCosts[j]
            choose_cur(j + 1, cost)

            check_cost(cost + price)
            choose_cur(j + 1, cost + price)

            check_cost(cost + 2 * price)
            choose_cur(j + 1, cost + 2 * price)

        for i in baseCosts:
            cost = i
            check_cost(cost)
            choose_cur(0, cost)
        return min(res)
```

## Find All Possible Recipes from Given Supplies <font color=magenta>[2022-06-24]</font>

[Medium](https://leetcode.cn/problems/find-all-possible-recipes-from-given-supplies/)

```python
class Solution:
    def findAllRecipes(self, recipes: List[str], ingredients: List[List[str]], supplies: List[str]) -> List[str]:
        res = []
        def remove_cur(cur_supplies):
            nex_supplies = set()
            for i, cur_ingredients in enumerate(ingredients):
                if cur_ingredients:
                   # Be careful. How to remove items in a loop
                    # https://segmentfault.com/a/1190000007214571
                    cur_ingredients = list(filter(lambda x: x not in cur_supplies, cur_ingredients))
                    ingredients[i] = cur_ingredients
                    if not cur_ingredients:
                        nex_supplies.add(recipes[i])
                        res.append(recipes[i])
                        recipes[i] = None
                        ingredients[i] = None
            return nex_supplies

        supplies = set(supplies)
        while supplies:
            supplies = remove_cur(supplies)
        return res
```

## Longest Increasing Path in a Matrix

Given an $m \times n$ integers matrix, return the length of the longest
increasing path in matrix.

Move direction: left, right, up, or down.

```python
class Solution:

    DIRS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    def longestIncreasingPath(self, matrix: List[List[int]]) -> int:
        if not matrix:
            return 0

        @lru_cache(None) # save  the storage
        def find_max(i, j):
        # find the next value and try the four directions
        # return the longest direction.
            max_ = 1
            for dr in Solution.DIRS:
                try_i = i + dr[0]
                try_j = j + dr[1]
                # the direction will be discarded if do not meet the condition
                # and a direction meet the condition will be searched for the next
                # value first.
                if 0 <= try_i and try_i < n and 0<= try_j and try_j < m and \
                matrix[i][j] < matrix[try_i][try_j]:
                    max_ = max(max_, find_max(try_i, try_j) + 1)
                    # The value is increasing, so by setting `matrix[i][j] \
                    # < matrix[try_i][try_j]`, a searched position will never
                    # be searched again.
            return max_

        n, m = len(matrix), len(matrix[0])
        res = 0
        for i in range(n):
            for j in  range(m):
                res = max(res, find_max(i, j))
        return res

```

## Keyboard

A keyboard only have 26 keys, `a~z`. Each key can be only typed `k` times at
most.

How many possible content there is, when the keyboard is typed `n` times?

### Method 1: dfs

```python
 class Solution:
    # depth first search: from the first letter to the last letter
    # fill the n positions.
    def keyboard(self, k: int, n: int) -> int:
        MOD = 1000000007

        # c is the number of remain letters
        # n is the number of letters needed to type in
        # k is the max number that each letter can type
        @lru_cache(None)
        def dfs(c, n, k):
            if n == 0:
                # no letters is needed any more
                # only 1 way: type nothing
                # pick 0 letters
                return 1
            if c <= 0:
                # no letter remained but n is not 0
                # this is a failed type scheme
                return 0
            res = 0
            for i in range(0, min(n, k) + 1):
            # there are math.comb(n, i) ways to put i letters
            # into n position.
                res += math.comb(n, i) * dfs(c-1, n - i, k) % MOD
            return res % MOD
        ans = dfs(26, n, k)
        return ans % MOD
```

### Method 2: dynamic programming

```python
class Solution:
    def keyboard(self, k: int, n: int) -> int:
        MOD = 1000000007
        res = [[0 for _ in range(27)] for _ in range(n + 1)]
        # res[i][j] is the number of possibilities when first j letters
        # is used to fill i positions.
        # when the position is 0, no matter how many letters are used.
        # there is only one possibility, i.e., filling nothing.
        # thus, res[0][i] are all 1.
        res[0][0] = 1
        for i in range(27):
            res[0][i] = 1

        # res[i][j] can be divided into several possibilities.
        # When 0 letter is filled for the $j^{th}$ letter, res[i][j-1]
        # when 1 letter is filled for the j-th letter, res[i-1][j-1]
        # * C_i^1
        # when 2 letters are filled for the j-th letter, res[i-2][j-1]
        # * C_i^2
        # C_i^m represent how many possibilities there are filling m of
        # the same letters into i positions.
        # m can be 0, but can not be larger than k or i.
        for i in range(1, n + 1):
            for j in range(1, 27):
                for m in range(min(i + 1, k + 1)):
                    res[i][j] += res[i - m][j - 1] * math.comb(i, m)
                    res[i][j] %= MOD

        return res[-1][-1] % MOD
```

# Dynamic Programming

## Find Two Non-overlapping Sub-arrays Each With Target Sum <font color=magenta>[2022-07-07]</font>

[Medium](https://leetcode.cn/problems/find-two-non-overlapping-sub-arrays-each-with-target-sum/)

```python
class Solution:
    def minSumOfLengths(self, arr: List[int], target: int) -> int:
        n = len(arr)
        res = n + 1

        pre = {}

        # make sure the sub array start from 0 can be visited
        pre[0] = -1
        dp = [float('inf')] * n

        p = 0
        for i, a in enumerate(arr):
            # p is the sum from idex 0 to i
            p += a
            dp[i] = dp[i - 1]

            # if p - target in pre then target = p - pre which is a sub array
            # the sum eqaul to target
            if (p - target) in pre:
                cur = i - pre[p - target]
                # dp[pre[p - target]] != float if and only if there are sub
                # array whose sum eqauls to the target, and it can not connect
                # with cur sub array because current sub array is from index
                # pre[p - target]
                # Note that: this can find all the possible pairs of sub
                # arrays
                if pre[p - target] >= 0 and dp[pre[p - target]] != float('inf'):
                    res = min(res, cur + dp[pre[p - target]])
                # dp does not equal to inf anymore, only if there are sub
                # array whose sum equals to the target
                dp[i] = min(i - pre[p - target], dp[i - 1])

            # the sum from index 0 to i is p
            pre[p] = i
        return -1 if res == n + 1 else res
```

## Minimum One Bit Operations to Make Integers Zero <font color=magenta>[2022-06-27]</font>

[Really Hard](https://leetcode.cn/problems/minimum-one-bit-operations-to-make-integers-zero/)

```python
class Solution:
    def minimumOneBitOperations(self, n):
        dp1 = [0 for _ in range(32)]
    #dp1[i] 表示 仅第 i 位 为 1 时 将 第 i 位变为 0 的最小修改次数
        res = 0
        dp1[0] = 1
        for i  in range(1,32):
            dp1[i] = dp1[i - 1] + 1 + dp1[i - 1]
        f = True
        # 1. 0 变位仅i位为1的过程中，其后每一位都需要经历若干次从0到1,再从1到0的变化
        # 2. 其后位中若原本就为1,则不会经历第一次从0到1的变化，因为它本身就是1
        # 所以若把第i位从1变为0,记为dp[i]，是多记录了，因为其后有1
        # 所以如果其后遇到1的要减去。但是减去的话又多减了，因为其后还有1,所以又加上
        for i in range(31, -1, -1):
            if n >> i & 1:
                if f:
                    res += dp1[i]
                    f = False
                else:
                    res -= dp1[i]
                    f = True
        return res
```

## The number of palindromes

Given a string return the number of the palindromes. The substrings are regarded
as different strings if they are start and end at different position.

```python
class Solution:
    def countSubstrings(self, s: str) -> int:
        n = len(s)
        res = [[False for _ in range(n)] for _ in range(n)]
        # if n == 0, there are 0 palindromes.
        # if n == 1, there are 1 palindromes.
        if not n or n == 1:
            return n
        ans = n

        for i in range(n):
            res[0][i] = True

        for i in range(n - 1):
            res[1][i] = s[i] == s[i + 1]
            if res[1][i]:
                ans += 1
# if n == 2 it will not enter the following circle.
# if n > 2 it will contnue to caculate palindromes whose length is larger than 2
        for l in range(2, n):
            for st in range(n - l):
                res[l][st] = res[l - 2][st + 1] and s[st] == s[st + l]
                if res[l][st]:
                    ans += 1
        return ans
```

## Knight Dialer

The topic is [here](https://leetcode-cn.com/problems/knight-dialer/).

```python
class Solution(object):
    def knightDialer(self, N):
        MOD = 10**9 + 7
        # From 0 can reach 4 and 6
        # From 1 can reach 6 and 8
        moves = [[4,6],[6,8],[7,9],[4,8],[3,9,0],[],
                     [1,7,0],[2,6],[1,3],[2,4]]

        # There is dp[i]==1 ways to reach i by one step
        dp = [1] * 10
        for hops in range(N-1):
            dp2 = [0] * 10
            for node, count in enumerate(dp):
              # There are count way to reach node by hops + 1 steps
                for nei in moves[node]:
                    dp2[nei] += count
                    dp2[nei] %= MOD
              # There are dp2[nei] way to reach nei by hops + 2 steps
            dp = dp2
        return sum(dp) % MOD
```

# Linked List

## Partition List LCCI <font color=magenta>[2022-07-15]</font>

[Medium](https://leetcode.cn/problems/partition-list-lcci/)

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def partition(self, head: ListNode, x: int) -> ListNode:
        small_head = ListNode(None)
        large_head = ListNode(None)
        small_cur = small_head
        large_cur = large_head

        while head:
            if head.val < x:
                small_cur.next = head
                small_cur = head
            else:
                large_cur.next = head
                large_cur = head

            head = head.next

        large_cur.next = None
        small_cur.next = large_head.next
        return small_head.next
```

## Find The Minimum and Maximum Number of Nodes Between Critical Points <font color=magenta>[2022-06-18]</font>

[Medium](https://leetcode.cn/problems/find-the-minimum-and-maximum-number-of-nodes-between-critical-points/)

```python
class Solution:
    def nodesBetweenCriticalPoints(self, head: Optional[ListNode]) -> List[int]:
        import numpy as np
        cur = head
        left_sign = 0
        pre_idx = None
        start_idx = None
        min_distance = float('inf')
        idx = 0

        while cur.next:
            right_sign = np.sign(cur.next.val - cur.val)
            if left_sign * right_sign == -1:
                if not start_idx:
                    start_idx = idx
                if pre_idx and idx - pre_idx < min_distance:
                    min_distance = idx - pre_idx

                pre_idx = idx
            cur = cur.next
            left_sign = right_sign
            idx += 1

        if pre_idx != start_idx:
            return [min_distance, pre_idx - start_idx]
        return [-1, -1]
```

## Reverse a Linked List <font color=magenta>[2022-06-16]</font>

```python
class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if not head or not head.next:
            return head
        cur = head.next
        start = head
        # head is the last node
        start.next = None
        while cur:
            next_cur = cur.next
            cur.next = start
            start = cur
            cur = next_cur
        return start
```

## Reverse Nodes in K-Group <font color=magenta>[2022-06-10]</font>

Given the head of a linked list, reverse the nodes of the list `k` at a time and
return the modified list.

Python

```python
class Solution:
      # reverse a link node, the length is k
    def reverse(self, head: ListNode, tail: ListNode, k):
        current = head
        crop = head.next
        for i in range(k - 1):
            follow = crop.next
            crop.next = current
            current = crop
            crop = follow
        return current, head


    def reverseKGroup(self, head: ListNode, k: int) -> ListNode:
        dump = ListNode(0)
        dump.next = head

        current = dump
        end = current

# while the end has next, check if it has k nodes followed
        while end.next:
            start = end.next
            # check if followed k nodes
            for i in range(k):
                end = end.next
                 # do not have k nodes followed, then do not reverse
                 # and also the link node have been done, and return.
                if not end:
                    return dump.next

# if have k nodes followed
            follow = end.next
             # reverse the k nodes and return the reversed start and end
            r_start, r_end = self.reverse(start, end, k)
             # connect the reversed k nodes with the original nodes
            current.next = r_start
            r_end.next = follow
            current = r_end
            end = current
            # the length of the link node is a multiple of k, and end.next is None, return
        return dump.next
```

c++

```c++
class Solution {
public:
    // 翻转一个子链表，并且返回新的头与尾
    pair<ListNode*, ListNode*> myReverse(ListNode* head, ListNode* tail) {
        ListNode* prev = tail->next;
        ListNode* p = head;
        while (prev != tail) {
            ListNode* nex = p->next;
            p->next = prev;
            prev = p;
            p = nex;
        }
        return {tail, head};
    }

    ListNode* reverseKGroup(ListNode* head, int k) {
        ListNode* hair = new ListNode(0);
        hair->next = head;
        ListNode* pre = hair;

        while (head) {
            ListNode* tail = pre;
            // 查看剩余部分长度是否大于等于 k
            for (int i = 0; i < k; ++i) {
                tail = tail->next;
                if (!tail) {
                    return hair->next;
                }
            }
            ListNode* nex = tail->next;
            // 这里是 C++17 的写法，也可以写成
            // pair<ListNode*, ListNode*> result = myReverse(head, tail);
            // head = result.first;
            // tail = result.second;
            tie(head, tail) = myReverse(head, tail);
            // 把子链表重新接回原链表
            pre->next = head;
            tail->next = nex;
            pre = tail;
            head = tail->next;
        }

        return hair->next;
    }
};

```

## Palindrome Linked List

Given the `head` of a singly linked list, return `true` if it is a Palindrome.

```python
class Solution:
    def isPalindrome(self, head: ListNode) -> bool:
        res = []
        if not head:
            return True
        num = 0
        first = head
        while first.next:
            res.append(first.val)
            num += 1 # count the length of the linked list
            first = first.next
        res.append(first.val) # store all the node value
        for i in range(num // 2 + 1): # does not need to check all the nodes
            if res[i] != res[num - i]:
                return False
        return True
```

If one want only use O(n) time and O(1) storage, must reverse the last half of
the linked list.

```python
class Solution:
    def isPalindrome(self, head: ListNode) -> bool:
        if not head or not head.next:
            return True
        def find_the_middle(node):
            slow = node
            fast = node
            while fast.next and fast.next.next:
                slow = slow.next
                fast = fast.next.next
            second_start = slow.next
            slow.next = None
            return second_start
        second_start = find_the_middle(head)
        def reverse(node):
            start = node
            pre = node.next
            start.next = None
            while pre:
                cur = pre
                pre = pre.next
                cur.next = start
                start = cur
            return start
        new_start = reverse(second_start)
        while head and new_start:
            if head.val != new_start.val:
                return False
            head = head.next
            new_start = new_start.next
        return True
```

# String

## Strong Password Checker II <font color=magenta>[2022-06-22]</font>

[Simple](https://leetcode.cn/problems/strong-password-checker-ii/)

```python
class Solution:
    def strongPasswordCheckerII(self, password: str) -> bool:
        n = len(password)

        if_length = n >= 8

        contain_lower = False
        contain_upper = False
        contain_number = False
        contain_special = False
        contain_twosame = False

        special = set("!@#$%^&*()-+")
        pre_char = ''
        for i in password:
            if i == pre_char:
                contain_twosame = True
            pre_char = i
            if not contain_lower and i.islower():
                contain_lower = True
                continue
            if not contain_upper and i.isupper():
                contain_upper = True
                continue
            if not contain_number and i.isdigit():
                contain_number = True
                continue
            if not contain_special and i in special:
                contain_special = True
                continue
        return if_length and contain_lower and contain_upper and contain_number and contain_special and not contain_twosame
```

## Minimum Changes to Make Alternating Binary String

You are given a string `s` consisting only of the characters `0` and `1`. In one
operation, you can change any `0` to `1` or vice versa.

The string is called alternating if no two adjacent characters are equal. Return
the minimum number of operations needed to make `s` alternating.

```python
class Solution:
    def minOperations(self, s: str) -> int:
        n = len(s)
        # The ans is the operation needed to turn s into `010101`
        ans = 0
        for i in range(n):
            if i % 2 and s[i] != "1":
              ans += 1
            if not i % 2 and s[i] != "0":
                ans += 1
        return min(ans, n - ans)
```

# Sort

## Relative Rank <font color=magenta>[2022-06-28]</font>

[Simple](https://leetcode.cn/problems/relative-ranks/)

```python
class Solution:
    def findRelativeRanks(self, score: List[int]) -> List[str]:
        n = len(score)
        dic = {
            0 : 'Gold Medal',
            1 : 'Silver Medal',
            2 : 'Bronze Medal',
            }
        res = sorted(range(n), key = lambda x : score[x], reverse = True)
        for i in range(n):
            if i in dic:
                score[res[i]] = dic[i]
            else:
                score[res[i]] = str(i + 1)
        return score
```

## Sort Integers by the Number of 1 Bits <font color=magenta>[2022-06-16]</font>

[here](https://leetcode.cn/problems/sort-integers-by-the-number-of-1-bits/)

```python
class Solution:
    def sortByBits(self, arr: List[int]) -> List[int]:
        res = []
        for i in arr:
            c = 0
            for s in bin(i):
                if s == '1':
                    c += 1

            res.append([c, i])
        res.sort()
        return [a[1] for a in res]
```

```python
from collections import defaultdict as d

class Solution:
    def sortByBits(self, arr: List[int]) -> List[int]:
        dic = d(list)

        for i in arr:
            c = 0
            for s in str(bin(i)):
                if s == "1":
                    c += 1
            dic[c].append(i)

        output = []
# The range of integer is less than 0b111111111111111.
        for j in range(15):
            if dic[j]:
                for temp in sorted(dic[j]):
                    output.append(temp)

        return output
```

## K Highest Ranked Items Within a Price Range <font color=magenta>[2022-06-13]</font>

The topic is
[here](https://leetcode.cn/problems/k-highest-ranked-items-within-a-price-range/).

```python
class Solution:
    def highestRankedKItems(self, grid: List[List[int]], pricing: List[int], start: List[int], k: int) -> List[List[int]]:
        res = []

        curs = [
            [0, grid[start[0]][start[1]], start[0], start[1]]
            ]

# gird set to 0 is to avoid visiting a coordinate for multiple time.
# The position to set the grid to be 0 is important.
# in  this example, the price of a coordinate is set to 0 when it is visited by curs.
# also can set the price to be 0, when it is checked if within the price range.
# However, this is time expensive, for a position maybe append to curs many times before it is checked.
# It is the best to set the price to be 0, once it is visited by curs. The curs will not visits it again.
        grid[start[0]][start[1]] = 0

        r = len(grid)
        c = len(grid[0])

        dirctions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

        while curs:
            cur = curs.pop(0)
            cur_step = cur[0]
            cur_price = cur[1]
            cur_row = cur[2]
            cur_cln = cur[3]

            if pricing[0] <= cur_price <= pricing[1]:
               res.append(cur)

            for dirction in dirctions:
                next_step = cur_step + 1
                next_row = cur_row + dirction[0]
                next_cln = cur_cln + dirction[1]
                if 0 <= next_row < r and 0 <= next_cln < c:
                    next_price = grid[next_row][next_cln]
                    grid[next_row][next_cln] = 0
                    if next_price > 0:
                        curs.append([next_step, next_price,next_row, next_cln])

        res.sort()
        return [res[2:] for res in res[:k]]
```

## Wiggle Sort 2

Given an integer array `nums`, recorder it such that
`nums[0] < nums[1] > nums[2] < nums[3] > ...`. You may assume the input array
always has a valid answer.

```python
class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        res = []
        for i in nums:
            res.append(i)
        res.sort()
        n = len(nums)
        # Because the smaller number is always filled first,
        # let len(smaller numbers) - len(larger numbers) == 1
        # if the len(nums) is odd.
        # if n is even, the small half from 0 to n // 2 - 1
        # the large half from n // 2 to n - 1
        # if n is odd, small number from 0 to n // 2
        # large number from n // 2 + 1 to n - 1,
        # Thus, no matter n is odd or even, small number from 0 to
        # (n + 1) // 2 - 1, large number from (n + 1) // 2 to n - 1
        half = (n + 1) // 2
        # to avoid that the last small number is equal to the first large
        # number, fill the small number from *last* to first,
        # also, fill the large number from last to *first*
        # ** means that the number should try to be apart.

        # if n is even, half * 2 == n
        # if n is odd, half * 2 == n + 1
        for i in range(half):
            nums[2 * i] = res[half - 1 -i]
            # len(large number) is smaller than len(small number),
            # thus, the when i = half -1, maybe no large number anymore
            try:
                nums[2 * i + 1] = res[n - 1 - i]
            except:
                pass
```

## Rank Teams by Votes

In a special ranking system, each voter gives a rank from highest to lowest to
all teams participated in the competition, e.g., one gives `ABC`, one gives
`BCA`.

The ordering of teams is decided by who received the most position-one votes. If
`A` received the most 1-st place Then `A` is the first. If `B` received the same
first place as `A` then compare the number of second place they received. If `A`
and `B` received all the places the same number then ordered them by their
letter, i.e., `A` is in front of `B`.

```python
class Solution:
    def rankTeams(self, votes: List[str]) -> str:
        n = len(votes[0])
        # initialization of a hash map, the default value is list [0, 0, ..., 0]
        # NOTE: How to set defaultdict by lambda without input, it is indeed a function factory.
        ranking = collections.defaultdict(lambda: [0] * n)
         # count the vote situation for each team, vid is the name of teams.
        for vote in votes:
            for i, vid in enumerate(vote):
                ranking[vid][i] += 1

        # result is a list, e.g., [('A', [5, 0, 0]), ('B', [0, 2, 3]), ('C', [0, 3, 2])]
        result = list(ranking.items())
        # sort the order of letter -ord(x[0]) is regard as the last criterion
        result.sort(key=lambda x: (x[1], -ord(x[0])), reverse=True)
        # return the ordered vid
        return "".join([vid for vid, rank in result])
```

## Number Game

Give a list of numbers. You can `+ 1` or `- 1` at position `i` which is regarded
as one operator at position `i`. Please return the minimum operators for
position `i` to make the list of numbers satisfying
`nums[a] + 1 == nums[a + 1], 0 <= a <= i`. The original topic is
[here](https://leetcode.cn/problems/5TxKeK/).

### Analysis

To satisfying `nums[a] + 1 == nums[a + 1]`, we do not know which number it is
for position `i` which makes the operators minimum.

Thus we can transform this problem, we make `nums[a] = nums[a] - a`. Then we
only need to make each position of the `nums` all equal to the same number. Then
the minimum way is to set the number as the median number of `nums`.

<font color=red>NOTE:</font> it is the median number, not the mean value. If the
length of the list is even then the median is the mean of the middle two
numbers.

It is easy to prove that the mean value can not bring the minimum operators. For
examples, for list `[1, 3, 8]` the mean value is `4` and it needs
`3 + 1 + 4 = 8` operators to make the list into `[4, 4, 4]`. The median is `3`
and it needs only `2 + 0 + 5 = 7` operators to make the list into `[3, 3, 3]`.

<font color=blue>The reason for why it is the median.</font>

Let `s` be the value that each position will reach and `m` be the median. If `s`
is large than `m`, then `#(nums[i] > s) < #(nums[i] < s)`. If set `s = s - 1`,
`nums[i]` will add `1` operator if `nums[i] > s` and `nums[i]` will decrease `1`
operator if `nums[i] < s`. For `#(nums[i] > s) < #(nums[i] < s)`, the total
number of operators will decrease. It will always decrease until `s == m`, i.e.,
`#(nums[i] > s) = #(nums[i] < s)`.

```python
from typing import List
from heapq import heappush, heappushpop


class MedianFinder:
    def __init__(self):
        self.small = []  # 大顶堆
        self.large = []  # 小顶堆
        self.leftSum = 0
        self.rightSum = 0

    def add(self, num: int) -> None:
        # if #small == #large then put the num in large
        # How to push it in large.
        # NOTE: not put it in large directly, find the largest value then put it in to the large.
        # This ensure that large is always larger than small.
        # #small always smaller than #large and only larger than 1
        if len(self.small) == len(self.large):
            leftMax = -heappushpop(self.small, -num)
            heappush(self.large, leftMax)
            self.leftSum += num - leftMax
            self.rightSum += leftMax
        elif len(self.small) < len(self.large):
            rightMin = heappushpop(self.large, num)
            heappush(self.small, -rightMin)
            self.leftSum += rightMin
            self.rightSum += num - rightMin

    def getMedian(self) -> float:
     # self.large[0] is the smallest value in large
     # -self.small[0] is the largest value in small
     # get the median if the length is odd, else the mean of the two middle numbers
        if len(self.small) == len(self.large):
            return (self.large[0] - self.small[0]) / 2
        else:
            return self.large[0]

    def getDiffSum(self) -> float:
        median = self.getMedian()
        return self.rightSum - len(self.large) * median + len(self.small) * median - self.leftSum


class Solution:
    def numsGame(self, nums: List[int]) -> List[int]:
        MOD = int(1e9 + 7)
        res = []
        medianFinder = MedianFinder()
        for i in range(len(nums)):
            normalized = nums[i] - i
            medianFinder.add(normalized)
            res.append(int(medianFinder.getDiffSum() % MOD))
        return res
```

# Dichotomy

## Minimum Garden Perimeter to Collect Enough Apples <font color=magenta>[2022-06-22]</font>

[Medium](https://leetcode.cn/problems/minimum-garden-perimeter-to-collect-enough-apples/)

```python
class Solution:
    def minimumPerimeter(self, neededApples: int) -> int:
        left, right, ans = 1, 100000, 0
        while left <= right:
            mid = (left + right) // 2
            if 2 * mid * (mid + 1) * (mid * 2 + 1) >= neededApples:
                ans = mid
                right = mid - 1
            else:
                left = mid + 1
        return ans * 8
```

# Greedy

## Time Needed To Buy Tickets <font color=magenta>[2022-07-10]</font>

[Simple](https://leetcode.cn/problems/time-needed-to-buy-tickets/)

```python
class Solution:
    def timeRequiredToBuy(self, tickets: List[int], k: int) -> int:
        res = 0
        target = tickets[k]
        n = len(tickets)
        for i in range(n):
            if i <= k:
                res += min(tickets[i], target)
            else:
                res += min(tickets[i], target - 1)
        return res
```

## Form Array by Concatenating Sub-arrays in Another Array <font color=magenta>[2022-07-09]</font>

[Medium](https://leetcode.cn/problems/form-array-by-concatenating-subarrays-of-another-array/)

```python
class Solution:
    def canChoose(self, groups: List[List[int]], nums: List[int]) -> bool:
        num_row = len(groups)
        n = len(nums)

        idx = 0
        def if_find(cur_r, idx):
            num_column = len(groups[cur_r])
            for i in range(idx, n - num_column + 1):
                if groups[cur_r] == nums[i: i + num_column]:
                    return i + num_column
            return -1

        for i in range(num_row):
            idx = if_find(i, idx)
            if idx == -1:
                return False
        return True
```

## Longest Chunked Palindrome Decomposition <font color=magenta>[2022-06-19]</font>

[hard](https://leetcode.cn/problems/longest-chunked-palindrome-decomposition/)

```python
class Solution:
    def longestDecomposition(self, text: str) -> int:
        def get_sub_str(s):
            n = len(s)
            for i in range(1 , n // 2 + 1):
                if s[ : i] == s[n - i : ]:
                    return i
            return 0

        ans = 0
        while text:
            cur_sub_length = get_sub_str(text)
            if not cur_sub_length:
                return ans + 1

            text_length = len(text)
            text = text[cur_sub_length : text_length  - cur_sub_length]
            ans += 2
        return ans
```

## Orderly Queue <font color=magenta>[2022-06-17]</font>

[Hard](https://leetcode.cn/problems/orderly-queue/)

When K >= 2 the minimum queue can be obtained, thus only need to sort it and do
not need to know how the minimum queue is obtained.

```python
class Solution(object):
    def orderlyQueue(self, S, K):
        if K == 1:
            return min(S[i:] + S[:i] for i in range(len(S)))
        return "".join(sorted(S))
```

# Brute Force Search

## Non-overlapping Intervals <font color=magenta>[2022-07-08]</font>

[Medium](https://leetcode.cn/problems/non-overlapping-intervals/)

```python
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        if not intervals:
            return 0
        # sort by the end position
        intervals.sort(key=lambda x: x[1])
        n = len(intervals)
        right = intervals[0][1]
        ans = 1

        for i in range(1, n):
            # do not overlap the previse interval add it
            # this is equal to reomve the interval when it is overlap with
            # the previse one
            # it is the right way, because when overlap, the interval must be
            # removed or remove at least one of added intervals and the right
            # will get larger when remove the added intervals.
            if intervals[i][0] >= right:
                ans += 1
                right = intervals[i][1]
        return n - ans
```

## Longest Nice Substring <font color=magenta>[2022-07-05]</font>

[Simple](https://leetcode.cn/problems/longest-nice-substring/)

```python
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        n = len(s)
        maxPos, maxLen = 0, 0
        for i in range(n):
            lower, upper = 0, 0
            for j in range(i, n):
                if s[j].islower():
                    lower |= 1 << (ord(s[j]) - ord('a'))
                else:
                    upper |= 1 << (ord(s[j]) - ord('A'))
                if lower == upper and j - i + 1 > maxLen:
                    maxPos = i
                    maxLen = j - i + 1
        return s[maxPos: maxPos + maxLen]
```

## Number of String That Appear as Substrings in Word <font color=magenta>[2022-06-17]</font>

[Simple](https://leetcode.cn/problems/number-of-strings-that-appear-as-substrings-in-word/)

```python
class Solution:
    def numOfStrings(self, patterns: List[str], word: str) -> int:
        ans = 0
        n = len(word)
        def check(pa):
            m = len(pa)
            for i in range(n - m + 1):
                if word[i : i + m] == pa:
                    return 1
            return 0

        for pa in patterns:
            ans += check(pa)
        return ans
```

## Coordinate with Maximum Network Quality <font color=magenta>[2022-05-10]</font>

An array of network towers `towers` is given, where
$towers[i] = [x_i, y_i, q_i]$. $x_i$ and $y_i$ are the integral coordinates of
the network tower location and $q_i$ is the network quality factor. The network
quality of `towers[i]` at $(x, y)$ is $q_i / (1 + d)$ where
$d = \sqrt{(x - x_i)^2 + (y - y_i)^2}$.

You are also given an integer `radius`. All the tower is not reachable if and
only if `d > radius`.

The network quality of a location is the sum of network qualities from all
towers. Return the location with the maximum network quality.

If there are multiple coordinates with the same network quality, return the
lexicographically minimum non-negative coordinate.

Constraints:

1. 1 <= towers.length <= 50
2. towers[i].length == 3
3. 0 <= $x_i$, $y_i$, $q_i$ <=50
4. 1 <= radius <= 50

### Analysis

For 0 <= $x_i$, $y_i$, $q_i$ <=50, if x or y is large than 51, it can not be the
answer. All the network quality will be stronger when x or y is smaller. Thus,
we do only need to search within [0, 51].

```python
import math
class Solution:
    def bestCoordinate(self, towers: List[List[int]], radius: int) -> List[int]:
        max_signal, x, y = 0, 0, 0
        # search from small coordinate to large then we will get the small coordinate first
        for i in range(51):
            for j in range(51):
                signal_ij = 0
                for tower in towers:
                    delta_x, delta_y = tower[0] - i, tower[1] - j
                    d = math.sqrt(delta_x * delta_x + delta_y * delta_y)
                    # if > radius no quality
                    if d > radius:
                        continue
                      # use floor
                    signal_ij += math.floor(tower[2] / (1 + d))
                if signal_ij > max_signal:
                    max_signal, x, y = signal_ij, i, j
        return [x, y]
```

# Flip the Char

## Flip the Char <font color=magenta>[2022-06-16]</font>

[here](https://leetcode.cn/problems/cyJERH/)

The position 'max_idx' that the number of `0` on the left hand - the number of
`1` on the left hand get the maximum is the dividing line of `0` and `1`.

```python
class Solution:
    def minFlipsMonoIncr(self, s: str) -> int:
        num_0 = 0
        num_1 = 0
        max_off_set = 0
        max_num_0 = 0
        max_num_1 = 0
        for idx, num in enumerate(s):
            if num == "0":
                num_0 += 1
                off_set = num_0 - num_1
                if off_set > max_off_set:
                    max_off_set = off_set
                    max_idx = idx
                    max_num_0 = num_0
                    max_num_1 = num_1
            else:
                num_1 += 1
        return num_0 - max_num_0 + max_num_1
```

# Stack

## Valid Parentheses <font color=magenta>[2022-06-17]</font>

[here](https://leetcode.cn/problems/valid-parentheses/)

```python
class Solution:
    def isValid(self, s: str) -> bool:
        dic = {')' : '(',
        '}' : '{',
        ']' : '['
        }
        res = []
        for i in s:
            if i in dic:
                if not res:
                    return False
                cur = res.pop()
                if cur != dic[i]:
                    return False
            else:
                res.append(i)
        if res:
            return False
        return True
```

# Other

## Display Table of Food Orders in a Restaurant <font color=magenta>[2022-07-11]</font>

[Medium](https://leetcode.cn/problems/display-table-of-food-orders-in-a-restaurant/)

```python
class Solution:
    def displayTable(self, orders: List[List[str]]) -> List[List[str]]:
    # use dict to quickly find the food
        tables = defaultdict(lambda: defaultdict(int))
        food_set = set()
        for _, table, food in orders:
            food_set.add(food)
            tables[table][food] += 1

        res = []
        # sort the food
        food_list = sorted(food_set)
        res.append(['Table']+food_list)
        for table in sorted(tables.keys(),key=int):
            res.append([table] + [str(tables[table][item]) for item in food_list])
        return res
```

## Minimum Cost to Set Cooking Time <font color=magenta>[2022-06-29]</font>

[Medium](https://leetcode.cn/problems/minimum-cost-to-set-cooking-time/)

```python
class Solution:
    def minCostSetTime(self, startAt: int, moveCost: int, pushCost: int, targetSeconds: int) -> int:
        # 给定输入的最小花费
        def cost(m: int, s: int) -> int:
            if not (0 <= m <= 99 and 0 <= s <= 99):
                # 输入不合法
                return float("INF")
            digits = [m // 10, m % 10, s // 10, s % 10]
            # 寻找起始位
…                    res += moveCost
                res += pushCost
            return res

        mm, ss = targetSeconds // 60, targetSeconds % 60
        return min(cost(mm, ss), cost(mm - 1, ss + 60))   # 两种可能方案的较小值
```

## Random Pick with Weight <font color=magenta>[2022-06-26]</font>

[Medium](https://leetcode.cn/problems/random-pick-with-weight/)

```python
class Solution:

    def __init__(self, w: List[int]):
        self.array = []
        res = 0
        for i in w:
            res += i
            self.array.append(res)
        self.sum = res

    def pickIndex(self) -> int:
        import numpy as np
        import bisect
        num = np.random.uniform(0, self.sum, 1)
        return bisect.bisect_left/right(self.array, num)
```

## Intersections of Two Arrays II <font color=magenta>[2022-06-25]</font>

[Simple](https://leetcode.cn/problems/intersection-of-two-arrays-ii/)

```python
class Solution:
    def intersect(self, nums1: List[int], nums2: List[int]) -> List[int]:
        ans = []
        res1 = defaultdict(lambda : 0)
        res2 = defaultdict(lambda : 0)
        for i in nums1:
            res1[i] += 1
        for i in nums2:
            res2[i] += 1
        for key in res1:
            if key in res2:
                num = min(res1[key], res2[key])
                ans += [key] * num
        return ans
```

## Check if There is a Valid Path in a Grid <font color=magenta>[2022-06-21]</font>

[medium](https://leetcode.cn/problems/check-if-there-is-a-valid-path-in-a-grid/)

```python
class Solution:
    def hasValidPath(self, grid: List[List[int]]) -> bool:
        res = {
        1 :[[0, -1], [0, 1]],
        2: [[-1, 0], [1, 0]],
        3: [[0, -1], [1, 0]],
        4: [[0, 1], [1, 0]],
        5: [[0, -1], [-1, 0]],
        6: [[0, 1], [-1, 0]],
        }
        n = len(grid)
        m = len(grid[0])
        if n == m == 1:
            return True

        def to_position(position, direction):
            return [position[0] + direction[0], position[1] + direction[1]]

        def reach(cur):
            pre = [0, 0]
            while cur != [0, 0] and 0 <= cur[0] < n and 0 <= cur[1] < m:
                nex1 = to_position(cur, res[grid[cur[0]][cur[1]]][0])
                nex2 = to_position(cur, res[grid[cur[0]][cur[1]]][1])
                if nex1 != pre and nex2 != pre:
                    return False
                # be careful about the position of checking if reach the destination
                # can not be after `cur = nex`, because it can be reachable only
                 # checked nex1 or nex2 == pre
                if cur == [n - 1, m - 1]:
                    return True
                nex = nex1 if nex1 != pre else nex2
                pre = cur
                cur = nex
            return False
        start = [0, 0]
        cur1 = to_position(start, res[grid[0][0]][0])
        cur2 = to_position(start, res[grid[0][0]][1])
        return reach(cur1) or reach(cur2)
```

## Find K-th Smallest Pair distance <font color=magenta>[2022-07-06]</font>

[Hard](https://leetcode.cn/problems/find-k-th-smallest-pair-distance/)

```python

class Solution:
    def smallestDistancePair(self, nums: List[int], k: int) -> int:
        def count(mid: int) -> int:
            # count the pairs whose distance smaller and equil to mid
            cnt = 0
            for j, num in enumerate(nums):
                # when num is the larger one in the pair
                # the number in some position could be the
                # smaller one, it must larger than num - mid
                i = bisect_left(nums, num - mid, 0, j)
                cnt += j - i
            return cnt

        nums.sort()

        # The answer must be in range(0, nums[-1] - nums[0])
        # when pick a number in the range, we count the pair of numbers
        # whose distance is smaller or equal than it.

        # for example, if number 5, 6, 7, 8 have count k - 1, k, k, k +1
        # the answer will be 6, 5 has k - 1 pairs smaller or equal
        # 6 has k, thus will have pairs distance euqal to 6, and it is
        # the top-k smallest distance.
        # there are no pair whose distance is 7

        # if  number 5, 6, 7 have count k - 10, k + 10, k + 20
        # the answer is 6, there is 20 pairs whose distace is 6, and
        # and the top-k smallest distance is in them.

        # if the number nums[-1] - nums[0] - 1  has n counts and k > n
        # then k will be nums[-1] - nums[0]
        # thus, we need to use bisect_left and do not need to exame
        # nums[-1] - nums[0]
        return bisect_left(range(nums[-1] - nums[0]), k, key=count)
```

## Maximum Number of Visible Points <font color=magenta>[2022-06-19]</font>

[hard](https://leetcode.cn/problems/maximum-number-of-visible-points/)

```python
class Solution:
    def visiblePoints(self, points: List[List[int]], angle: int, location: List[int]) -> int:
        sameCnt = 0
        polarDegrees = []
        for p in points:
            if p == location:
                sameCnt += 1
            else:
                # obain all the angles the range is (-pi, pi]
                polarDegrees.append(atan2(p[1] - location[1], p[0] - location[0]))

        polarDegrees.sort()

        n = len(polarDegrees)
        # and 2 pi, the -pi will changed to pi, and thus -pi and pi
        # will be adjoined to each other
        # deg and deg + 2pi are both counted only if the angle is 2pi
        polarDegrees += [deg + 2 * pi for deg in polarDegrees]

        # change the degree into pi
        degree = angle * pi / 180
        # bisect_right/bisect_left require from bisect import xxxx
        # both bisect_right or bisect_left return the index that the val
        # placed in to the array and keeps the array ranked.

        # when there are numbers equal to val bisect_right places the val to the right
        # side of the equaled numbers, thus the returned value is the number of digits
        # smaller and equil to val in the array

        # bisect_left places the val to the left side of the equaled numbers. Thus the
        # returned value is the number of digits smaller to the val in the array

        # here bisect_right should be used
        maxCnt = max((bisect_right(polarDegrees, polarDegrees[i] + degree) - i for i in range(n)), default=0)
        return maxCnt + sameCnt
```

## Number of Different Integers in a String <font color=magenta>[2022-06-17]</font>

[here](https://leetcode.cn/problems/number-of-different-integers-in-a-string/)

```python
class Solution:
    def numDifferentIntegers(self, word: str) -> int:
        res = set()
        cur = 0
        word += 'a'
        flag = False
        for i in word:
            if i.isdigit():
                flag = True
                cur = cur * 10 + int(i)
            else:
                if flag:
                    res.add(cur)
                    cur = 0
                    flag = False
        return len(res)
```

## Max Length of Pair Chain <font color=magenta>[2022-06-16]</font>

[here](https://leetcode.cn/problems/maximum-length-of-pair-chain/)

```python
class Solution:
    def findLongestChain(self, pairs: List[List[int]]) -> int:
        res  = sorted(pairs, key = lambda a: a[1])
        ans = [res[0]]
        n = len(res)
        for i in range(1, n):
            if ans[-1][-1] < res[i][0]:
                ans.append(res[i])
        return len(ans)
```

## Two City Scheduling <font color=magenta>[2022-06-16]</font>

[here](https://leetcode.cn/problems/two-city-scheduling/)

Think about how to divide these people.

- The gain of changing the people from one city to another is only related to
  the difference between the costs of a and b.
- Thus, we can set the cost of a always 0, and set the cost of b to cost(b) -
  cost(a).
- The cost of a is always 0 and we only need to pick n people to b which reach
  the minimum cost.

```python
class Solution:
    def twoCitySchedCost(self, costs: List[List[int]]) -> int:
        res = [a[1] - a[0] for a in costs]
        nn = len(res)
        sort_idx = sorted(range(nn), key = lambda k: res[k], reverse = False)
        cost = 0
        for i in range(nn // 2):
            cost += costs[sort_idx[i]][1]
        for i in range(nn // 2, nn):
            cost += costs[sort_idx[i]][0]
        return cost
```

## Exchange LCCI <font color=magenta>[2022-06-16]</font>

[here](https://leetcode.cn/problems/exchange-lcci/)

```python
class Solution:
    def exchangeBits(self, num: int) -> int:
        num_bin = bin(num)
        n = len(num_bin)
        res = ''
        start = 2
        if n % 2:
            res += '10'
            start = 3
        for i in range(start, n, 2):
            res += num_bin[i + 1]
            res += num_bin[i]
        return int(res, 2)
```

## The First Char which Only Appears once <font color=magenta>[2022-06-16]</font>

The topic is
[here](https://leetcode.cn/problems/di-yi-ge-zhi-chu-xian-yi-ci-de-zi-fu-lcof/).

```python
class Solution:
    def firstUniqChar(self, s: str) -> str:
        res = collections.defaultdict(lambda: [0, 1])
        for idx, c in enumerate(s):
            if not c in res:
                res[c][0] = idx
            else:
                res[c][1] += 1
        ans = " "
        min_idx = len(s)
        for i in res:
            if res[i][1] == 1 and res[i][0] < min_idx:
                min_idx = res[i][0]
                ans = i
        return ans
```

## The Gas Station

There are `n` stations along a circular route, where the amount of gas at the
$i^{th}$ station is gas[i].

A car costs cost[i] of gas to travel from the $i^{th}$ station to its next
$(i + 1)^{th}$ station.

Can the car run a circle. If can, return the start station. If not, return -1.
If there exists a solution, it is guaranteed to be the unique.

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int
        n = len(gas)
        res = [0] * n
        # a car pass station i, it can get gas[i] and cost
        # cost[i]. Thus gets gas[i] - cost[i].

        # if in station i, gas[i] - cost[i] >= 0, it can
        # arrive the next station.
        # after arrive the next station, and gets the station
        # if the remain >= 0 it can gets the next next station.
        for i in range(n):
            res[i] = gas[i] - cost[i]
        first = 0
        second = 0
        sum_ = res[0]
        key = False
        # second represents the station the car already getting.
        # first represents the starting station.
        # sum_ represents if the car can get the next staion.
        # if sum_ >= 0, it can, else, it can not.
        while True:
            if sum_ >= 0:
                second += 1
                if second == n:
                    second = 0
                    key = True
                if key and second == first:
                    return first
                sum_ += res[second]
            else:
                sum_ -= res[first]
                first += 1
                # from 0 to n, first do not find an answer, return -1.
                if first == n:
                    return -1
                else:
                    if first > second:
                        second += 1
                        sum_ += res[second
```

Consider this, if y is the first station that the car can not arrive from x.
That is to say $\sum_{i = y}^x res[i] < 0$. For a station z between x and y. It
can arrive z from x, which means the sum $> 0$. Then from z to y, the sum is
definitely $< 0$. It can not arrive y from z.

Thus, if a car can not arrive y from x, it can not arrive y from any station
between x and y. It is no need to search such stations.

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int:
        n = len(gas)
        res = [0] * n
        for i in range(n):
            res[i] = gas[i] - cost[i]
        first = 0
        second = 0
        sum_ = res[0]
        key = False
        while True:
            if sum_ >= 0:
                second += 1
                if second == n:
                    second = 0
                    key = True
                if key and second == first:
                    return first
                sum_ += res[second]
            else:
            # if can not arrive second + 1, then
            # starting from second + 1
                second += 1
                first = second
                # if the new starting point equal or bigger than
                # n, first move from 0 to n fails to find.
                # if key is True, second + 1 is actually larger than
                # n, first move from 0 to n fails to find.
                if first == n or key:
                    return -1
                sum_ = res[first]
```

## Maximum Number of Tasks You Can Assign <font color=magenta>[2022-05-11]</font>

The topic is
[here](https://leetcode.cn/problems/maximum-number-of-tasks-you-can-assign/).

### Analysis

1. The task need small strength is preferred.
2. The worker with large strength is preferred

A wrong code

```python
class Solution:
    def maxTaskAssign(self, tasks: List[int], workers: List[int], pills: int, strength: int) -> int:
        tasks.sort()
        workers.sort()
        n =  len(tasks)
        m =  len(workers)
        ans = 0
        j = 0
        for i in range(m):
            if j < n:
                # A new worker waiting for task
                if workers[i] >= tasks[j]:
                    ans += 1
                    # the task has been assigned, consider the next task
                    j += 1
                else:
                    # if there is pills avaliable
                    if pills and workers[i] + strength >= tasks[j]:
                        # use this pill
                        pills -= 1
                        ans += 1
                        j += 1
        return ans
```

This code prefers to use small strength workers, which is wrong. When the
workers can do `k` tasks, it must be the top `k` strength workers taking the
bottom `k` tasks.

The final answer.

```python
from sortedcontainers import SortedList


class Solution:
    def maxTaskAssign(self, tasks, workers, pills, strength):
        n, m = len(tasks), len(workers)
        tasks.sort()
        workers.sort()

        def check(mid: int) -> bool:
            p = pills
            #  the workers needed to be check
            ws = SortedList(workers[m - mid:])
            # tasks from large to small
            for i in range(mid - 1, -1, -1):
                if ws[-1] >= tasks[i]:
                    # tasks[i] is assigned to ws[-1]
                    ws.pop()
                else:
                    if p == 0:
                        # if does not have pills anymore
                        return False
                    # has pills
                    # Note: find the smallest worker can take the task by pill
                    rep = ws.bisect_left(tasks[i] - strength)
                    if rep == len(ws):
                        return False
                    p -= 1
                    ws.pop(rep)
            return True

        # The scope of k needed to be checked if 1 checked false, answer is 0
        # if right = min(m, n) checked true, answer is right
        left, right, ans = 1, min(m, n), 0
        while left <= right:
            mid = (left + right) // 2
            if check(mid):
                # if mid is true, then ans is larger than mid
                # find it in [mid + 1, right]
                ans = mid
                left = mid + 1
            else:
                # if mid is false, then ans is smaller than mid
                # find it in [left, mid - 1]
                right = mid - 1

        return ans
```
