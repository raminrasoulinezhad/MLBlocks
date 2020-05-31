import numpy as np

def None2one(arr):
	arr = [i if i !=None else 1 for i in arr]
	return arr

def arr2prod(arr):
	return np.prod(arr)

