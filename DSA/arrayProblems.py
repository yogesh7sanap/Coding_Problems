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


# ====================================================


# ====================================================





# ====================================================
# ====================================================

# ====================================================


# ====================================================















