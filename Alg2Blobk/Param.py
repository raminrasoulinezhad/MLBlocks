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
