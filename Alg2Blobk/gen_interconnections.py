import re


file = open("../verilog/MLBlock_2Dflex_interconnects.sv", "w")

PORT_A_SIZE   = 4
PORT_B_SIZE   = 1	
PORT_RES_SIZE = 16

#N_OF_COFIGS = 4
MAC_UNITS = 32
configs = {	"conf_0":{
						"U_IW_W": 	2,
						"U_IW_NW": 	2,
						"U_WO": 	2,
						"U_IO": 	2,
						"U_IWO": 	2,
					},
			"conf_1":{
						"U_IW_W": 	1,
						"U_IW_NW": 	4,
						"U_WO": 	2,
						"U_IO": 	2,
						"U_IWO": 	2,
					},
			"conf_2":{
						"U_IW_W": 	1,
						"U_IW_NW": 	2,
						"U_WO": 	4,
						"U_IO": 	2,
						"U_IWO": 	2,
					},
			"conf_3":{
						"U_IW_W": 	1,
						"U_IW_NW": 	2,
						"U_WO": 	2,
						"U_IO": 	4,
						"U_IWO": 	2,
					},
		}

for config_name in configs:

	file.write("//////////////\n")
	file.write("//%s\n" % config_name)

	m = re.match(r"conf\_(?P<conf_index>\d+)", config_name)
	if m:
		conf_index = int(m.groups("conf_index")[0])
	else:
		raise Exception("Configuration names are wrong")

	config = configs[config_name]
	print (config)


	for mac_index in range(MAC_UNITS):
		# assign I_configs[MAC_UNITS][N_OF_COFIGS] = I_in_temp[PORT_A_SIZE] or  I_cascade[MAC_UNITS]
		if (mac_index % config["U_IW_W"] == 0):
			file.write("assign I_configs[%d][%d] = I_in_temp[%d];\n" % (mac_index, conf_index, ((mac_index%(config["U_IW_W"]*config["U_IW_NW"]*config["U_IO"]))/config["U_IW_W"])) )
		else:
			file.write("assign I_configs[%d][%d] = I_cascade[%d];\n" % (mac_index, conf_index, mac_index-1) )
	
	for mac_index in range(MAC_UNITS):		
		# assign Res_configs[MAC_UNITS][N_OF_COFIGS] = Res_cas_in_temp[PORT_RES_SIZE] or Res_cascade[MAC_UNITS] 
		if (mac_index % (config["U_IW_W"]*config["U_IW_NW"]) == 0):
			file.write("assign Res_configs[%d][%d] = Res_cas_in_temp[%d];\n" % (mac_index, conf_index, (mac_index/(config["U_IW_W"]*config["U_IW_NW"]))) )
		else:
			file.write("assign Res_configs[%d][%d] = Res_cascade[%d];\n" % (mac_index, conf_index, mac_index-1) )

	for out_index in range(PORT_RES_SIZE):
		# assign Res_out_temp[PORT_RES_SIZE][N_OF_COFIGS-1:0] = Res_cascade[MAC_UNITS]
		step = PORT_RES_SIZE // (config["U_IO"]*config["U_WO"]*config["U_IWO"])
		if (((out_index + 1) % step) == 0):
			file.write("assign Res_out_temp[%d][%d] = Res_cascade[%d];\n" % ( out_index, conf_index, ((out_index+1)/step)*config["U_IW_W"]*config["U_IW_NW"]) )
		else:
			file.write("assign Res_out_temp[%d][%d] = {RES_W{1\'bx}};\n" %  ( out_index, conf_index) )

file.close()
