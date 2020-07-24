import copy
from utils import * 

from Space import Space
from Unrolling import Unrolling
from ImpConfig import ImpConfig 
from MLBlock_2Dflex import gen_HDLs

class Arch(Space):
	def __init__(	self, 
					name, 
					unrollings_dic, 
					space, 
					stationary="W",						# W, I, O
					precisions=	{	
									"I" : 8,
									"W" : 8,
									"O" : 32,
								},
					subprecisions=	{	
									"I_D" : 2,
									"W_D" : 3,
									"RES_D" : 1,
									"SHIFTER_TYPE" : "2Wx2V_by_WxV",	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
								},
					nmac=12,
					limits=	{	
								"IO_I" : 36,
								"IO_W" : None,
								"IO_O" : None,
								"IO" : 48+30+18+27+48 	# = DSP48_out + DSP48_A + DSP48_B + DSP48_C + DSP48_D
							}
					):	

		self.name = name
		self.dir = "../verilog/" 
		self.stationary = stationary	
		self.precisions = precisions
		self.space = space
		self.nmac = nmac

		self.I_D = subprecisions["I_D"]
		self.W_D = subprecisions["W_D"]
		self.RES_D = subprecisions["RES_D"]
		self.SHIFTER_TYPE = subprecisions["SHIFTER_TYPE"]

		self.limits = limits
		self.unrollings = {}
		
		if unrollings_dic != None:
			for i in unrollings_dic:
				self.unrollings[i] = Unrolling(i, unrollings_dic[i], space, stationary, precisions, limits)

	def search_full(self, algs_light, verbose=True):
		self.gen_all_unrollings(self.space)
		print_("%d configurations are generated - cisidering IO limits" % (len(self.unrollings)), verbose)
		self.gen_imp_confs()
		return 

	def search_heuristic(self, algs_light, prune_methode="old", verbose=True):
		# generate all possible configs (considering IO, # of MACs limits)
		self.gen_all_unrollings(self.space)
		print_("%d configurations are generated - cisidering IO limits" % (len(self.unrollings)), verbose)

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
			self.reset_unrollings_score()
		elif prune_methode == "new":
			self.remove_nonnecessary_confs()
		print_("Remaining configurations: %5d" % (len(self.unrollings)), verbose)

		# print the remain configs
		print_("\n***** Selected configurations *****\n", verbose)
		self.print_unrollings()
		# print dot product shapes
		self.print_unrollings(cat=["IW"])

		# implementation configurations
		print_("\n***** generating verilog model of MLBlock_2Dflex *****\n", verbose)
		self.gen_imp_confs()
		gen_HDLs(self.dir, "MLBlock_2Dflex", self.impconfigs, self.nmac, 
			self.precisions["I"], self.I_D, 
			self.precisions["W"], self.W_D, 
			self.precisions["O"], self.RES_D, 
			self.SHIFTER_TYPE,
			verbose=False)

	def gen_all_unrollings(self, space):
		temp_dic = copy.deepcopy(space.param_dic)
		self.unrollings = {}
		counter = 0
		for case in param_gen_const_product(space.size, self.nmac):
			temp_dic = fill_dic_by_array(temp_dic, case)
			conf_name = 'conf_' + str(counter)
			unrolling = Unrolling(conf_name , temp_dic, space, self.stationary, self.precisions, self.limits)
			if unrolling.OK():
				self.unrollings[conf_name] = unrolling
				unrolling.print_param_dic()
			counter += 1

	def rate_arch(self, algs):
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				conf_best = ""
				for conf in self.unrollings:
					unrolling_dic = self.unrollings[conf].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, unrolling_dic)
					if rate_temp > rate_best:
						rate_best = rate_temp
						conf_best = conf

				self.unrollings[conf_best].score += 1
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))
	
	def rate_arch_new(self, algs):
		print ("$$$$ Under development $$$$$")
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				conf_best = []
				for conf in self.unrollings:
					unrolling_dic = self.unrollings[conf].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, unrolling_dic)
					
					if rate_temp > rate_best:
						rate_best = rate_temp
						conf_best = [conf]
					elif rate_temp == rate_best:
						conf_best.append(conf)

				for conf in self.unrollings:
					if conf in conf_best:
						self.unrollings[conf].scores.append(1)
					else:
						self.unrollings[conf].scores.append(0)
					
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))

	def remove_zero_scores(self):
		list_to_remove = []
		for conf in self.unrollings:
			if self.unrollings[conf].score == 0:
				list_to_remove.append(conf)

		for conf in list_to_remove:
			del self.unrollings[conf]

	def remove_nonnecessary_confs(self):
		conf_names = []
		table = []
		for conf in self.unrollings:
			conf_names.append(conf)
			if len(table) == 0:
				table = np.reshape(np.array(self.unrollings[conf].scores), (-1,1))
			else:
				table = np.append(table, np.reshape(self.unrollings[conf].scores, (-1,1)), axis=1)

		print(len(conf_names))
		print(conf_names)
		print(table.shape)
		print(table)
		cols, costs = pick_optimum_necessary_cols(table, np.ones(table.shape[1]))
		print(cols, costs)
		exit()



		list_to_remove = []
		for conf in self.unrollings:
			if self.unrollings[conf].score == 0:
				list_to_remove.append(conf)

		for conf in list_to_remove:
			del self.unrollings[conf]

	def util_rate(self, alg_p_dic, unrolling_p_dic):
		alg_arr = dic2nparr(alg_p_dic)
		unrolling_arr = dic2nparr(unrolling_p_dic)

		alg_mac = arr2prod(alg_arr)
		unrolling_mac = arr2prod(unrolling_arr)
		unrolling_iter = arr2prod(np.ceil(alg_arr / unrolling_arr))

		return alg_mac / (unrolling_mac * unrolling_iter)

	def print_unrollings(self, cat=None):
		for unrolling in self.unrollings:
			if type(cat) is list:
				for c in cat:
					self.unrollings[unrolling].print_param_dic(c)
			else:
				self.unrollings[unrolling].print_param_dic(cat)

	def reset_unrollings_score(self):
		for unrolling in self.unrollings:
			self.unrollings[unrolling].reset_score()
	
	def gen_imp_confs(self):
		self.impconfigs = []
		counter = 0
		for unrolling in self.unrollings:
			impconfig = ImpConfig()
			impconfig.conf_to_impconf(self.unrollings[unrolling])
			
			if (not impconfig.iscovered(self.impconfigs)):
				impconfig.set_name("impconf_%d"%(counter))
				self.impconfigs.append(impconfig)
				counter += 1

		for impconfig in self.impconfigs:
			impconfig.print()
