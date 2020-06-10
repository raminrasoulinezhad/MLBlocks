import numpy as np

def None2one(arr):
	arr = [i if i !=None else 1 for i in arr]
	return arr

def arr2prod(arr):
	return np.prod(arr)

def check_presence(keys_string, target_string):
	for i in keys_string:
		if i not in target_string:
			return False
	return True 

def check_equality(keys_string, target_string):
	for i in keys_string:
		if i not in target_string:
			return False
	for i in target_string:
		if i not in keys_string:
			return False

	return True 

def param_gen_const_product(size, const):
	results = np.array([])

	if size == 1:
		results = [const]
	else:
		for i in range(1, const+1):
			if (const % i) == 0:

				results_temp = param_gen_const_product(size-1, int(const / i))
				
				for j in results_temp:
					j_extend = np.append(j, i)

					if results.size == 0:
						results = np.expand_dims(j_extend, axis=0)
					else:
						j_extend = np.expand_dims(j_extend, axis=0)
						results = np.concatenate((results, j_extend), axis=0)

	return results

def fill_dic_by_array(dic, arr):
	counter = 0
	for i in dic:
		dic[i] = arr[counter]
		counter += 1
	return dic

def print_(string, v):
	if v:
		print(string)

def dic2nparr(dic):
	arr = np.array([])
	for p in dic:
		arr = np.append(arr, dic[p])
	return arr

def check_scale_P_N_W(dic1, dic2):
	#rate_P = dic2["P"] / dic1["P"]
	rate_N = dic2["N"] / dic1["N"]
	rate_W = dic2["W"] / dic1["W"]
	print (rate_N, rate_W)

	if ((dic2["N"] == 1) and (rate_N < 1.0)):
		return None
	elif ((dic2["W"] == 1) and (rate_W < 1.0)):
		return None
	elif ((isround(rate_N) or isround(1/rate_N)) and (isround(rate_W) or isround(1/rate_W))):
		return (rate_N, rate_W)
	else:
		return None

def isround(num):
	if np.floor(num) == num:
		return True
	return False


if __name__ == "__main__":
	print (check_presence("I", "IOW")) 	# True expected
	print (check_presence("IW", "IOW")) # True expected
	print (check_presence("IX", "IOW")) # False expected
	print (check_presence("O", "IOW")) 	# True expected
	print()
	print (check_equality("OI", "IOW")) 	# False expected
	print (check_equality("IOW", "IOW")) 	# True expected
	print (check_equality("WIO", "IOW")) 	# True expected
	print (check_equality("IOWL", "IOW")) 	# False expected
	print()
	print(param_gen_const_product(4, 12))
	print(isround(1.5))					# False is expected
	print(isround(2))					# True is expected
	print(isround(2.0))					# True is expected
