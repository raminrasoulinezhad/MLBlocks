import re

def get_config_index(config_name):
	m = re.match(r"impconf\_(?P<index>\d+)", config_name)
	if m:
		return int(m.groups("index")[0])
	else:
		raise Exception("Configuration names are wrong")

def index_mapper_opt(index, step):
	return (index * step) + step - 1 

def get_base_array (config):
	return [config.U_IW_W, config.U_IW_NW, config.U_IO, config.U_WO, config.U_IWO]

def get_base_mask_I():
	return [0, 1, 1, 0, 1]

def get_base_mask_Res():
	return [0, 0, 1, 1, 1]

def index_to_basedindex (index, base):
	result = []
	for i in range(len(base)):
		val = index % base[i]
		result.append(val)
		index = (index - val) / base[i]
	return result

def gen_IO_index (basedindex, config_base, mask):
	I_index = 0
	w = 1
	for i in range(len(config_base)):
		if mask[i]:
			I_index += w * basedindex[i]
			w *= config_base[i]
	return I_index

def get_IO_index(mac_index, config_base, step, mode="I"):
	mac_basedindex = index_to_basedindex (mac_index, config_base)
	if mode == "I":
		I_index = gen_IO_index (mac_basedindex, config_base, get_base_mask_I())
		I_index_mapped = index_mapper_opt(I_index, step)
		return I_index_mapped
	elif mode == "Res":
		Res_index = gen_IO_index (mac_basedindex, config_base, get_base_mask_Res())
		Res_index_mapped = index_mapper_opt(Res_index, step)
		return Res_index_mapped
	else:
		raise Exception("get_IO_index does not support mode = %s" % (mode))

def gen_interconnections(file_name, configs, PORT_I_SIZE, PORT_W_SIZE, PORT_RES_SIZE, MAC_UNITS, version='v2', verbose=True):

	file = open(file_name, "w")

	S_max = 0
	for config in configs:
		if config.U_IW_W_S > S_max:
			S_max = config.U_IW_W_S

	conf_index = -1
	for config in configs:

		if verbose:
			config.print()
		#conf_index = get_config_index(config.name)
		conf_index += 1

		file.write("//////////////\n//%s\n" % config.name)

		step_I  = PORT_I_SIZE   // (config.U_IW_NW * config.U_IO * config.U_IWO)
		step_Res = PORT_RES_SIZE // (config.U_IO * config.U_WO * config.U_IWO)
		if verbose:
			print ("I step: %d\t Res step: %d" % (step_I, step_Res))
		
		config_base = get_base_array(config)

		file.write("\n")
		for mac_index in range(MAC_UNITS):
			# assign I_configs[MAC_UNITS][N_OF_COFIGS] = I_in_temp[PORT_I_SIZE] or  I_cascade[MAC_UNITS]
			if (mac_index % config.U_IW_W == 0):
				I_index_mapped = get_IO_index(mac_index, config_base, step_I, mode="I")
				if version == 'v1':
					file.write("assign I_configs[%d][%d] = I_in_temp[%d];\n" % (mac_index, conf_index, I_index_mapped))
				elif version == 'v2':
					#file.write("assign I_configs[%d][%d] = 0;\n" % (mac_index, conf_index))
					for s in range(S_max):
						if s < min(config.U_IW_W_S, config.U_IW_W):
							file.write("assign I_configs[%d][%d][%d] = I_in_temp[%d];\n" % (mac_index, conf_index, s, I_index_mapped-s))
						else:
							file.write("assign I_configs[%d][%d][%d] = 0;\n" % (mac_index, conf_index, s))
			else:
				file.write("assign I_configs[%d][%d] = I_cascade[%d];\n" % (mac_index, conf_index, mac_index-1) )

		file.write("\n")
		for mac_index in range(MAC_UNITS):		
			# assign Res_configs[MAC_UNITS][N_OF_COFIGS] = Res_cas_in_temp[PORT_RES_SIZE] or Res_cascade[MAC_UNITS] 
			if (mac_index % (config.U_IW_W * config.U_IW_NW) == 0):
				Res_index_mapped = get_IO_index(mac_index, config_base, step_Res, mode="Res")
				file.write("assign Res_configs[%d][%d] = Res_cas_in_temp[%d];\n" % (mac_index, conf_index, Res_index_mapped) )
			else:
				file.write("assign Res_configs[%d][%d] = Res_cascade[%d];\n" % (mac_index, conf_index, mac_index-1) )

		file.write("\n")
		for out_index in range(PORT_RES_SIZE):
			# assign Res_out_temp[PORT_RES_SIZE][N_OF_COFIGS-1:0] = Res_cascade[MAC_UNITS]
			if (((out_index + 1) % step_Res) == 0):
				Res_cascade_index = ((out_index+1)/step_Res) * config.U_IW_W * config.U_IW_NW - 1
				if Res_cascade_index < MAC_UNITS:
					file.write("assign Res_out_temp[%d][%d] = Res_cascade[%d];\n" % ( out_index, conf_index, Res_cascade_index) )
				else:
					file.write("assign Res_out_temp[%d][%d] = {RES_W{1\'bx}};\n" % ( out_index, conf_index) )
			else:
				file.write("assign Res_out_temp[%d][%d] = {RES_W{1\'bx}};\n" %  ( out_index, conf_index) )

	file.close()

