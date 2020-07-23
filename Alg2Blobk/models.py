import numpy as np
import copy
from utils import * 
from MLBlock_2Dflex import gen_HDLs

class Param():
	def __init__(self, type="IW", window_en=False, vals=None):
		self.type = type 
		self.set_window_en(window_en)
		self.set_vals(vals)

	def set_window_en(self, window_en):
		self.window_en = False if (window_en == None) else window_en
		
	def set_vals(self, vals):
		self.vals = [1] if (vals == None) else vals
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
		self.scores= []

	def set_IO_Comp_spaces(self):
		for i in self.param_dic:

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
					precisions=	{	
									"I" : 8,
									"W" : 8,
									"O" : 32,
								},
					size=	{	
								"x" : 3,
								"y" : 4,
							},
					limits=	{	
								"IO_I" : 36,
								"IO_W" : None,
								"IO_O" : None,
								"IO" : 48+30+18+27+48 	# = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
							}
					):	

		self.name = name 
		self.stationary = stationary	
		self.precisions = precisions
		self.space = space
		self.size = size
		self.nmac = size["x"] * size["y"]
		self.limits = limits
		self.confs = {}
		
		if conf_dic != None:
			for i in conf_dic:
				self.confs[i] = Config(i, conf_dic[i], space, stationary, precisions, limits)

	def explore_config(self, algs_light, prune_methode="old", implementation_methode="old", verbose=True):
		# generate all possible configs (considering IO, # of MACs limits)
		self.gen_all_config(self.space)
		print_("%d configurations are generated - cisidering IO limits" % (len(self.confs)), verbose)

		# measure the configuration scheduling abilities
		print_("Scoring the configurations regarding scheduling is started. Wait!", verbose)		
		if prune_methode == "old":
			self.rate_arch(algs_light)
		elif prune_methode == "new":
			self.rate_arch_new(algs_light)

		# remove non-used configs (non-used means it never ever used as the best case of scheduling for any benchmark points)
		print_("Removing non-used configurations.", verbose)	
		if prune_methode == "old":
			self.remove_zero_scores()
			self.reset_confs_score()
		elif prune_methode == "new":
			self.remove_nonnecessary_confs()
		print_("Remaining configurations: %5d" % (len(self.confs)), verbose)

		# print the remain configs
		print_("\n***** Selected configurations *****\n", verbose)
		self.print_confs()
		# print dot product shapes
		self.print_confs(cat=["IW"])

		# implementation configurations
		print_("\n***** creating implementation configurations *****\n", verbose)
		if implementation_methode == "old":
			self.gen_imp_confs()
		elif implementation_methode == "new":
			self.gen_imp_confs_new()
		print_("\n***** generating the verilog file *****\n", verbose)
		self.gen_verilog()

	def gen_all_config(self, space):
		temp_dic = copy.deepcopy(space.param_dic)
		self.confs = {}
		counter = 0
		for case in param_gen_const_product(space.size, self.nmac):
			temp_dic = fill_dic_by_array(temp_dic, case)
			conf_name = 'conf_' + str(counter)
			conf = Config(conf_name , temp_dic, space, self.stationary, self.precisions, self.limits)
			if conf.OK():
				self.confs[conf_name] = conf
			counter += 1

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

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))
	
	def rate_arch_new(self, algs):
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				conf_best = []
				for conf in self.confs:
					conf_dic = self.confs[conf].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, conf_dic)
					
					if rate_temp > rate_best:
						rate_best = rate_temp
						conf_best = [conf]
					elif rate_temp == rate_best:
						conf_best.append(conf)

				for conf in self.confs:
					if conf in conf_best:
						self.confs[conf].scores.append(1)
					else:
						self.confs[conf].scores.append(0)
					
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))

	def remove_zero_scores(self):
		list_to_remove = []
		for conf in self.confs:
			if self.confs[conf].score == 0:
				list_to_remove.append(conf)

		for conf in list_to_remove:
			del self.confs[conf]

	def remove_nonnecessary_confs(self):
		conf_names = []
		table = []
		for conf in self.confs:
			conf_names.append(conf)
			if len(table) == 0:
				table = np.reshape(np.array(self.confs[conf].scores), (-1,1))
			else:
				table = np.append(table, np.reshape(self.confs[conf].scores, (-1,1)), axis=1)

		print(len(conf_names))
		print(conf_names)
		print(table.shape)
		print(table)
		cols, costs = pick_optimum_necessary_cols(table, np.ones(table.shape[1]))
		print(cols, costs)
		exit()



		list_to_remove = []
		for conf in self.confs:
			if self.confs[conf].score == 0:
				list_to_remove.append(conf)

		for conf in list_to_remove:
			del self.confs[conf]



	def util_rate(self, alg_p_dic, conf_p_dic):
		alg_arr = dic2nparr(alg_p_dic)
		conf_arr = dic2nparr(conf_p_dic)

		alg_mac = arr2prod(alg_arr)
		conf_mac = arr2prod(conf_arr)
		conf_iter = arr2prod(np.ceil(alg_arr / conf_arr))

		return alg_mac / (conf_mac * conf_iter)

	def print_confs(self, cat=None):
		for conf in self.confs:
			if type(cat) is list:
				for c in cat:
					self.confs[conf].print_param_dic(c)
			else:
				self.confs[conf].print_param_dic(cat)

	def reset_confs_score(self):
		for conf in self.confs:
			self.confs[conf].reset_score()
	

	def conf_to_impconf(self, conf):
		impconfig = {	"U_IW_W":	1,		
						"U_IW_NW":	1,		
						"U_WO": 	1,
						"U_IO": 	1,
						"U_IWO": 	1,}		
					
		for p in conf.param_dic:
			if conf.param_dic[p].type != "IW":
				impconfig["U_%s"%(conf.param_dic[p].type)] *=  conf.param_dic[p].vals
			elif conf.param_dic[p].window_en != True:
				impconfig["U_IW_NW"] *=  conf.param_dic[p].vals
			else:
				impconfig["U_IW_W"] *=  conf.param_dic[p].vals

		return impconfig

	def impconf_iscovered(self, impconfig_new, impconfigs):
		for ic in impconfigs:
			if (impconfigs[ic]["U_IW_W"] == impconfig_new["U_IW_W"]):
				if (impconfigs[ic]["U_IW_NW"] == impconfig_new["U_IW_NW"]):
					if (impconfigs[ic]["U_WO"] == impconfig_new["U_WO"]):
						if (impconfigs[ic]["U_IO"] * impconfigs[ic]["U_IWO"] == impconfig_new["U_IO"] * impconfig_new["U_IWO"]):
							return True
		return False

	def gen_imp_confs_new(self):
		self.impconfigs = {}
		counter = 0
		for conf in self.confs:
			impconfig_new = self.conf_to_impconf(self.confs[conf])
			print (impconfig_new)
			
			if (not self.impconf_iscovered(impconfig_new, self.impconfigs)):
				self.impconfigs["conf_%d"%(counter)] = impconfig_new
				counter += 1

		print(self.impconfigs)

		I_D = 4
		W_D = 4
		RES_D = 1
		SHIFTER_TYPE = "2Wx2V_by_WxV"	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"

		gen_HDLs("MLBlock_2Dflex", self.impconfigs, self.nmac, 
			self.precisions["I"], I_D, 
			self.precisions["W"], W_D, 
			self.precisions["O"], RES_D, 
			SHIFTER_TYPE)

			



