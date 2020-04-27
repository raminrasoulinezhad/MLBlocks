import numpy as np


def param_gen_const_product(size, const):
	results = np.array([])

	if size == 1:
		results = [const]
	else:
		for i in range(1, const+1):
			if (const % i) == 0:

				results_temp = param_gen_const_product(size-1, int(const / i))
				
				for j in results_temp:
					j_extend = np.append(j, i)

					if results.size == 0:
						results = np.expand_dims(j_extend, axis=0)
					else:
						j_extend = np.expand_dims(j_extend, axis=0)
						results = np.concatenate((results, j_extend), axis=0)

	return results


def param_gen_const_values(size, consts):
	results = np.array([])

	if size == 1:
		results = np.reshape(consts, (-1,1))
		
	else:
		results_temp = param_gen_const_values(size-1, consts)

		for j in results_temp:
			for i in range(len(consts)):
				j_extend = np.append(j, consts[i])

				if results.size == 0:
					results = np.expand_dims(j_extend, axis=0)
				else:
					j_extend = np.expand_dims(j_extend, axis=0)
					results = np.concatenate((results, j_extend), axis=0)

	return results

def param_gen_const_products(consts):
	consts_size = consts.size

	if consts_size == 1:

		results_temp = param_gen_const_product(2, consts[0])

		results_un = np.expand_dims(results_temp[:,0], axis=1)
		results_seq = np.expand_dims(results_temp[:,1], axis=1)
	else:
		results_un = np.array([])
		results_seq = np.array([])

		results_rec_un, results_rec_seq = param_gen_const_products(consts[1:])
		results_temp = param_gen_const_product(2, consts[0])
		results_temp_un = results_temp[:,0]
		results_temp_seq = results_temp[:,1]

		for i in results_rec_un:
			for j in results_temp_un:
				j_extend = np.append(j, i)

				if results_un.size == 0:
					results_un = np.expand_dims(j_extend, axis=0)
				else:
					j_extend = np.expand_dims(j_extend, axis=0)
					results_un = np.concatenate((results_un, j_extend), axis=0)

		for i in results_rec_seq:
			for j in results_temp_seq:
				j_extend = np.append(j, i)
				
				if results_seq.size == 0:
					results_seq = np.expand_dims(j_extend, axis=0)
				else:
					j_extend = np.expand_dims(j_extend, axis=0)
					results_seq = np.concatenate((results_seq, j_extend), axis=0)

	return results_un, results_seq


class Param:
	def __init__(self, comp_un, comp_seq, io_un, io_seq):
		self.comp_un = comp_un
		self.comp_seq = comp_seq
		self.io_un = io_un
		self.io_seq = io_seq


class Arch:
	def __init__(self, param_comp_un, param_comp_seq, param_io_un, param_io_seq):
		self.param_comp_un = param_comp_un
		self.param_comp_seq = param_comp_seq
		self.param_io_un = param_io_un
		self.param_io_seq = param_io_seq


class Index:
	def __init__(self, name):
		self.name = name
		self.input_a = None
		self.input_b = None
		self.output_c = None

class Algorithm:

	def __init__(self, string):
		self.string = string
		self.output_inds = ["b", "k", "x", "y"]

		self.input_a_inds = ["b", "c", "x+fx", "y+fy"]
		self.input_a_inds_exp = ["b", "c", "x", "fx", "y", "fy"]

		self.input_b_inds = ["k", "c", "fx", "fy"]
		self.input_b_inds_exp = ["k", "c", "fx", "fy"]

		self.window_potentials = ["x", "fx", "y", "fy"]

		self.inputs_inds_exp = np.unique(np.append(self.input_a_inds_exp, self.input_b_inds_exp))
		self.inputs_inds_exp_num = len(self.inputs_inds_exp)

		self.indexes = create_indexes(self.inputs_inds_exp)

	def create_indexes(index_strings)
		indexes = []
		for i in index_strings:
			index = Index(i)
			indexes.append(index)
		return indexes

	def set_effects_on_io (indexes, input_a_inds, input_b_inds, output_c_inds)





#########################################################################################	
'''
"O[b][k][x][y] += I[b][c][x+fx][y+fy] * W[k][c][fx][fy]"	# Standard Conv
"O[b][x][y] += I[b][x][k] * W[k][y]"						# Batch Matrix-Matrix Multiply
"O[x] += I[x][k] * W[k]"									# Matrix-Vector Multiply
'''
algorithm = Algorithm("O[b][k][x][y] += I[b][c][x+fx][y+fy] * W[k][c][fx][fy]")
print(algorithm.inputs_inds_exp)
print(algorithm.inputs_inds_exp_num)

# defines
a_w = 8
b_w = 8
c_w = 16
acc_w = 20

# limitations 
limit_mac = 54
limit_mac_seq = [1,2,3,4,6,8,9]
limit_mac_seq = [1,2,3]


param_comp_un  = param_gen_const_product(algorithm.inputs_inds_exp_num, limit_mac)
param_comp_seq = param_gen_const_values(algorithm.inputs_inds_exp_num, limit_mac_seq)

print("potential comp unrol cases:\t%s" % (str(param_comp_un.shape)))
print("potential comp seq cases:\t%s" % (str(param_comp_seq.shape)))


cases = []
for p_comp_un in param_comp_un:
	for p_comp_seq in param_comp_seq:
		
		p_io_total = p_comp_un * p_comp_seq

		param_io_un, param_io_seq= param_gen_const_products(p_io_total)

		exit()
		
		#print(param_io_un.shape)
		#print(param_io_seq.shape)
		#exit()

		#if results.size == 0:
		#	results = np.expand_dims(j_extend, axis=0)
		#else:
		#	j_extend = np.expand_dims(j_extend, axis=0)
		#	results = np.concatenate((results, j_extend), axis=0)

		#print(p_comp_un)
		#print(p_comp_seq)
		#print(p_io_total)
	#exit()



#




def compression_rate():
	return 

def quality_check():
	return 

def feasibility_check():
	return 


#from mip import Model, xsum, BINARY, INTEGER, maximize
#model = Model('PEDesignSpaceSeach')
##x = [model.add_var(var_type=INTEGER) for i in I]
##x = [model.add_var(name="{}_{})".format(name, part), var_type=INTEGER) for name in inputs_inds_exp for part in ["_un", "_seq"]]
#x = [model.add_var(name="{})".format(name), var_type=INTEGER) for name in inputs_inds_exp]
#model += xsum(w[i] * x[i] for i in range(len(inputs_inds_exp))) == c
#model.objective = maximize(xsum(x[i] for i in range(len(inputs_inds_exp))))
