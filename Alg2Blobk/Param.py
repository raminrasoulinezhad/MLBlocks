class Param():
	def __init__(self, type="IW", window_en=False, vals=None, strides=None):
		self.type = type 
		self.set_window_en(window_en)
		self.set_vals(vals)
		self.set_strides(strides)


	def set_window_en(self, window_en):
		self.window_en = False if (window_en == None) else window_en
		
	def set_vals(self, vals):
		self.vals = [1] if (vals == None) else vals
		
		if isinstance(self.vals, list):
			self.vals_size = len(self.vals)
		else:
			self.vals_size = None

	def set_strides(self, strides):
		self.strides = [1] if (strides == None) else strides
		self.strides_size = len(self.strides)


	def get_type(self):
		return self.type

	def get_vals(self):
		return self.vals

	def get_vals_size(self):
		return self.vals_size 

	def get_strides(self):
		return self.strides
