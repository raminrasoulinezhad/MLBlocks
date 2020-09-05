//////////////
//impconf_0

assign I_configs[0][0] = I_in_temp[0];
assign I_configs[1][0] = I_in_temp[1];
assign I_configs[2][0] = I_in_temp[2];
assign I_configs[3][0] = I_in_temp[0];
assign I_configs[4][0] = I_in_temp[1];
assign I_configs[5][0] = I_in_temp[2];
assign I_configs[6][0] = I_in_temp[0];
assign I_configs[7][0] = I_in_temp[1];
assign I_configs[8][0] = I_in_temp[2];
assign I_configs[9][0] = I_in_temp[0];
assign I_configs[10][0] = I_in_temp[1];
assign I_configs[11][0] = I_in_temp[2];

assign Res_configs[0][0] = Res_cas_in_temp[0];
assign Res_configs[1][0] = Res_cascade[0];
assign Res_configs[2][0] = Res_cascade[1];
assign Res_configs[3][0] = Res_cas_in_temp[1];
assign Res_configs[4][0] = Res_cascade[3];
assign Res_configs[5][0] = Res_cascade[4];
assign Res_configs[6][0] = Res_cas_in_temp[2];
assign Res_configs[7][0] = Res_cascade[6];
assign Res_configs[8][0] = Res_cascade[7];
assign Res_configs[9][0] = Res_cas_in_temp[3];
assign Res_configs[10][0] = Res_cascade[9];
assign Res_configs[11][0] = Res_cascade[10];

assign Res_out_temp[0][0] = Res_cascade[2];
assign Res_out_temp[1][0] = Res_cascade[5];
assign Res_out_temp[2][0] = Res_cascade[8];
assign Res_out_temp[3][0] = Res_cascade[11];
//////////////
//impconf_1

assign I_configs[0][1] = I_in_temp[0];
assign I_configs[1][1] = I_in_temp[1];
assign I_configs[2][1] = I_in_temp[2];
assign I_configs[3][1] = I_in_temp[3];
assign I_configs[4][1] = I_in_temp[0];
assign I_configs[5][1] = I_in_temp[1];
assign I_configs[6][1] = I_in_temp[2];
assign I_configs[7][1] = I_in_temp[3];
assign I_configs[8][1] = I_in_temp[0];
assign I_configs[9][1] = I_in_temp[1];
assign I_configs[10][1] = I_in_temp[2];
assign I_configs[11][1] = I_in_temp[3];

assign Res_configs[0][1] = Res_cas_in_temp[0];
assign Res_configs[1][1] = Res_cascade[0];
assign Res_configs[2][1] = Res_cascade[1];
assign Res_configs[3][1] = Res_cascade[2];
assign Res_configs[4][1] = Res_cas_in_temp[1];
assign Res_configs[5][1] = Res_cascade[4];
assign Res_configs[6][1] = Res_cascade[5];
assign Res_configs[7][1] = Res_cascade[6];
assign Res_configs[8][1] = Res_cas_in_temp[2];
assign Res_configs[9][1] = Res_cascade[8];
assign Res_configs[10][1] = Res_cascade[9];
assign Res_configs[11][1] = Res_cascade[10];

assign Res_out_temp[0][1] = Res_cascade[3];
assign Res_out_temp[1][1] = Res_cascade[7];
assign Res_out_temp[2][1] = Res_cascade[11];
assign Res_out_temp[3][1] = {RES_W{1'bx}};
//////////////
//impconf_2

assign I_configs[0][2] = I_in_temp[0];
assign I_configs[1][2] = I_in_temp[1];
assign I_configs[2][2] = I_in_temp[2];
assign I_configs[3][2] = I_in_temp[3];
assign I_configs[4][2] = I_in_temp[0];
assign I_configs[5][2] = I_in_temp[1];
assign I_configs[6][2] = I_in_temp[2];
assign I_configs[7][2] = I_in_temp[3];
assign I_configs[8][2] = I_in_temp[0];
assign I_configs[9][2] = I_in_temp[1];
assign I_configs[10][2] = I_in_temp[2];
assign I_configs[11][2] = I_in_temp[3];

assign Res_configs[0][2] = Res_cas_in_temp[0];
assign Res_configs[1][2] = Res_cascade[0];
assign Res_configs[2][2] = Res_cascade[1];
assign Res_configs[3][2] = Res_cascade[2];
assign Res_configs[4][2] = Res_cas_in_temp[1];
assign Res_configs[5][2] = Res_cascade[4];
assign Res_configs[6][2] = Res_cascade[5];
assign Res_configs[7][2] = Res_cascade[6];
assign Res_configs[8][2] = Res_cas_in_temp[2];
assign Res_configs[9][2] = Res_cascade[8];
assign Res_configs[10][2] = Res_cascade[9];
assign Res_configs[11][2] = Res_cascade[10];

assign Res_out_temp[0][2] = Res_cascade[3];
assign Res_out_temp[1][2] = Res_cascade[7];
assign Res_out_temp[2][2] = Res_cascade[11];
assign Res_out_temp[3][2] = {RES_W{1'bx}};
//////////////
//impconf_3

assign I_configs[0][3] = I_in_temp[0];
assign I_configs[1][3] = I_in_temp[1];
assign I_configs[2][3] = I_in_temp[2];
assign I_configs[3][3] = I_in_temp[0];
assign I_configs[4][3] = I_in_temp[1];
assign I_configs[5][3] = I_in_temp[2];
assign I_configs[6][3] = I_in_temp[0];
assign I_configs[7][3] = I_in_temp[1];
assign I_configs[8][3] = I_in_temp[2];
assign I_configs[9][3] = I_in_temp[0];
assign I_configs[10][3] = I_in_temp[1];
assign I_configs[11][3] = I_in_temp[2];

assign Res_configs[0][3] = Res_cas_in_temp[0];
assign Res_configs[1][3] = Res_cascade[0];
assign Res_configs[2][3] = Res_cascade[1];
assign Res_configs[3][3] = Res_cas_in_temp[1];
assign Res_configs[4][3] = Res_cascade[3];
assign Res_configs[5][3] = Res_cascade[4];
assign Res_configs[6][3] = Res_cas_in_temp[2];
assign Res_configs[7][3] = Res_cascade[6];
assign Res_configs[8][3] = Res_cascade[7];
assign Res_configs[9][3] = Res_cas_in_temp[3];
assign Res_configs[10][3] = Res_cascade[9];
assign Res_configs[11][3] = Res_cascade[10];

assign Res_out_temp[0][3] = Res_cascade[2];
assign Res_out_temp[1][3] = Res_cascade[5];
assign Res_out_temp[2][3] = Res_cascade[8];
assign Res_out_temp[3][3] = Res_cascade[11];
