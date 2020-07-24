import numpy as np
from Space import Space

class Algorithm(Space):
	def __init__(self, name, vals_dic, space):
		super().__init__(name, space.param_dic)	

		for i in vals_dic:
			vals = vals_dic[i] if (vals_dic[i] != None) else [1]
			self.param_dic[i].set_vals(vals)

		self.total_cases = self.calculate_total_cases()

	def calculate_total_cases(self):
		temp = 1
		for p in self.param_dic:
			temp *= self.param_dic[p].vals_size
		return temp

	def case_gen(self, index):
		case = {}
		for p in self.param_dic:
			w = self.param_dic[p].vals_size
			case[p] = self.param_dic[p].vals[index % w]
			index = int(np.floor(index / w))
		return case