def gen_params(file_name, MAC_UNITS, N_OF_COFIGS, PORT_I_SIZE, PORT_W_SIZE, PORT_RES_SIZE, I_W, I_D, I_S, W_W, W_D, RES_W, RES_D, SHIFTER_TYPE, version='v2'):

	file = open(file_name, "w")
	
	file.write("// parameters \n")
	file.write("parameter MAC_UNITS = %d; \n" % (MAC_UNITS))
	file.write("\n")
	file.write("parameter N_OF_COFIGS = %d; \n" % (N_OF_COFIGS))
	file.write("localparam N_OF_COFIGS_LOG2 = $clog2(N_OF_COFIGS); \n")
	file.write("\n")
	file.write("parameter PORT_I_SIZE = %d; \n" % (PORT_I_SIZE))
	file.write("parameter PORT_W_SIZE = %d;\t\t// Other values are not supported \n" % (PORT_W_SIZE))
	file.write("parameter PORT_RES_SIZE = %d; \n" % (PORT_RES_SIZE))
	file.write("\n")
	file.write("parameter I_W = %d; \n" % (I_W))
	file.write("parameter I_D = %d; \n" % (I_D))
	if (version == 'v1'):
		file.write("localparam I_D_HALF = I_D / 2;\n")
	elif (version == 'v2'):
		file.write("localparam I_D_LOG2 = $clog2(I_D);\n")
		file.write("parameter I_S = %d; \n" % (I_S))
		file.write("localparam I_S_LOG2 = (I_S == 1)? 1 : $clog2(I_S);\n")

	file.write("\n")
	file.write("parameter W_W = %d; \n" % (W_W))
	file.write("parameter W_D = %d; \n" % (W_D))
	file.write("\n")
	file.write("parameter RES_W = %d; \n" % (RES_W))
	file.write("parameter RES_D = %d; \n" % (RES_D))
	
	if (version == 'v1'):
		file.write("localparam RES_D_CNTL = (RES_D > 1)? (RES_D-1): 1;\n")
	elif (version == 'v2'):
		file.write("localparam RES_D_LOG2 = (RES_D == 1)? 1 : $clog2(RES_D);\n")

	file.write("\n")
	file.write("parameter SHIFTER_TYPE = \"%s\";\t\t// \"BYPASS\", \"2Wx2V_by_WxV\", \"2Wx2V_by_WxV_apx\", \"2Wx2V_by_WxV_apx_adv\"\n" % (SHIFTER_TYPE))
	file.write("\n")

	file.close()

