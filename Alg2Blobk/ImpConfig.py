class ImpConfig():
	def __init__(self, name="", U_IW_W=1, U_IW_NW=1, U_WO=1, U_IO=1, U_IWO=1):
		self.name = name

		self.U_IW_W	 = U_IW_W
		self.U_IW_NW = U_IW_NW
		self.U_WO 	 = U_WO
		self.U_IO 	 = U_IO
		self.U_IWO 	 = U_IWO

		self.unrollings = []

	def print(self):
		print ("%s:  U_IW_W: %3d, U_IW_NW: %3d, U_WO: %3d,  U_IO: %3d,  U_IWO: %3d" % (self.name, self.U_IW_W, self.U_IW_NW, self.U_WO, self.U_IO, self.U_IWO))

	def conf_to_impconf(self, unrolling):
		for p in unrolling.param_dic:
			if unrolling.param_dic[p].type == "IW":
				if unrolling.param_dic[p].window_en != True:
					self.U_IW_NW *=  unrolling.param_dic[p].vals
				else:
					self.U_IW_W *=  unrolling.param_dic[p].vals
			elif unrolling.param_dic[p].type == "WO":
				self.U_WO *=  unrolling.param_dic[p].vals
			elif unrolling.param_dic[p].type == "IO":
				self.U_IO *=  unrolling.param_dic[p].vals
			elif unrolling.param_dic[p].type == "IWO":
				self.U_IWO *=  unrolling.param_dic[p].vals
			else:
				raise Exception ("conf_to_impconf: unrolling.param_dic[p].type is not supported !!!")

	def set_name(self, name):
		self.name = name

	def iscovered(self, impconfigs):
		for impconfig in impconfigs:
			if (impconfig.U_IW_W == self.U_IW_W):
				if (impconfig.U_IW_NW == self.U_IW_NW):
					if (impconfig.U_WO == self.U_WO):
						if (impconfig.U_IO * impconfig.U_IWO == self.U_IO * self.U_IWO):
							return True
		return False

	def isunique(self, impconfigs):
		for impconfig in impconfigs:
			if (impconfig.U_IW_W == self.U_IW_W):
				if (impconfig.U_IW_NW == self.U_IW_NW):
					if (impconfig.U_WO == self.U_WO):
						if (impconfig.U_IO == self.U_IO):
							if (impconfig.U_IWO == self.U_IWO):
								return True
		return False
