// parameters 
parameter MAC_UNITS = 20; 

parameter N_OF_COFIGS = 3; 
localparam N_OF_COFIGS_LOG2 = $clog2(N_OF_COFIGS); 

parameter PORT_I_SIZE = 20; 
parameter PORT_W_SIZE = 1;		// Other values are not supported 
parameter PORT_RES_SIZE = 2; 

parameter I_W = 8; 
parameter I_D = 2; 
localparam I_D_LOG2 = $clog2(I_D);
parameter I_S = 2; 
localparam I_S_LOG2 = (I_S == 1)? 1 : $clog2(I_S);

parameter W_W = 8; 
parameter W_D = 1; 

parameter RES_W = 32; 
parameter RES_D = 1; 
localparam RES_D_LOG2 = (RES_D == 1)? 1 : $clog2(RES_D);

parameter SHIFTER_TYPE = "BYPASS";		// "BYPASS", "2Wx2V_by_WxV", "2Wx2V_by_WxV_apx", "2Wx2V_by_WxV_apx_adv"