def gen_HDLs(dir, model_name, configs, MAC_UNITS, I_W, I_D, W_W, W_D, RES_W, RES_D, SHIFTER_TYPE, version='v2', verbose=True):

	if not version in ['v1', 'v2']:
		raise Exception ('MLBlock has two versions (v1 and v2). However, the input version is wrong')

	if version != 'v1':
		model_name += '_' + version

	N_OF_COFIGS = len(configs)
	
	PORT_I_SIZE = 1 
	PORT_W_SIZE = 1
	PORT_RES_SIZE = 1 
	
	S_greatest = 1
	G_greatest = 1

	for conf in configs:
		
		if version == 'v1':
			PORT_I_SIZE_temp = conf.U_IW_NW * conf.U_IO * conf.U_IWO 
		else:
			PORT_I_SIZE_temp = conf.U_IW_NW * conf.U_IO * conf.U_IWO * conf.U_IW_W_S	
		PORT_RES_SIZE_temp = conf.U_WO * conf.U_IO * conf.U_IWO

		if (PORT_I_SIZE_temp > PORT_I_SIZE):
			PORT_I_SIZE = PORT_I_SIZE_temp
		if (PORT_RES_SIZE_temp > PORT_RES_SIZE):
			PORT_RES_SIZE = PORT_RES_SIZE_temp

		if version == 'v2':
			if conf.U_IW_W_S > S_greatest:
				S_greatest = conf.U_IW_W_S
			if conf.U_IW_W_G > G_greatest:
				G_greatest = conf.U_IW_W_G

	gen_interconnections(	dir + model_name + "_interconnects.sv", 
							configs, 
							PORT_I_SIZE, 
							PORT_W_SIZE, 
							PORT_RES_SIZE, 
							MAC_UNITS,
							version=version,
							verbose=verbose)

	gen_params( dir + model_name + "_params.sv", 
				MAC_UNITS, 
				N_OF_COFIGS, 
				PORT_I_SIZE, 
				PORT_W_SIZE, 
				PORT_RES_SIZE, 
				I_W, 
				I_D * G_greatest,
				S_greatest, 
				W_W, 
				W_D, 
				RES_W, 
				RES_D, 
				SHIFTER_TYPE,
				version=version)





######################################################################################################
if __name__ == "__main__":
	
	configs = {	"impconf_0":{
							"U_IW_W": 	3,
							"U_IW_NW": 	1,
							"U_WO": 	1,
							"U_IO": 	1,
							"U_IWO": 	4,
						},
				"impconf_1":{
							"U_IW_W": 	1,
							"U_IW_NW": 	3,
							"U_WO": 	4,
							"U_IO": 	1,
							"U_IWO": 	1,
						},
				"impconf_2":{
							"U_IW_W": 	4,
							"U_IW_NW": 	1,
							"U_WO": 	1,
							"U_IO": 	1,
							"U_IWO": 	3,
						},
			}

	MAC_UNITS = 12

	N_OF_COFIGS = len(configs)

	PORT_I_SIZE   = 4
	PORT_W_SIZE   = 1		# Other values are not supported
	PORT_RES_SIZE = 4

	I_W = 8
	I_D = 4
	W_W = 8
	W_D = 4
	RES_W = 32
	RES_D = 1
	SHIFTER_TYPE = "2Wx2V_by_WxV"	# "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"

	'''
	# test 
	PORT_I_SIZE   = 16
	PORT_W_SIZE   = 1			# Other values are not supported
	PORT_RES_SIZE = 16

	MAC_UNITS = 32
	configs = {	"impconf_0":{
							"U_IW_W": 	2,
							"U_IW_NW": 	2,
							"U_WO": 	2,
							"U_IO": 	2,
							"U_IWO": 	2,
						},
				"impconf_1":{
							"U_IW_W": 	1,
							"U_IW_NW": 	4,
							"U_WO": 	2,
							"U_IO": 	2,
							"U_IWO": 	2,
						},
				"impconf_2":{
							"U_IW_W": 	1,
							"U_IW_NW": 	2,
							"U_WO": 	4,
							"U_IO": 	2,
							"U_IWO": 	2,
						},
				"impconf_3":{
							"U_IW_W": 	1,
							"U_IW_NW": 	2,
							"U_WO": 	2,
							"U_IO": 	4,
							"U_IWO": 	2,
						},
				"impconf_4":{
							"U_IW_W": 	4,
							"U_IW_NW": 	4,
							"U_WO": 	2,
							"U_IO": 	1,
							"U_IWO": 	1,
						},
			}
	'''


	file_name_interconnects = "../verilog/MLBlock_2Dflex_interconnects.sv"
	file_name_params = "../verilog/MLBlock_2Dflex_params.sv"

	gen_interconnections(file_name_interconnects, configs, PORT_I_SIZE, PORT_W_SIZE, PORT_RES_SIZE, MAC_UNITS)
	gen_params(file_name_params, MAC_UNITS, N_OF_COFIGS, PORT_I_SIZE, PORT_W_SIZE, PORT_RES_SIZE, I_W, I_D, W_W, W_D, RES_W, RES_D, SHIFTER_TYPE)
