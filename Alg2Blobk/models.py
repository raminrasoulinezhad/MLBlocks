import numpy as np
import copy
from utils import * 

class Param():
	def __init__(self, type="IW", window_en=False, vals=None):
		self.type = type 

		self.set_window_en(window_en)

		self.set_vals(vals)
				

	def set_window_en(self, window_en):
		# if a parameter is used with an acompany in inputs and has disapears in outputs.
		if window_en == None:
			self.window_en = False
		else:
			self.window_en = window_en
		
	def set_vals(self, vals):
		if vals == None:
			self.vals = [1]
		else:
			self.vals = vals
		self.update_vals_size()
	
	def update_vals_size(self):
		self.vals_size = len(self.vals)

class Space():		
	def __init__(self, name, param_dic):
		self.name = name
		self.param_dic = copy.deepcopy(param_dic)
		self.size = len(self.param_dic)

	def print_param_dic(self, type=None):
		print("Model name: " + str(self.name))
		for p in self.param_dic:
			if (type == None) or (type == self.param_dic[p].type):
				print("param name: " + str(p) + "\ttype: %3s" % str(self.param_dic[p].type) + "\twindow: %6s" % str(self.param_dic[p].window_en) + ", \tvals: " + str(self.param_dic[p].vals))
		print("")

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


class Config(Space):
	def __init__(self, name, param_dic, space, stationary, precisions, limits):
		super().__init__(name, space.param_dic)	
		
		for i in param_dic:
			self.param_dic[i].vals = param_dic[i]
		
		self.stationary = stationary 
		self.precisions = precisions
		self.limits = limits

		self.spaces_lists = ["I","W","O","IW","WO","IO","IWO"]
		self.IO_Comp_spaces = {}
		for i in self.spaces_lists:
			self.IO_Comp_spaces[i] = {"size" : 1, "dic": {}}

		self.set_IO_Comp_spaces()

		self.score = 0


	def set_IO_Comp_spaces(self):
		for i in self.param_dic:

			#for j in self.spaces_lists:
			#	if check_presence(j, self.param_dic[i].type):
			#		self.IO_Comp_spaces[j]["size"] *= self.param_dic[i].vals
			#		self.IO_Comp_spaces[j]["dic"][i] = self.param_dic[i].vals

			for j in self.spaces_lists[0:3]:
				if check_presence(j, self.param_dic[i].type):
					if not self.param_dic[i].window_en:
						self.IO_Comp_spaces[j]["size"] *= self.param_dic[i].vals
					self.IO_Comp_spaces[j]["dic"][i] = self.param_dic[i].vals

			for j in self.spaces_lists[3:]:
				if check_equality(j, self.param_dic[i].type):
					if not self.param_dic[i].window_en:
						self.IO_Comp_spaces[j]["size"] *= self.param_dic[i].vals
					self.IO_Comp_spaces[j]["dic"][i] = self.param_dic[i].vals

		for i in self.IO_Comp_spaces:
			print(str(i) + 	str(self.IO_Comp_spaces[i]))
		print("****")

	def print_IO_Comp_spaces(self):
		for i in self.IO_Comp_spaces:
			print(str(i) + 	str(self.IO_Comp_spaces[i]))
		print("****")

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
			dic[p] = self.param_dic[p].vals
		return dic

	def reset_score(self):
		self.score = 0



class Arch(Space):
	def __init__(	self, 
					name, 
					conf_dic, 
					space, 
					stationary="W",						# W, I, O
					precisions=	{	"I" : 8,
									"W" : 8,
									"O" : 32,
								},
					nmac=8,
					limits= {	"IO_I" : 36,
								"IO_W" : None,
								"IO_O" : None,
								"IO" : 48+30+18+27+48 	# = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
							}
					):	

		self.name = name 

		self.stationary = stationary	
		self.precisions = precisions
		self.nmac = nmac
		self.limits = limits

		self.confs = {}
		
		if conf_dic == None:
			self.gen_all_config(space)
		else:
			for i in conf_dic:
				self.confs[i] = Config(i, conf_dic[i], space, stationary, precisions, limits)

	def gen_all_config(self, space):

		temp_dic = copy.deepcopy(space.param_dic)

		conf_counter = 0
		for case in param_gen_const_product(space.size, self.nmac):
			
			temp_dic = fill_dic_by_array(temp_dic, case)
			conf_name = 'conf' + str(conf_counter)

			conf = Config(conf_name , temp_dic, space, self.stationary, self.precisions, self.limits)
			if conf.OK():
				self.confs[conf_name] = conf
				
			conf_counter += 1

	def rate_arch(self, algs):
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				conf_best = ""
				for conf in self.confs:
					conf_dic = self.confs[conf].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, conf_dic)
					if rate_temp > rate_best:
						rate_best = rate_temp
						conf_best = conf

				self.confs[conf_best].score += 1
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		return rate_algs
	
	def util_rate(self, alg_p_dic, conf_p_dic):

		alg_arr = np.array([])
		conf_arr = np.array([])
		for p in alg_p_dic:
			alg_arr = np.append(alg_arr, alg_p_dic[p])
			conf_arr = np.append(conf_arr, conf_p_dic[p])

		alg_mac = arr2prod(alg_arr)
		conf_mac = arr2prod(conf_arr)

		conf_iter = arr2prod(np.ceil(alg_arr / conf_arr))

		return alg_mac / (conf_mac * conf_iter)

	def print_confs(self, type=None):
		for conf in self.confs:
			self.confs[conf].print_param_dic(type)

	def reset_confs_score(self):
		for conf in self.confs:
			self.confs[conf].reset_score()

	