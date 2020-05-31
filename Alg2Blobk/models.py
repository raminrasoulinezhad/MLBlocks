import numpy as np
import copy
from utils import * 

class Param:
	def __init__(self, type="IW", window_en=False, pot_vals=None):
		self.type = type 
		
		self.IOs_I = self.IOs_W = self.IOs_O = False 
		if "I" in type:
			self.IOs_I = True
		if "W" in type:
			self.IOs_W = True 
		if "O" in type:
			self.IOs_O = True

		if window_en == None:
			self.window_en = False
		else:
			# if a parameter is used with an acompany in inputs and has disapears in outputs.
			self.window_en = window_en

		if pot_vals == None:
			self.pot_vals = [1]
		else:
			self.pot_vals = pot_vals

class Space():		
	def __init__(self, name, param_dic):
		self.name = name
		self.param_dic = copy.deepcopy(param_dic)
		

	def print_param_dic(self):
		print("Model name: " + str(self.name))
		for p in self.param_dic:
			print("param name: " + str(p) + "\ttype: %3s" % str(self.param_dic[p].type) + "\twindow: %6s" % str(self.param_dic[p].window_en) + ", \tvals: " + str(self.param_dic[p].pot_vals))
		print("")


class Algorithm(Space):
	def __init__(self, name, pot_vals_dic, space):

		super().__init__(name, space.param_dic)	

		temp = 1
		for i in pot_vals_dic:
			self.param_dic[i].pot_vals = pot_vals_dic[i] if (pot_vals_dic[i] != None) else [1]
			temp *= len(self.param_dic[i].pot_vals)
		self.total_cases = temp

	def case_gen(self, index):
		case = {}
		for p in self.param_dic:
			w = len(self.param_dic[p].pot_vals)
			case[p] = self.param_dic[p].pot_vals[index % w]
			index = int(np.floor(index / w))
		return case


class Config(Space):
	def __init__(self, name, param_dic, space):
		super().__init__(name, space.param_dic)	
		
		for i in param_dic:
			self.param_dic[i].pot_vals = param_dic[i]
		
	def gen_dic(self):
		dic = {}
		for p in self.param_dic:
			dic[p] = self.param_dic[p].pot_vals
		return dic

class Arch(Space):
	def __init__(self, name, conf_dic, space):
		self.name = name 

		self.confs = {}
		for i in conf_dic:
			self.confs[i] = Config(i, conf_dic[i], space)

	

	def rate_arch(self, algs):
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				for conf in self.confs:
					conf_dic = self.confs[conf].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, conf_dic)
					if rate_temp > rate_best:
						rate_best = rate_temp

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



		
my_space = Space("space",
				{	"d":	Param("IOW",	window_en=False),
					"b":	Param("IO",		window_en=False),
					"k":	Param("WO",		window_en=False),
					"c":	Param("IW",		window_en=False),
					"y":	Param("IO",		window_en=False),
					"x":	Param("IO",		window_en=False),
					"fy":	Param("IW",		window_en=True),
					"fx":	Param("IW",		window_en=True)
				})



alg_BSConv = Algorithm("BSConv", 
						{	"d":	None,
							"b":	[1,2,4],
							"k":	[32,64,128,256,512,1024],
							"c":	[3,32,64,128,256,512,1024],
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

alg_BDWConv = Algorithm("BDWConv", {
							"d":	[32,64,128,256,512,1024],
							"b":	[1,2,4],
							"k":	None,
							"c":	None,
							"y":	[2,4,8,16,32],
							"x":	[2,4,8,16,32],
							"fy":	[3,5,7,9],
							"fx":	[3,5,7,9]
						}, my_space)

alg_BPWConv = Algorithm("BPWConv", 
						{	"d":	None, 
							"b":	[1,2,4], 
							"k":	[32,64,128,256,512,1024], 
							"c":	[3,32,64,128,256,512,1024], 
							"y":	[2,4,8,16,32], 
							"x":	[2,4,8,16,32], 
							"fy":	None, 
							"fx":	None 
						}, my_space)


algs = [alg_BSConv, alg_BDWConv, alg_BPWConv]
for alg in algs:
	alg.print_param_dic()
	print(alg.case_gen(5))
	print()

arch = Arch("MLBlock", 
			{
				"conf_0" : {
					"d":	4,
					"b":	1,
					"k":	1,
					"c":	1,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	3
				},
				"conf_1" : {
					"d":	1,
					"b":	1,
					"k":	3,
					"c":	4,
					"y":	1,
					"x":	1,
					"fy":	1,
					"fx":	1
				},
			}, 
			my_space)

for conf in arch.confs:
	arch.confs[conf].print_param_dic()


print (arch.rate_arch(algs))




#def util_rate(alg_sample, conf_sample):
#	alg_mac = arr2prod(alg_sample)
#	conf_mac = arr2prod(conf_sample)
#
#	conf_iter = arr2prod(np.ceil(alg_sample / conf_sample))
#
#	return alg_mac / (conf_mac * conf_iter)
#
#alg  = np.array([1, 200, 5, 5, 5, 1])
#conf = np.array([1, 3,   1, 1, 3, 1])
#rate = util_rate(alg, conf)
#print ("rate: %f" % (rate))


# main 
# setup space and algorithms.
# for loop for different architectures
#		measure the feasiblity and cost function for that
# pich top few ones. 