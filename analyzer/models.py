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

