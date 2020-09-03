import copy
from Param import Param

class Space():		
	def __init__(self, name, param_dic):
		self.set_name(name)
		self.param_dic = copy.deepcopy(param_dic)
		self.size = len(self.param_dic)

	def print_param_dic(self, type=None):
		print("Model name: " + str(self.name))
		for p in self.param_dic:
			if (type == None) or (type == self.param_dic[p].get_type()):
				
				features = ''
				features += '-W' if self.param_dic[p].is_windowed() else ''
				features += '-A' if self.param_dic[p].is_window_accompany() else ''

				print("param " + str(p) 
					+ ":\ttype: %-4s" % str(self.param_dic[p].get_type() + features) 
					+ "\tval: " + str(self.param_dic[p].get_val()) 
					+ "\tvals: " + str(self.param_dic[p].get_vals()))
		print("")

	def set_name(self, name):
		self.name = name

	def get_name(self):
		return self.name
		