class Param():
	def __init__(self, p_type, windowed=False, window_accompany=False):
		# inputs:
		# 	p_type: "IW", "IO", "WO", "IWO"
		# 	windowed: "True", "False" 

		self.set_type(p_type)
		self.set_as_windowed(windowed)
		self.set_as_window_accompany(window_accompany)

		self.set_vals(None)
		self.set_vals_size(None)
		self.set_val(None)

	def set_type(self, p_type):
		if not p_type in ["IW", "IO", "WO", "IWO"]:
			raise Exception ('Param type is wrone. It is set %s which is not in the [IW, IO, WO, IWO]' % (str(p_type)))
		self.p_type = p_type 

	def get_type(self):
		return self.p_type


	def set_as_windowed(self, windowed):
		self.windowed = False if (windowed == None) else windowed

	def is_windowed(self):
		return self.windowed
		

	def set_as_window_accompany(self, window_accompany):
		self.window_accompany = False if (window_accompany == None) else window_accompany

	def is_window_accompany(self):
		return self.window_accompany

		
	def set_vals(self, vals):
		vals = [(1,1)] if (vals == None) else vals
		if not isinstance(vals, list):
			raise Exception ('The input of the set_vals should be a list or None')
		
		self.vals_ = []		
		for val in vals:
			if isinstance(val, tuple):
				self.vals_.append(val)
			else:
				self.vals_.append((val,1))

		self.set_vals_size(len(self.vals_))

	def set_val(self, val):
		self.val_ = (1,1) if (val == None) else val
		if not isinstance(val, tuple):
			self.val_ = (self.val_,1)


	def get_vals(self):
		return self.vals_

	def get_val(self, mode='all'):
		if not mode in ['all', 'unroll', 'stride']:
			raise Exception ('get_val accepts mode in [] where \'%s\' is requested' % (mode))
		
		if mode == 'all':
			return self.val_
		elif mode == 'unroll':
			return self.val_[0]
		else:
			return self.val_[1]


	def get_vals_size(self):
		return self.vals_size 

	def set_vals_size(self, vals_size):
		self.vals_size = vals_size
