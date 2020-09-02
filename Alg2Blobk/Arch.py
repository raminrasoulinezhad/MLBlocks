import copy
import time
import random
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

	def search_full(self, algs, randomness=False, verbose=True):
		self.unrollings = self.gen_possible_unrollings(self.space, verbose)
		self.impconfigs = self.gen_imp_confs(self.unrollings, filter_methode="unique")

		best_case = 0
		best_rate = 0
		self.set_total_number_of_arch_sample()

		if randomness == True:
			the_range = random.choices(range(self.total_number_of_arch_sample), k=10)
		else:
			the_range = range(self.total_number_of_arch_sample)

		for case in the_range:
			t0 = time.time()
			self.get_arch_sample(self.impconfigs, case)

			unrollings_temp = {}
			for impconfig in self.impconfigs:
				if impconfig.enable_mask == 1:
					for i in impconfig.unrollings:
						unrollings_temp[i] = self.unrollings[i]
			
			rate = self.rate_arch(unrollings_temp, algs, scoring=False, verbose=False)		
			t1 = time.time()
			if (best_rate < rate):
				best_rate = rate
				best_case = case

			print("rate: %f, time: %f (sec)" % (rate, t1-t0))
			if ((case+1) % 100 == 0):
				print ("system is working: %d\%" % (((case+1)*100) / self.total_number_of_arch_sample))

		print("best rate: %f " % best_rate)
		
		self.get_arch_sample(self.impconfigs, best_case)

		counter = 0
		impconfigs_temp = []
		for impconfig in self.impconfigs:
			if impconfig.enable_mask:
				impconfig.name = "impconf_%d" % (counter)
				counter += 1
				impconfigs_temp.append(impconfig)

		gen_HDLs(self.dir, "MLBlock_2Dflex_best", impconfigs_temp, self.nmac, 
			self.precisions["I"], self.I_D, 
			self.precisions["W"], self.W_D, 
			self.precisions["O"], self.RES_D, 
			self.SHIFTER_TYPE,
			verbose=False)


	def search_heuristic(self, algs, prune_methode="old", verbose=True):
		# generate all possible unrollings (considering IO, # of MACs limits)
		self.unrollings = self.gen_possible_unrollings(self.space, verbose)

		# measure the unrollings scheduling abilities
		print_("Scoring the unrollings regarding scheduling is started. Wait!", verbose)		
		if prune_methode == "old":
			rate_report = self.rate_arch(self.unrollings, algs)
			print("Average utilization rate: %.5f" % (rate_report))
		elif prune_methode == "new":
			self.rate_arch_new(self.unrollings, algs)

		# remove non-used unrollings (non-used means it never ever used as the best case of scheduling for any benchmark points)
		print_("Removing non-used unrollings.", verbose)	
		if prune_methode == "old":
			self.remove_zero_scores()
			self.reset_unrollings_score()
		elif prune_methode == "new":
			self.remove_nonnecessary_unrollings()
		print_("Remaining unrollings: %5d" % (len(self.unrollings)), verbose)

		# print the remaining unrollings
		print_("\n***** Selected unrollings *****\n", verbose)
		self.print_unrollings(self.unrollings)
		# print dot product shapes
		self.print_unrollings(self.unrollings, cat=["IW"])

		# implementation configurations
		print_("\n***** generating verilog model of MLBlock_2Dflex *****\n", verbose)
		self.impconfigs = self.gen_imp_confs(self.unrollings, filter_methode="covered")
		gen_HDLs(self.dir, "MLBlock_2Dflex", self.impconfigs, self.nmac, 
			self.precisions["I"], self.I_D, 
			self.precisions["W"], self.W_D, 
			self.precisions["O"], self.RES_D, 
			self.SHIFTER_TYPE,
			verbose=False)

	def search_heuristic_v2(self, algs, verbose=True):

		self.unrollings = self.gen_possible_unrollings(self.space, verbose)
	
		print("let's prune the unrollings :) ")
		self.unrollings_pruned = self.rate_and_prune_unrollings(self.unrollings, algs)
		print("unrollings are pruned")

		self.print_unrollings(self.unrollings_pruned)
		self.print_unrollings(self.unrollings_pruned, cat=["IW"])

		self.impconfigs = self.gen_imp_confs(self.unrollings_pruned, filter_methode="covered")

		gen_HDLs(self.dir, "MLBlock_2Dflex", self.impconfigs, self.nmac, 
			self.precisions["I"], self.I_D, 
			self.precisions["W"], self.W_D, 
			self.precisions["O"], self.RES_D, 
			self.SHIFTER_TYPE,
			verbose=False)

	def gen_possible_unrollings(self, space, verbose):
		space_dic = copy.deepcopy(space.param_dic)
		unrollings_valid = {}
		counter = 0
		for case in param_gen_const_product(space.size, self.nmac):
			temp_dic = fill_dic_by_array(space_dic, case)
			unrolling_name = 'unrolling_' + str(counter)
			unrolling = Unrolling(unrolling_name , temp_dic, space, self.stationary, self.precisions, self.limits)
			if unrolling.OK():
				unrollings_valid[unrolling_name] = unrolling
				unrolling.print_param_dic()
				counter += 1

		print_("%d Unrollings are generated - cisidering IO limits" % (len(unrollings_valid)), verbose)
		return unrollings_valid

	def rate_arch(self, unrollings, algs, scoring=True, verbose=True):
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				unrolling_best = ""
				for unrolling in unrollings:
					unrolling_dic = unrollings[unrolling].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, unrolling_dic)
					if rate_temp > rate_best:
						rate_best = rate_temp
						unrolling_best = unrolling
				if scoring:
					unrollings[unrolling_best].score += 1
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		rate_report = 0
		for rate in rate_algs:
			rate_report += rate_algs[rate]
			if (verbose):
				print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))

		return rate_report / len(rate_algs)
		
	
	def rate_arch_new(self, unrollings, algs):
		print ("$$$$ Under development $$$$$")
		rate_algs = {}

		for alg in algs: 
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = 0
				unrolling_best = []
				for unrolling in unrollings:
					unrolling_dic = unrollings[unrolling].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, unrolling_dic)
					
					if rate_temp > rate_best:
						rate_best = rate_temp
						unrolling_best = [unrolling]
					elif rate_temp == rate_best:
						unrolling_best.append(unrolling)

				for unrolling in unrollings:
					if unrolling in unrolling_best:
						unrollings[unrolling].scores.append(1)
					else:
						unrollings[unrolling].scores.append(0)
					
				rate_total += rate_best				

			rate_algs[alg.name] = rate_total/alg.total_cases

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))


	def rate_and_prune_unrollings (self, unrollings, algs):
		rate_algs = {}
		
		unrollings_selected = {}
		counter = 0

		trate = 0
		tcase = 0

		for alg in algs: 
			print( "\n -- evaluating alg: %s" % (alg.get_name()) )
			rate_total = 0 
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)

				rate_best = -1
				best_list = []
				for unrolling in unrollings:
					unrolling_dic = unrollings[unrolling].gen_dic()
					rate_temp = self.util_rate(alg_case_dic, unrolling_dic)

					if rate_temp > rate_best:
						rate_best = rate_temp
						unrolling_best = unrolling
						best_list = [unrolling]
					elif rate_temp == rate_best:
						best_list.append(unrolling)
				
				print(" ------ best rate (%0.5f) is by %s" % (rate_best, best_list))
				rate_total += rate_best				

				unrolling_temp = copy.deepcopy(unrollings[unrolling_best])
				
				unrolling_temp.set_stride(alg_case_dic)
				if unrolling_temp.is_new(unrollings_selected):
					temp_name = 'unrolling_selected_' + str(counter)
					unrolling_temp.set_name(temp_name)
					unrollings_selected[temp_name] = unrolling_temp
					counter += 1

			rate_algs[alg.name] = rate_total/alg.total_cases
			tcase += alg.total_cases
			trate += rate_total


		average_rate = trate / tcase

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))
		print("In average :   %.5f" % (average_rate))
		
		unrollings_pruned = unrollings_selected
		return unrollings_pruned 


	def remove_zero_scores(self):
		list_to_remove = []
		for unrolling in self.unrollings:
			if self.unrollings[unrolling].score == 0:
				list_to_remove.append(unrolling)

		for unrolling in list_to_remove:
			del self.unrollings[unrolling]

	def remove_nonnecessary_unrollings(self):
		raise Exception ("it is not working yet !!! :( ")
		unrolling_names = []
		table = []
		for unrolling in self.unrollings:
			unrolling_names.append(unrolling)
			if len(table) == 0:
				table = np.reshape(np.array(self.unrollings[unrolling].scores), (-1,1))
			else:
				table = np.append(table, np.reshape(self.unrollings[unrolling].scores, (-1,1)), axis=1)

		print(len(unrolling_names))
		print(unrolling_names)
		print(table.shape)
		print(table)
		cols, costs = pick_optimum_necessary_cols(table, np.ones(table.shape[1]))
		print(cols, costs)
		exit()

		list_to_remove = []
		for unrolling in self.unrollings:
			if self.unrollings[unrolling].score == 0:
				list_to_remove.append(unrolling)

		for unrolling in list_to_remove:
			del self.unrollings[unrolling]

	def util_rate(self, alg_p_dic, unrolling_p_dic):
		alg_arr = dic2nparr(alg_p_dic, 0)
		unrolling_arr = dic2nparr(unrolling_p_dic, 0)
		alg_mac = arr2prod(alg_arr)
		unrolling_mac = arr2prod(unrolling_arr)
		unrolling_iter = arr2prod(np.ceil(alg_arr / unrolling_arr))

		return alg_mac / (unrolling_mac * unrolling_iter)

	def print_unrollings(self, unrollings, cat=None):
		for unrolling in unrollings:
			if type(cat) is list:
				for c in cat:
					unrollings[unrolling].print_param_dic(c)
			else:
				unrollings[unrolling].print_param_dic(cat)

	def reset_unrollings_score(self):
		for unrolling in self.unrollings:
			self.unrollings[unrolling].reset_score()
	
	def gen_imp_confs(self, unrollings, filter_methode="covered"):
		impconfigs = []
		counter = 0
		for unrolling in unrollings:
			impconfig = ImpConfig()
			impconfig.conf_to_impconf(unrollings[unrolling])
			
			if (not impconfig.isnew(impconfigs, unrollings[unrolling].name, methode=filter_methode)):		
				impconfig.set_name("impconf_%d"%(counter))
				impconfig.add_unrolling_name(unrollings[unrolling].name)
				impconfigs.append(impconfig)
				counter += 1

		for impconfig in impconfigs:
			impconfig.print()

		return impconfigs

	def set_total_number_of_arch_sample(self):
		total_configs = len(self.impconfigs)
		self.total_number_of_arch_sample = 2 ** total_configs

	def get_arch_sample(self, impconfigs, index):
		for imp in impconfigs:
			if (index % 2):
				imp.enable_mask = 1
			else:
				imp.enable_mask = 0
			index = index // 2
