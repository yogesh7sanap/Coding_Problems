# GCD of max and min array elements ====================================================

# Iterative 
class Gcd:
	def __init__(self, arr):
		self.arr = arr

	def gcd(self):

          a = min(self.arr)
          b = max (self.arr)

          while b:
               a,b= b, a%b

          return a


# GCD of two numbers ====================================================

# Time Complexity: O(min(a,b)
# Space Complexity: O(1)

class GCD:
      def __init__(self, n, m):
            self.n = n
            self.m = m 

      def gcd(self):
            min_number = min (self.n , self.m)

            while min_number>0:
                  if self.n % min_number==0 and self.m % min_number==0:
                       break
                  result -=1

            return min_number 

             

# ====================================================
# ====================================================
# ====================================================
