import numpy as np
import random
import time

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

def dic2nparr(dic, tuple_index=None):
	arr = np.array([])
	for p in dic:
		if tuple_index == None:
			arr = np.append(arr, dic[p])
		else:
			arr = np.append(arr, dic[p][tuple_index])
	return arr

def check_scale_P_N_W(dic1, dic2):
	#rate_P = dic2["P"] / dic1["P"]
	rate_N = dic2["N"] / dic1["N"]
	rate_W = dic2["W"] / dic1["W"]

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

def pick_optimum_necessary_cols(table, costs):
	size = table.shape
	if size[0] == 0:
		return np.array([]), 0

	table_r = np.sum(table, axis=1)
	if not all(table_r):
		return None, -1

	if size[1] == 1:
		return np.array([0]), costs[0]
	else:
		# find smaller table shape
		table_s_wf = np.array([])
		for row in table:
			if row[0] == 0:
				if len(table_s_wf) == 0:
					table_s_wf = np.reshape(np.array(row[1:]), (1,-1))
				else:
					table_s_wf = np.append(table_s_wf, np.reshape(row[1:], (1,-1)), axis=0)
		
		table_s_nf = table[:,1:]

		cols_wf, costs_wf = pick_optimum_necessary_cols(table_s_wf, costs[1:])
		cols_nf, costs_nf = pick_optimum_necessary_cols(table_s_nf, costs[1:])
		
		if costs_wf != -1:
			cols_wf = np.append([0], (cols_wf + 1))
			costs_wf += costs[0]

		if costs_nf != -1:
			cols_nf = cols_nf + 1

		if costs_wf == -1: 
			return cols_nf, costs_nf
		elif costs_nf == -1:
			return cols_wf, costs_wf
		else:
			if (costs_wf >= costs_nf):
				return cols_nf, costs_nf
			else:
				return cols_wf, costs_wf



if __name__ == "__main__":
	print(check_presence("I", "IOW")) 	# True expected
	print(check_presence("IW", "IOW")) # True expected
	print(check_presence("IX", "IOW")) # False expected
	print(check_presence("O", "IOW")) 	# True expected
	print("********")
	print(check_equality("OI", "IOW")) 	# False expected
	print(check_equality("IOW", "IOW")) 	# True expected
	print(check_equality("WIO", "IOW")) 	# True expected
	print(check_equality("IOWL", "IOW")) 	# False expected
	print("********")
	print(param_gen_const_product(4, 12))
	print(isround(1.5))					# False is expected
	print(isround(2))					# True is expected
	print(isround(2.0))					# True is expected
	print("********")
	costs = np.array(
				[2,1,2,1,2,1,4,1,4,1,4])
	table = np.array([
				[0,0,1,0,0,0,1,0,0,1,0],
				[0,0,0,0,0,0,0,0,0,1,0],
				[0,1,1,1,0,0,0,0,0,1,0],
				[0,0,0,1,0,0,1,0,1,1,0],
				[0,1,1,1,0,0,1,0,1,1,0],
				[0,1,0,1,0,0,0,0,1,0,0],
				[0,1,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,1,0,0],
				[0,1,1,0,0,0,1,0,1,1,0],
			])
	cols, cost = pick_optimum_necessary_cols(table, costs)
	print("cols costs: \n " + str(costs))
	print("table: \n" + str(table))
	print("selected cols: \t" + str(cols))			# expected [1 8 9] 
	print("selected costs: \t" + str(cost))			# expected 6

	for w in [10, 15, 20]:
		for h in [100, 1000, 10000]:
			#costs = np.array(random.randint(w))
			#table = np.array(random.randint(h, w))
			costs =	np.random.randint(2, size=(w))
			table =	np.random.randint(2, size=(h,w))
			
			start = time.time()
			cols, cost = pick_optimum_necessary_cols(table, costs)			
			end = time.time()

			print("pick_optimum_necessary_cols for w:%d\th:%-8d\ttime:%f," % (w,h,end - start))
