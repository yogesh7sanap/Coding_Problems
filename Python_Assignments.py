
# Python Refresher 1 ======================================================

# Even-odd ----------------------
class EvenOdd:
	def __init__(self, n):
		self.n = n

	def check(self):
            if self.n % 2 == 0 :
                  return True
            else: 
                  return False

# Leap Year ----------------------

class LeapYear:
	def __init__(self, n):
		self.n = n

	def check(self):
            # year=self.n
            if (self.n % 4) ==0 :
                  if (self.n % 100)==0:
                        if (self.n % 400)==0 :
                              return True
                        else:
                              return False
                  else:
                        return True
            else:
                  return False

            
# Max of 2 numbers ----------------------

class Maximum:
    def __init__(self, n, m):
        self.n = n
        self.m = m
        
    def solve(self):
      if self.n>self.m:
          return self.n
      else:
          return self.m


# Positive to Negative Number ----------------------

class Maximum:
    def __init__(self, n, m):
        self.n = n
        self.m = m
        
    def solve(self):
      if self.n>self.m:
          return self.n
      else:
          return self.m


# Multiple of 3 ----------------------

class MultipleOfThree:
	def __init__(self, n):
		self.n = n

	def check(self):
		if self.n % 3 ==0:
			return True;
		else:
			return False


# Give a number find Muliple of 5 till that number ----------------------

class MultipleOfFive:
	def __init__(self, n):
		self.n = n

	def solve(self):
          list_multiple_of_five = []
          for i in range(1,self.n+1):
               if i%5==0:
                    list_multiple_of_five.append(i)
               else:
                    continue
          return list_multiple_of_five


# Count of positive numbers in a given list ----------------------

class Positive:
	def __init__(self, arr):
		self.arr = arr

	def count(self):
            cnt=0
            for i in self.arr:
                  if i>=0:
                        cnt +=1;
                  else:
                        continue
            return cnt

      
# Last word length in string ----------------------

class LastWord:
	def __init__(self, s):
		self.s = s

	def solve(self):
            last_word_length = len(self.s.rstrip(' ').split(' ')[-1])
            return last_word_length


# check if integer is palindrome or not ----------------------


class Palindrome:
	def __init__(self, n):
		self.n = n

	def check(self):
            if self.n<0:
                  return False
            else:
                  return str(self.n) == str(self.n)[::-1]

# OR

class Palindrome:
	def __init__(self, n):
		self.n = n

	def check(self):
            is_pal=True
            str_n = str (self.n)
            for i in range(0, len(str_n)//2):
                  if str_n[i] != str_n[len(str_n)-1-i]:
                        is_pal=False
                  else:
                        continue
            return is_pal

      
# Factorial of a number ----------------------

class Factorial:
	def __init__(self, n):
		self.n = n

	def solve(self):
            factorial=1
            for i in range(1, self.n+1):
                  factorial *=i
            
            return factorial


# Reverse a Integer ----------------------

class Reverse:
	def __init__(self, n):
		self.n = n

	def solve(self):
            reversed_number=0
            while (self.n>0):
                  last_digit = self.n %10
                  reversed_number =reversed_number*10 + last_digit
                  self.n = self.n //10       
            return reversed_number
      
      
# Armstrong Number ----------------------

# 153 => len of 153 is 3 hence 1^3 + 5^3 + 3^3 = 153 hence a armstrong number

class Armstrong:
	def __init__(self, n):
		self.n = n

	def check(self):
            num = self.n
            number_length = len(str(self.n))
            final_sum =0
            while self.n >0 :
                  digit = self.n %10
                  final_sum += digit ** number_length
                  self.n = self.n // 10
            
            if num == final_sum:
                  return True
            else:
                  return False


# ----------------------


# Python Refresher 2 ======================================================

# Pattern 3 ----------------------

class Pattern:
	def __init__(self, n):
		self.n= n

	def solve(self):
          list_of_pattern_strings = []
          for i in range (1, self.n+1):
               row_string = ''
               for j in range (1,i+1):
                    single_char = chr(96+j)
                    row_string= row_string + single_char

               list_of_pattern_strings.append(row_string)
               
          return list_of_pattern_strings



# Pattern 4 ----------------------

class Pattern:
    def __init__(self, n):
        self.n= n
        
    def solve(self):
        ans = []
        for i in range(self.n):
            s = ""
            for j in range(self.n-i):
                s+="*"
            ans.append(s)

        return ans

# OR [Btter time complexity]

class Pattern:
	def __init__(self, n):
		self.n= n

	def solve(self):
          list_right_triangle_star_pattern = []
          for i in range (self.n, 0,-1):
               single_row = "*" * i
               list_right_triangle_star_pattern.append(single_row)
          return list_right_triangle_star_pattern


# Pattern 5 ----------------------

class Pattern:
	def __init__(self, n):
		self.n= n

	def solve(self):
          list_hollow_square_star_pattern = []
          for i in range (1, self.n + 1):
               single_row = ''
               for j in range (1, self.n + 1):
                    if i==1 or j ==1 or i == (self.n) or j == (self.n):
                         single_row += '*'
                    else:
                         single_row += ' '
               list_hollow_square_star_pattern.append(single_row)
          
          return list_hollow_square_star_pattern


# 123 Pattern ----------------------

# Brute Force O(n^3)

class Pattern132:
	def __init__(self, arr):
		self.arr = arr

	def solve(self):

          for i in range(len(self.arr)):
               for j in range (i+1, len(self.arr)):
                    for k in range (j+1, len(self.arr)):
                         if self.arr[i]< self.arr[k] and self.arr[k]< self.arr[j]:
                              return True
          
          return False


# O(n)

class Pattern132:
	def __init__(self, arr):
		self.arr = arr

	def solve(self):
          # for storing the 3rd element
          stack = []
          #for getting 2nd element
          second = float('-inf')

          # traversing reversed array 
          # Everything I've already processed is to the right of the current number [easy to find 3rd and 2nd this way].
          for current_element in reversed(self.arr):

               # found 132 pattern
               if current_element <second:
                    return True
               
               # while stack is not empty and 
               # current element is less than last stack element
               # assign second and pop from stack 
               # Here we found 3rd [current_element] [which we pushed to stack after loop]
               #  and 2nd element [second]
               while stack and current_element > stack[-1]:
                    second = stack.pop()

               stack.append(current_element)
          
          return False


# ======================================================
# ======================================================
# ======================================================
# ======================================================

# ======================================================

# ======================================================

# ======================================================
# ======================================================
# ======================================================
# ======================================================

# ======================================================