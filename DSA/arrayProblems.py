# Max Value 1 ====================================================

#  |arr[i] – arr[j]| + |i – j|, 
#  where 0 <= i, j <= N – 1 and arr[i], arr[j] belong to the array.

# Brute Force => O(n^2)

def findValue(arr, n): 
    ans = 0; 
      
    # Iterating two for loop,  
    # one for i and another for j. 
    for i in range(n): 
        for j in range(n): 
              
            # Evaluating |arr[i] - 
            # arr[j]| + |i - j| 
            # and compare with 
            # previous maximum. 
            ans = ans if ans>(abs(arr[i] - arr[j]) + 
                              abs(i - j)) else (abs(arr[i]-
                                    arr[j]) + abs(i - j)); 

    return ans;


# O(n) solution 

import sys 

def findValue(arr, n): 
    temp1=0; 
    temp2=0; 
    max1 = -sys.maxsize; 
    max2 = -sys.maxsize; 
    min1 = sys.maxsize; 
    min2 = sys.maxsize; 
  
    # Calculating max1 , min1 and max2, min2 
    for i in range(n): 
        temp1 = arr[i] + i; 
        temp2 = arr[i] - i; 
        max1 = max(max1, temp1); 
        min1 = min(min1, temp1); 
        max2 = max(max2, temp2); 
        min2 = min(min2, temp2); 
      
    # required maximum ans is max of (max1-min1) and 
    # (max2-min2) 
    return max((max1 - min1), (max2 - min2)); 


# Max Value 2 [Leetcode Medium] ====================================================




# Trapping Rain Water ====================================================

# Brute Force => O(n^2)

def trap(arr):
    n = len(arr)
    waterTrapped = 0
    for i in range(n):
        j = i
        leftMax, rightMax = 0, 0
        while j >= 0:
            leftMax = max(leftMax, arr[j])
            j -= 1
        j = i
        while j < n:
            rightMax = max(rightMax, arr[j])
            j += 1
        waterTrapped += min(leftMax, rightMax) - arr[i]
    return waterTrapped


# O(n) solution


def trap(arr):
    n = len(arr)
    prefix = [0] * n
    suffix = [0] * n
    
    prefix[0] = arr[0]
    for i in range(1, n):
        prefix[i] = max(prefix[i - 1], arr[i])
    
    suffix[n - 1] = arr[n - 1]
    for i in range(n - 2, -1, -1):
        suffix[i] = max(suffix[i + 1], arr[i])
    
    waterTrapped = 0
    for i in range(n):
        waterTrapped += min(prefix[i], suffix[i]) - arr[i]
    
    return waterTrapped



# 2D Matrix ====================================================


# Define a 2D array of integers with 3 rows and 4 columns
myArray = [[0] * 4 for _ in range(3)]


# Matrix Addition

mat1 = [[0] * 3 for _ in range(3)]
mat2 = [[0] * 3 for _ in range(3)]
sum_mat = [[0] * 3 for _ in range(3)]

print("Insert the values of the first matrix:")
for i in range(3):
    for j in range(3):
        mat1[i][j] = int(input())

print("Insert the values of the second matrix:")
for i in range(3):
    for j in range(3):
        mat2[i][j] = int(input())

# Adding the two matrices.
for i in range(3):
    for j in range(3):
        sum_mat[i][j] = mat1[i][j] + mat2[i][j]

print()

# Printing the result matrix.
print("Sum of the matrices:")
for i in range(3):
    for j in range(3):
        print(sum_mat[i][j], end="  ")
    print()



# Range Sum Queries ====================================================

# Brute Force O(n^2)

# Input the size of the array (n) and the number of queries (q)
n, q = map(int, input().split())

# Input the array elements
a = list(map(int, input().split()))

# Iterate through each query
for _ in range(q):
    # Input the range (x, y) for the current query
    x, y = map(int, input().split())
    
    # Initialize the sum for the current query
    sum = 0
    
    # Iterate through the range (x, y) and calculate the sum of elements in that range
    for i in range(x, y + 1):
        sum += a[i]
    
    # Print the sum for the current query
    print(sum)




# O(n) solution


n, q = map(int, input().split())
a = list(map(int, input().split()))

pre = [0] * n
for i in range(1, n):
    pre[i] = pre[i - 1] + a[i]

for _ in range(q):
    x, y = map(int, input().split())
    print(pre[y] - pre[x - 1])


# Maximun sum with exactly K elements - 1====================================================

class MaximizeSum:
	def __init__(self, arr, k):
		self.arr = arr
		self.k = k

	def solve(self):
          mx = max (self.arr)
          score = 0 

          for _ in range(self.k):
               score += mx
               mx +=1

          return score 



# Maximum product of two elements - 2 ====================================================

# O(n) solution

class MaxProduct:
	def __init__(self, arr):
		self.arr = arr

	def solve(self):

		first = second = 0

		for num in self.arr:

			if num >= first:
				first,second = num, first
			elif num > second:
				second =num 

		return (first-1) * (second-1)



# sorting approach increases time complexity

def maxProduct(nums):
    nums.sort(reverse=True)
    return (nums[0] - 1) * (nums[1] - 1)




# Find N unique integers sum to zero - 3 ====================================================

class SumZero:
	def __init__(self, n):
		self.n = n

	def solve(self):

          result = []
          for i in range(1,  (self.n//2)+1):
               result.append(i)
               result.append(-i)

          if self.n %2 ==1:
               result.append(0)

          return result




# Squares Of a Sorted Array ====================================================

# O(nlog(n)) solution

class SortedSquares:
	def __init__(self, arr):
		self.arr = arr

	def solve(self):

          squared = [ i**2 for i in self.arr]
          squared.sort()

          return squared


# O(n) solution

class SortedSquares:
	def __init__(self, arr):
		self.arr = arr

	def solve(self):

          n = len(self.arr)
          result = [0]*n

          left, right = 0, n-1

          for i in range (n-1, -1, -1):
               if abs(self.arr[left]) > abs(self.arr[right]):
                    result[i] = self.arr[left] **2
                    left +=1
               else:
                    result[i] = self.arr[right] **2
                    right -=1
          
          return result

# ====================================================

# ====================================================





# ====================================================
# ====================================================

# ====================================================


# ====================================================


# ====================================================





# ====================================================
# ====================================================

# ====================================================


# ====================================================















