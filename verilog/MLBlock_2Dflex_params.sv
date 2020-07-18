// parameters 
parameter MAC_UNITS = 12; 

parameter N_OF_COFIGS = 3; 
localparam N_OF_COFIGS_LOG2 = $clog2(N_OF_COFIGS); 

parameter PORT_A_SIZE = 4; 
parameter PORT_B_SIZE = 1;		// Other values are not supported 
parameter PORT_RES_SIZE = 4; 

parameter I_W = 8; 
parameter I_D = 4; 
localparam I_D_HALF = I_D / 2;

parameter W_W = 8; 
parameter W_D = 4; 

parameter RES_W = 32; 
parameter RES_D = 1; 
localparam RES_D_CNTL = (RES_D > 1)? (RES_D-1): 1;

parameter SHIFTER_TYPE = "2Wx2V_by_WxV";		// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"

