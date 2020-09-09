from Arch import Arch
from benchmark_space import *

arch_12 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=12,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)

arch_9 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=9,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)
arch_8 = Arch("all",
                        None,
                        my_space,
                        stationary="W",
                        precisions={
                                                        "I" : 8,
                                                        "W" : 8,
                                                        "O" : 32,
                                                },
                        nmac=8,
                        limits= {
                                                "IO_I" : 36,
                                                "IO_W" : None,
                                                "IO_O" : 32*4,
                                                "IO" : None,
                                        }
                        )

arch_6 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			nmac=6,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)


arch_12_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "2Wx2V_by_WxV",	
					},
			nmac=12,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)

arch_9_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "2Wx2V_by_WxV",	
					},
			nmac=9,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)

arch_8_16x16 = Arch("all",
                        None,
                        my_space,
                        stationary="W",
                        precisions={
                                                        "I" : 8,
                                                        "W" : 8,
                                                        "O" : 32,
                                                },
                        subprecisions=  {
                                                "I_D" : 4,
                                                "W_D" : 2,
                                                "RES_D" : 1,
                                                "SHIFTER_TYPE" : "2Wx2V_by_WxV",
                                        },
                        nmac=8,
                        limits= {
                                                "IO_I" : 36,
                                                "IO_W" : None,
                                                "IO_O" : 32*4,
                                                "IO" : None,
                                        }
                        )

arch_6_16x16 = Arch("all", 
			None, 
			my_space,
			stationary="W",
			precisions={	
							"I" : 8,
							"W" : 8,
							"O" : 32,
						},
			subprecisions=	{	
						"I_D" : 4,
						"W_D" : 2,
						"RES_D" : 1,
						"SHIFTER_TYPE" : "2Wx2V_by_WxV",	
					},
			nmac=6,
			limits= {	
						"IO_I" : 36,
						"IO_W" : None,
						"IO_O" : 32*4,
						"IO" : None, 	
					}
			)

print ("\n-- Arch. descriptions are loaded\n")

if __name__ == "__main__":
	arch_12.print_confs()	 
	print (arch_12.rate_arch(algs))
