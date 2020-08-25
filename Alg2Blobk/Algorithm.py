import numpy as np
from Space import Space

class Algorithm(Space):
	def __init__(self, name, vals_dic, space, case_gen_method="all_combinations", verbose=True):
		super().__init__(name, space.param_dic)	

		self.name = name

		if case_gen_method in ["all_combinations", "specific_samples"]:
			self.case_gen_method = case_gen_method
		else:
			raise Exception ("Algorithm %s defenition is wrong ! (case generator method is not defined: %s)" % (self.case_gen_method))

		for i in vals_dic:
			vals = vals_dic[i] if (vals_dic[i] != None) else [1]
			self.param_dic[i].set_vals(vals)

		self.total_cases = self.calculate_total_cases()

		if verbose: 
			print("Algorithm %s has %d number of cases." % (self.name, self.total_cases))

		if case_gen_method == "specific_samples":
			print(self.total_cases)
			exit()

	def calculate_total_cases(self):
		if self.case_gen_method == "all_combinations":
			temp = 1
			for p in self.param_dic:
				temp *= self.param_dic[p].vals_size
		elif self.case_gen_method == "specific_samples": 
			temp = []
			for p in self.param_dic:
				temp.append(self.param_dic[p].vals_size)

			temp_unique = np.unique(temp)			
			if 1 in temp_unique:				
				temp_unique = np.delete(temp_unique, np.where(temp_unique == 1))
				
			temp_unique_len = len(temp_unique)

			if (temp_unique_len == 0):
				temp = 1
			elif (temp_unique_len == 1):
				temp = temp_unique[0]
				for i in self.param_dic:
					self.param_dic[i].set_vals(self.param_dic[i].get_vals() * temp)
			else:
				raise Exception ("Algorithm %s defenition is wrong ! (length of loop values are not equal)" % (self.name))

		return temp

	def case_gen(self, index):
		case = {}
		for p in self.param_dic:
			if self.case_gen_method == "all_combinations":
				w = self.param_dic[p].vals_size
				case[p] = self.param_dic[p].vals[index % w]
				index = int(np.floor(index / w))
			elif self.case_gen_method == "specific_samples": 

				case[p] = self.param_dic[p].vals[index]
		return case
