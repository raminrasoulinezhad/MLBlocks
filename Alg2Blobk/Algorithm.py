import numpy as np
from Space import Space
from ImpConfig import ImpConfig

class Algorithm(Space):
	def __init__(self, name, vals_dic, space, case_gen_method="all_combinations", verbose=True):
		super().__init__(name, space.param_dic)	

		if case_gen_method in ["all_combinations", "specific_samples"]:
			self.case_gen_method = case_gen_method
		else:
			raise Exception ("Algorithm %s defenition is wrong ! (case generator method is not defined: %s)" % (self.case_gen_method))

		for val in vals_dic:
			self.param_dic[val].set_vals(vals_dic[val])

		self.total_cases = self.calculate_total_cases()

		if verbose: 
			print("Algorithm %-30s  %10d cases." % (self.name, self.total_cases))

		self.utilization_rates = [{} for i in range(self.total_cases)]

	def calculate_total_cases(self):
		if self.case_gen_method == "all_combinations":
			total_cases = 1
			for p in self.param_dic:
				total_cases *= self.param_dic[p].get_vals_size()

		elif self.case_gen_method == "specific_samples": 

			param_sizes_list = [ self.param_dic[p].get_vals_size() for p in self.param_dic ] 

			# check whether parameter values are the same size lists or not? 
			# It considers that some parameter values may be None as they are not used in that especific benchmark.
			param_sizes_list_unique = np.unique(param_sizes_list)							
			param_sizes_list_unique = np.delete(param_sizes_list_unique, np.where(param_sizes_list_unique == 1))
			param_sizes_list_unique_len = len(param_sizes_list_unique)

			if (param_sizes_list_unique_len == 0):
				total_cases = 1
			elif (param_sizes_list_unique_len == 1):
				total_cases = param_sizes_list_unique[0]
				for i in self.param_dic:
					if self.param_dic[i].get_vals_size() == 1:
						self.param_dic[i].set_vals(self.param_dic[i].get_vals() * total_cases)
			else:
				raise Exception ("Algorithm %s defenition is wrong ! (length of loop values are not equal)" % (self.name))

		return total_cases

	def get_total_cases(self):
		return self.total_cases

	def case_gen(self, index):
		case = {}
		for p in self.param_dic:
			if self.case_gen_method == "all_combinations":
				w = self.param_dic[p].get_vals_size()
				case[p] = self.param_dic[p].get_vals()[index % w]
				index = int(np.floor(index / w))

			elif self.case_gen_method == "specific_samples": 
				case[p] = self.param_dic[p].get_vals()[index]

		return case

	def set_rate(self, index, label, rate):
		self.utilization_rates[index][label] = rate

	def get_rate(self, index, label):
		if label in self.utilization_rates[index]:
			return self.utilization_rates[index][label]
		else:
			return 0.0

	def print_rates(self):
		for index in range(len(self.utilization_rates)):
			print(self.utilization_rates[index])
		
	def evaluate(self, impconfigs):
		unroll_name_list = []
		for impconfig in impconfigs:
			for case in impconfig.unrollings:
				unroll_name_list.append(case)
		
		rate_bests = []
		for index in range(self.total_cases):
			rate_best  = 0
			for label in unroll_name_list:
				#print(unroll_name_list)
				#print(index, label)
				rate_temp = self.get_rate(index, str(label))
				if rate_best < rate_temp:
					rate_best = rate_temp
			rate_bests.append(rate_best)

		rate_mean = np.mean(rate_bests)
		return rate_mean


