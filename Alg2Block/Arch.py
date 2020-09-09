import os
import copy
import time
import random
from utils import * 
import pickle

from Space import Space
from Unrolling import Unrolling
from ImpConfig import ImpConfig 
from MLBlock_2Dflex import gen_HDLs
from tabulate import get_asic_results

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
									"W_D" : 1,
									"RES_D" : 1,
									"SHIFTER_TYPE" : "BYPASS",	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
								},
					# subprecisions:
					#	8x8 				--> I2,W1,Res1, BYPASS   		--double weight--> I2,W2,Res2, BYPASS
					# 	8x8,8x16,16x8,16x16	--> I4,W2,Res1, 2Wx2V_by_WxV 	--double weight--> I4,W2,Res2, 2Wx2V_by_WxV
					# 	multi weigth (M times) --> W and Res should be M times bigger 
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

	def search_full(self, algs, randomness=False, MLblock_version='v2', verbose=True):
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
			version=MLblock_version,
			verbose=False)


	def search_heuristic(self, algs, prune_methode="old", MLblock_version='v2', verbose=True):
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
			version=MLblock_version,
			verbose=False)

	def search_heuristic_v2(self, algs, MLblock_version='v2', heuristic_mode='old', period=1333, verbose=True):

		self.unrollings = self.gen_possible_unrollings(self.space, verbose)
	
		print("let's prune the unrollings :) ")
		self.unrollings_pruned = self.rate_and_prune_unrollings(self.unrollings, algs, heuristic_mode=heuristic_mode)
		print("unrollings are pruned")

		if verbose:
			self.print_unrollings(self.unrollings_pruned)
			self.print_unrollings(self.unrollings_pruned, cat=["IW"])

		self.impconfigs = self.gen_imp_confs(self.unrollings_pruned, filter_methode="covered")

		gen_HDLs(self.dir, "MLBlock_2Dflex", self.impconfigs, self.nmac, 
			self.precisions["I"], self.I_D, 
			self.precisions["W"], self.W_D, 
			self.precisions["O"], self.RES_D, 
			self.SHIFTER_TYPE,
			version=MLblock_version,
			verbose=False)

		model = ''
		if MLblock_version != 'v1':
			model = '_' + MLblock_version
		print ('lets do synthesis which takes time. Please, be patient :) ')
		os.system('cd ../asic && make clean && make asic_MLBlock_2Dflex' + model + '  >/dev/null 2>&1')
		area, freq, power = get_asic_results('../asic/', period=period)
		print ('area: %f\tfreq: %f\tpower: %f' % (area, freq, power))

	def search_area_in_loop (self, algs, subset_length=2, do_gen_hdl=True, do_synthesis=False, period=1333, MLblock_version='v2', objective='obj', verbose=True):

		self.unrollings = self.gen_possible_unrollings(self.space, verbose=verbose)
	
		print("\nLet's find the unrolling and impconfig set")
		self.impconfigs = self.pick_efficient_implementation_configs(self.unrollings, algs, subset_length=subset_length, do_gen_hdl=do_gen_hdl, do_synthesis=do_synthesis, period=period, MLblock_version=MLblock_version, objective=objective, verbose=verbose)

		#gen_HDLs(self.dir, "MLBlock_2Dflex", self.impconfigs, self.nmac, 
		#	self.precisions["I"], self.I_D, 
		#	self.precisions["W"], self.W_D, 
		#	self.precisions["O"], self.RES_D, 
		#	self.SHIFTER_TYPE,
		#	version=MLblock_version,
		#	verbose=False)

	def gen_possible_unrollings(self, space, verbose=True):
		space_dic = copy.deepcopy(space.param_dic)
		unrollings_valid = {}
		counter = 0
		for case in param_gen_const_product(space.size, self.nmac):
			temp_dic = fill_dic_by_array(space_dic, case)
			unrolling_name = 'unrolling_' + str(counter)
			unrolling = Unrolling(unrolling_name , temp_dic, space, self.stationary, self.precisions, self.limits)
			if unrolling.OK():
				unrollings_valid[unrolling_name] = unrolling
				if verbose:
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
					rate_temp = self.util_rate(alg_case_dic, unrollings[unrolling])
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
					rate_temp = self.util_rate(alg_case_dic, unrollings[unrolling])
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


	def rate_and_prune_unrollings (self, unrollings, algs, heuristic_mode='old'):
		rate_algs = {}
		
		selected_unrolls = {}
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
					
					u_copy = copy.deepcopy(unrollings[unrolling])
					u_copy.set_stride(alg_case_dic)
					u_copy.set_IO_Comp_spaces()
					if u_copy.OK():
						rate_temp = self.util_rate(alg_case_dic, unrollings[unrolling])
						if rate_temp > rate_best:
							rate_best = rate_temp
							unrolling_best = unrolling
							best_list = [unrolling]
						elif rate_temp == rate_best:
							best_list.append(unrolling)
				
				print(" ------ best rate (%0.5f) is by %s" % (rate_best, best_list))
				rate_total += rate_best				


				if heuristic_mode == 'new':
		
					already_is_covered = False

					for u in best_list:
						u_copy = copy.deepcopy(unrollings[u])
						u_copy.set_stride(alg_case_dic)
						if u_copy.is_covered(selected_unrolls):
							already_is_covered = True

					if not already_is_covered:
						u_copy = copy.deepcopy(unrollings[unrolling_best])	
						u_copy.set_stride(alg_case_dic)	
						temp_name = 'unrolling_selected_' + str(counter)
						u_copy.set_name(temp_name)
						selected_unrolls[temp_name] = u_copy
						counter += 1				

				else:
					u_copy = copy.deepcopy(unrollings[unrolling_best])
					u_copy.set_stride(alg_case_dic)
					if u_copy.is_new(selected_unrolls):
						temp_name = 'unrolling_selected_' + str(counter)
						u_copy.set_name(temp_name)
						selected_unrolls[temp_name] = u_copy
						counter += 1				

			rate_algs[alg.name] = rate_total/alg.total_cases
			tcase += alg.total_cases
			trate += rate_total


		average_rate = trate / tcase

		for rate in rate_algs:
			print("Algorithm name: %-10s  %.5f" % (rate, rate_algs[rate]))
		print("In average :   %.5f\n" % (average_rate))
		
		return selected_unrolls

	def pick_efficient_implementation_configs (self, unrolls, algs, subset_length=2, do_gen_hdl=True, do_synthesis=False, period=1333, MLblock_version='v2', objective='obj', verbose=True):
		rate_algs = {}
		
		selected_unrolls = {}
		counter = 0

		for alg in algs: 
			print( "\n -- evaluating alg: %s" % (alg.get_name()) )
			for index in range(alg.total_cases):

				alg_case_dic = alg.case_gen(index)
				
				for u in unrolls:
					u_copy = copy.deepcopy(unrolls[u])
					u_copy.set_stride(alg_case_dic)
					u_copy.set_IO_Comp_spaces()

					if u_copy.OK():				
						if u_copy.is_new(selected_unrolls):
							temp_name = 'unrolling_selected_' + str(counter)
							u_copy.set_name(temp_name)
							selected_unrolls[temp_name] = u_copy
							counter += 1
						else:
							temp_name = u_copy.find(selected_unrolls)

						#rate = self.util_rate(alg_case_dic, u_copy)
						#alg.set_rate(index, temp_name, rate)

		for alg in algs: 
			print( "\n -- evaluating alg: %s" % (alg.get_name()) )
			for index in range(alg.total_cases):
				alg_case_dic = alg.case_gen(index)
				for u in selected_unrolls:
					temp_name = selected_unrolls[u].get_name()
					rate = self.util_rate(alg_case_dic, selected_unrolls[u])
					alg.set_rate(index, temp_name, rate)

		print('\n -- number of selected unrolling is %d' % (len(selected_unrolls)))

		impconfigs = self.gen_imp_confs(selected_unrolls, filter_methode="covered", verbose=False)
		print('\n -- number of impconfig is %d' % (len(impconfigs)))
						
		set_elements = len(impconfigs)
		subsetsearch = SubSetSearch(subset_length, set_elements)
		print("\n Let's find the best %d-impconfig set" % (subset_length))

		for index in range(subsetsearch.get_total()):
			impconfigs_subset = subsetsearch.gen_config_subset(index, impconfigs)

			trate, tcase = 0, 0
			for alg in algs: 
				rate_temp = alg.evaluate(impconfigs_subset)
				case_temp = alg.get_total_cases()
				tcase += case_temp
				trate += rate_temp * case_temp
			average_rate = trate / tcase

			subsetsearch.set_util(index, average_rate)

			impconfigs_string = ''
			for i in impconfigs_subset:
				impconfigs_string += '_' + i.get_name()[8:] 
			
			if do_gen_hdl:
				dir_temp = '../experiments'
				os.system('mkdir -p ' + dir_temp)
				dir_temp += '/MLBlock_2Dflex_' + str(self.nmac) + '_' + str(subset_length) + 'configs'
				os.system('mkdir -p ' + dir_temp)
				dir_temp += '/index_' +  str(index) + '/'    
				os.system('mkdir -p ' + dir_temp)
				
				if MLblock_version == 'v1':
					version_extention = ''
				else:
					version_extention = '_' + MLblock_version
 
				gen_HDLs(dir_temp, 'MLBlock_2Dflex', 
						impconfigs_subset, self.nmac, 
						self.precisions["I"], self.I_D, 
						self.precisions["W"], self.W_D, 
						self.precisions["O"], self.RES_D, 
						self.SHIFTER_TYPE,
						version=MLblock_version,
						verbose=False)

				os.system('cp ../verilog/MLBlock_2Dflex' + version_extention+'.sv ' + dir_temp + 'MLBlock_2Dflex'+version_extention+'.sv')
				os.system('cp ../verilog/MAC_unit'+version_extention+'.sv ' + dir_temp + 'MAC_unit'+version_extention+'.sv')
				os.system('cp ../verilog/stream_mem.sv ' + dir_temp + 'stream_mem.sv')
				os.system('cp ../verilog/mult_flex.sv ' + dir_temp + 'mult_flex.sv')
				os.system('cp ../verilog/state_machine.sv ' + dir_temp + 'state_machine.sv')
				os.system('cp ../verilog/shifter.sv ' + dir_temp + 'shifter.sv')
				os.system('cp ../verilog/stream_flex'+version_extention+'.sv ' + dir_temp + 'stream_flex'+version_extention+'.sv')
				os.system('cp ../verilog/accumulator'+version_extention+'.sv ' + dir_temp + 'accumulator'+version_extention+'.sv')
				os.system('cp exp'+version_extention+'.tcl ' + dir_temp + 'exp.tcl')

		exps_addr = '../experiments' + '/MLBlock_2Dflex_' + str(self.nmac) + '_' + str(subset_length) + 'configs'

		if do_synthesis:	
			NUM_CORES = 25
			indexes = ''
			for i in range(subsetsearch.get_total()):
				indexes += str(i) + ' '
			os.system("parallel --bar --gnu -j%d --header : 'bash ./exp.sh %s %d {index} ' ::: index %s " % (NUM_CORES, exps_addr, period, indexes))

		for index in range(subsetsearch.get_total()):
			area, freq, power = get_asic_results(exps_addr + '/index_' +  str(index) + '/', period=period)
			subsetsearch.set_synthesis_results(index, area, freq, power)

		if verbose:
			for index in range(subsetsearch.get_size()):
				subsetsearch.print_results(index)
		
		best_subset_impconfigs, index_best = subsetsearch.best_impconfigs(objective=objective)
		os.system('mkdir -p ' + exps_addr)
		pickle.dump(subsetsearch, open(exps_addr + "/subsetsearch.pkl", "wb"))
		
		print("\n -- Best performance is using %s" % (str([bms.get_name() for bms in best_subset_impconfigs])))
		print('-- Its configurations are: \n')
		
		for impconfig in best_subset_impconfigs:
			impconfig.print()
		
		return best_subset_impconfigs 


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

	def util_rate(self, alg_p_dic, unroll):
		unroll_p_dic = unroll.gen_dic()

		# the effect of parameter count 
		alg_arr = dic2nparr(alg_p_dic, 0)
		unrolling_arr = dic2nparr(unroll_p_dic, 0)
		
		alg_mac = arr2prod(alg_arr)
		unrolling_mac = arr2prod(unrolling_arr)
		unrolling_iter = arr2prod(np.ceil(alg_arr / unrolling_arr))

		util = alg_mac / (unrolling_mac * unrolling_iter)
		#return util 

		# the effect of parameter stride
		alg_arr = dic2nparr(alg_p_dic, 1)
		unrolling_arr = dic2nparr(unroll_p_dic, 1)

		for i in range(len(alg_arr)):
			if (int(alg_arr[i] / unrolling_arr[i]) != (alg_arr[i] / unrolling_arr[i])):
				util *= 0
			else:
				util *= (unrolling_arr[i] / alg_arr[i])

		return util 

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
	
	def gen_imp_confs(self, unrollings, filter_methode="covered", verbose=True):
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

		if verbose:
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
