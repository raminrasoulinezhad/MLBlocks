from Space import Space
from utils import * 

class Unrolling(Space):
	def __init__(self, name, param_dic, space, stationary, precisions, limits):
		super().__init__(name, space.param_dic)	
		
		for p in param_dic:
			self.param_dic[p].set_vals( param_dic[p] )

		self.stationary = stationary 
		self.precisions = precisions
		self.limits = limits

		self.spaces_lists = ["I","W","O","IW","WO","IO","IWO"]
		self.IO_Comp_spaces = {}
		
		self.set_IO_Comp_spaces()

		self.score = 0
		self.scores= []

	def set_IO_Comp_spaces(self):
		for i in self.spaces_lists:
			self.IO_Comp_spaces[i] = {"size" : 1, "dic": {}}

		for i in self.param_dic:
			for j in self.spaces_lists[0:3]:
				if check_presence(j, self.param_dic[i].type):
					if not self.param_dic[i].window_en:
						self.IO_Comp_spaces[j]["size"] *= self.param_dic[i].get_vals()
					self.IO_Comp_spaces[j]["dic"][i] = self.param_dic[i].get_vals()

			for j in self.spaces_lists[3:]:
				if check_equality(j, self.param_dic[i].type):
					if not self.param_dic[i].window_en:
						self.IO_Comp_spaces[j]["size"] *= self.param_dic[i].get_vals()
					self.IO_Comp_spaces[j]["dic"][i] = self.param_dic[i].get_vals()

	def print_IO_Comp_spaces(self):
		for i in self.IO_Comp_spaces:
			print(str(i) + 	str(self.IO_Comp_spaces[i]))

	def IO_report(self, sources=["I", "W", "O"]):
		temp = 0
		for i in sources:
			temp += self.IO_Comp_spaces[i]["size"] * self.precisions[i]
		return temp

	def OK(self):
		# check total IOs
		if (self.limits["IO"] != None) and (self.IO_report(["I", "W", "O"]) > self.limits["IO"]):
			return False
		if (self.limits["IO_I"] != None) and (self.IO_report(["I"]) > self.limits["IO_I"]):
			return False
		if (self.limits["IO_W"] != None) and (self.IO_report(["W"]) > self.limits["IO_W"]):
			return False
		if (self.limits["IO_O"] != None) and (self.IO_report(["O"]) > self.limits["IO_O"]):
			return False
		return True

	def gen_dic(self):
		dic = {}
		for p in self.param_dic:
			dic[p] = self.param_dic[p].get_vals()
		return dic

	def reset_score(self):
		self.score = 0

	def clear_scores(self):
		self.scores = []