'''
	def gen_imp_confs(self):
		self.flex={
			"A" : "",
			"B" : "",
			"RES" : "",
		}
		self.IOs ={
			"I": 0,
			"W": 0,
			"O": 0,
		}
		self.confs_imp = {
						"00":{	"P": self.size["y"],
								"N": 1,
								"W": self.size["x"],
								"in_flex": 0,
								"out_flex": 0,
								"nes" : False,
								"confs": [],
								"nofconfs": 0,
								"scales": []
							},
						"01":{	"P": self.size["x"],
								"N": self.size["y"],
								"W": 1,
								"in_flex": 0,
								"out_flex": 1,
								"nes" : False,
								"confs": [],
								"nofconfs": 0,
								"scales": []
							},
						"10":{	"P": self.size["x"],
								"N": 1,
								"W": self.size["y"],
								"in_flex": 1,
								"out_flex": 0,
								"nes" : False,
								"confs": [],
								"nofconfs": 0,
								"scales": []
							},
						"11":{	"P": self.size["y"],
								"N": self.size["x"],
								"W": 1,
								"in_flex": 1,
								"out_flex": 1,
								"nes" : False,
								"confs": [],
								"nofconfs": 0,
								"scales": []
							}
						}

		for conf in self.confs:
			dic = {	"P": 1,		# Parallel
					"N": 1,		# Normal/Non-windowed
					"W": 1}		# Windowed
					
			for p in self.confs[conf].param_dic:
				if self.confs[conf].param_dic[p].type != "IW":
					dic["P"] *=  self.confs[conf].param_dic[p].vals
				elif self.confs[conf].param_dic[p].window_en != True:
					dic["N"] *=  self.confs[conf].param_dic[p].vals
				else:
					dic["W"] *=  self.confs[conf].param_dic[p].vals

			necessary = []
			for conf_imp in self.confs_imp:
				scale = check_scale_P_N_W(self.confs_imp[conf_imp], dic)
				
				if scale != None:
					self.confs_imp[conf_imp]["confs"].append(conf)
					self.confs_imp[conf_imp]["nofconfs"] += 1
					necessary.append(conf_imp)
					if scale not in self.confs_imp[conf_imp]["scales"]:
						self.confs_imp[conf_imp]["scales"].append(scale)
			
			if len(necessary) == 1:
				self.confs_imp[necessary[0]]["nes"] = True

		for conf_imp in self.confs_imp:

			print("implementation config: " + str(conf_imp)) 
			for temp in self.confs_imp[conf_imp]:
				print("\t" + temp + ": " + str(self.confs_imp[conf_imp][temp]))


		# IOs
		for conf in self.confs:
			for io in self.IOs:
				temp = self.confs[conf].IO_report([io])
				if (self.IOs[io] < temp):
					self.IOs[io] = temp

		self.IOs["W"] = max(self.size["x"],self.size["y"]) * self.precisions["W"]
		print(self.IOs)
		
		if (self.confs_imp["00"]["nofconfs"] + self.confs_imp["01"]["nofconfs"] > 0):
			if (self.confs_imp["10"]["nofconfs"] + self.confs_imp["11"]["nofconfs"] > 0):
				self.flex["A"] = "FLEXIBLE"
			else:
				self.flex["A"] = "FIXED_H"
		else:
			self.flex["A"] = "FIXED_V"

		if (self.confs_imp["00"]["nofconfs"] + self.confs_imp["10"]["nofconfs"] > 0):
			if (self.confs_imp["01"]["nofconfs"] + self.confs_imp["11"]["nofconfs"] > 0):
				self.flex["RES"] = "FLEXIBLE"
			else:
				self.flex["RES"] = "FIXED_V"
		else:
			self.flex["RES"] = "FIXED_H"

		self.flex["B"] = "FIXED_V"

		print(self.flex)


	def gen_verilog(self):

		filename = "MLBlock.v"

		f = open(filename, "w")
		f.write("// This is generated by the tool. dont change\n")
		f.write("module MLBlock (\n")
		f.write("\t\tclk,\n")
		f.write("\t\treset,\n")
		f.write("\n")
		f.write("\t\thp_en,\n")
		f.write("\t\ta_en,\n")
		f.write("\t\ta,\n")
		f.write("\t\ta_out,\n")
		f.write("\n")
		f.write("\t\tb_en,\n")
		f.write("\t\tb,\n")
		f.write("\t\tb_cas_in,\n")
		f.write("\t\tb_out,\n")
		f.write("\t\tb_cas_out,\n")
		f.write("\n")
		f.write("\t\tacc_en,\n")
		f.write("\t\tres_cas_in,\n")
		f.write("\t\tres_out,\n")
		f.write("\t\tres_cas_out,\n")
		f.write("\n")
		f.write("\t\tconfig_en,\n")
		f.write("\t\tconfig_in,\n")
		f.write("\t\tconfig_out\n")
		f.write("\t);\n")
		f.write("\n")
		f.write("\t///////// Parameters\n")
		f.write("\tparameter PE_W = %d;\n" % (self.size["x"]))
		f.write("\tparameter PE_H = %d;\n" % (self.size["y"]))
		f.write("\n")
		f.write("\t\n")
		f.write("\t\n")
		f.write("\t\n")
		

		a_in_h_temp = []
		a_in_v_temp = []
		b_in_h_temp = []
		b_in_v_temp = []
		res_in_h_temp = []
		res_in_v_temp = []
		
		f.close()
'''
