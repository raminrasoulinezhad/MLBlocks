//////////////
//impconf_0

assign I_configs[0][0][0] = I_in_temp[1];
assign I_configs[0][0][1] = 0;
assign I_configs[1][0][0] = I_in_temp[3];
assign I_configs[1][0][1] = 0;
assign I_configs[2][0][0] = I_in_temp[5];
assign I_configs[2][0][1] = 0;
assign I_configs[3][0][0] = I_in_temp[7];
assign I_configs[3][0][1] = 0;
assign I_configs[4][0][0] = I_in_temp[9];
assign I_configs[4][0][1] = 0;
assign I_configs[5][0][0] = I_in_temp[11];
assign I_configs[5][0][1] = 0;
assign I_configs[6][0][0] = I_in_temp[13];
assign I_configs[6][0][1] = 0;
assign I_configs[7][0][0] = I_in_temp[15];
assign I_configs[7][0][1] = 0;
assign I_configs[8][0][0] = I_in_temp[17];
assign I_configs[8][0][1] = 0;
assign I_configs[9][0][0] = I_in_temp[19];
assign I_configs[9][0][1] = 0;
assign I_configs[10][0][0] = I_in_temp[1];
assign I_configs[10][0][1] = 0;
assign I_configs[11][0][0] = I_in_temp[3];
assign I_configs[11][0][1] = 0;
assign I_configs[12][0][0] = I_in_temp[5];
assign I_configs[12][0][1] = 0;
assign I_configs[13][0][0] = I_in_temp[7];
assign I_configs[13][0][1] = 0;
assign I_configs[14][0][0] = I_in_temp[9];
assign I_configs[14][0][1] = 0;
assign I_configs[15][0][0] = I_in_temp[11];
assign I_configs[15][0][1] = 0;
assign I_configs[16][0][0] = I_in_temp[13];
assign I_configs[16][0][1] = 0;
assign I_configs[17][0][0] = I_in_temp[15];
assign I_configs[17][0][1] = 0;
assign I_configs[18][0][0] = I_in_temp[17];
assign I_configs[18][0][1] = 0;
assign I_configs[19][0][0] = I_in_temp[19];
assign I_configs[19][0][1] = 0;

assign Res_configs[0][0] = Res_cas_in_temp[0];
assign Res_configs[1][0] = Res_cascade[0];
assign Res_configs[2][0] = Res_cascade[1];
assign Res_configs[3][0] = Res_cascade[2];
assign Res_configs[4][0] = Res_cascade[3];
assign Res_configs[5][0] = Res_cascade[4];
assign Res_configs[6][0] = Res_cascade[5];
assign Res_configs[7][0] = Res_cascade[6];
assign Res_configs[8][0] = Res_cascade[7];
assign Res_configs[9][0] = Res_cascade[8];
assign Res_configs[10][0] = Res_cas_in_temp[1];
assign Res_configs[11][0] = Res_cascade[10];
assign Res_configs[12][0] = Res_cascade[11];
assign Res_configs[13][0] = Res_cascade[12];
assign Res_configs[14][0] = Res_cascade[13];
assign Res_configs[15][0] = Res_cascade[14];
assign Res_configs[16][0] = Res_cascade[15];
assign Res_configs[17][0] = Res_cascade[16];
assign Res_configs[18][0] = Res_cascade[17];
assign Res_configs[19][0] = Res_cascade[18];

assign Res_out_temp[0][0] = Res_cascade[9];
assign Res_out_temp[1][0] = Res_cascade[19];
//////////////
//impconf_1

assign I_configs[0][1][0] = I_in_temp[1];
assign I_configs[0][1][1] = 0;
assign I_configs[1][1] = I_cascade[0];
assign I_configs[2][1][0] = I_in_temp[3];
assign I_configs[2][1][1] = 0;
assign I_configs[3][1] = I_cascade[2];
assign I_configs[4][1][0] = I_in_temp[5];
assign I_configs[4][1][1] = 0;
assign I_configs[5][1] = I_cascade[4];
assign I_configs[6][1][0] = I_in_temp[7];
assign I_configs[6][1][1] = 0;
assign I_configs[7][1] = I_cascade[6];
assign I_configs[8][1][0] = I_in_temp[9];
assign I_configs[8][1][1] = 0;
assign I_configs[9][1] = I_cascade[8];
assign I_configs[10][1][0] = I_in_temp[11];
assign I_configs[10][1][1] = 0;
assign I_configs[11][1] = I_cascade[10];
assign I_configs[12][1][0] = I_in_temp[13];
assign I_configs[12][1][1] = 0;
assign I_configs[13][1] = I_cascade[12];
assign I_configs[14][1][0] = I_in_temp[15];
assign I_configs[14][1][1] = 0;
assign I_configs[15][1] = I_cascade[14];
assign I_configs[16][1][0] = I_in_temp[17];
assign I_configs[16][1][1] = 0;
assign I_configs[17][1] = I_cascade[16];
assign I_configs[18][1][0] = I_in_temp[19];
assign I_configs[18][1][1] = 0;
assign I_configs[19][1] = I_cascade[18];

assign Res_configs[0][1] = Res_cas_in_temp[0];
assign Res_configs[1][1] = Res_cascade[0];
assign Res_configs[2][1] = Res_cascade[1];
assign Res_configs[3][1] = Res_cascade[2];
assign Res_configs[4][1] = Res_cascade[3];
assign Res_configs[5][1] = Res_cascade[4];
assign Res_configs[6][1] = Res_cascade[5];
assign Res_configs[7][1] = Res_cascade[6];
assign Res_configs[8][1] = Res_cascade[7];
assign Res_configs[9][1] = Res_cascade[8];
assign Res_configs[10][1] = Res_cas_in_temp[1];
assign Res_configs[11][1] = Res_cascade[10];
assign Res_configs[12][1] = Res_cascade[11];
assign Res_configs[13][1] = Res_cascade[12];
assign Res_configs[14][1] = Res_cascade[13];
assign Res_configs[15][1] = Res_cascade[14];
assign Res_configs[16][1] = Res_cascade[15];
assign Res_configs[17][1] = Res_cascade[16];
assign Res_configs[18][1] = Res_cascade[17];
assign Res_configs[19][1] = Res_cascade[18];

assign Res_out_temp[0][1] = Res_cascade[9];
assign Res_out_temp[1][1] = Res_cascade[19];
//////////////
//impconf_2

assign I_configs[0][2][0] = I_in_temp[1];
assign I_configs[0][2][1] = 0;
assign I_configs[1][2][0] = I_in_temp[3];
assign I_configs[1][2][1] = 0;
assign I_configs[2][2][0] = I_in_temp[5];
assign I_configs[2][2][1] = 0;
assign I_configs[3][2][0] = I_in_temp[7];
assign I_configs[3][2][1] = 0;
assign I_configs[4][2][0] = I_in_temp[9];
assign I_configs[4][2][1] = 0;
assign I_configs[5][2][0] = I_in_temp[11];
assign I_configs[5][2][1] = 0;
assign I_configs[6][2][0] = I_in_temp[13];
assign I_configs[6][2][1] = 0;
assign I_configs[7][2][0] = I_in_temp[15];
assign I_configs[7][2][1] = 0;
assign I_configs[8][2][0] = I_in_temp[17];
assign I_configs[8][2][1] = 0;
assign I_configs[9][2][0] = I_in_temp[19];
assign I_configs[9][2][1] = 0;
assign I_configs[10][2][0] = I_in_temp[1];
assign I_configs[10][2][1] = 0;
assign I_configs[11][2][0] = I_in_temp[3];
assign I_configs[11][2][1] = 0;
assign I_configs[12][2][0] = I_in_temp[5];
assign I_configs[12][2][1] = 0;
assign I_configs[13][2][0] = I_in_temp[7];
assign I_configs[13][2][1] = 0;
assign I_configs[14][2][0] = I_in_temp[9];
assign I_configs[14][2][1] = 0;
assign I_configs[15][2][0] = I_in_temp[11];
assign I_configs[15][2][1] = 0;
assign I_configs[16][2][0] = I_in_temp[13];
assign I_configs[16][2][1] = 0;
assign I_configs[17][2][0] = I_in_temp[15];
assign I_configs[17][2][1] = 0;
assign I_configs[18][2][0] = I_in_temp[17];
assign I_configs[18][2][1] = 0;
assign I_configs[19][2][0] = I_in_temp[19];
assign I_configs[19][2][1] = 0;

assign Res_configs[0][2] = Res_cas_in_temp[0];
assign Res_configs[1][2] = Res_cascade[0];
assign Res_configs[2][2] = Res_cascade[1];
assign Res_configs[3][2] = Res_cascade[2];
assign Res_configs[4][2] = Res_cascade[3];
assign Res_configs[5][2] = Res_cascade[4];
assign Res_configs[6][2] = Res_cascade[5];
assign Res_configs[7][2] = Res_cascade[6];
assign Res_configs[8][2] = Res_cascade[7];
assign Res_configs[9][2] = Res_cascade[8];
assign Res_configs[10][2] = Res_cas_in_temp[1];
assign Res_configs[11][2] = Res_cascade[10];
assign Res_configs[12][2] = Res_cascade[11];
assign Res_configs[13][2] = Res_cascade[12];
assign Res_configs[14][2] = Res_cascade[13];
assign Res_configs[15][2] = Res_cascade[14];
assign Res_configs[16][2] = Res_cascade[15];
assign Res_configs[17][2] = Res_cascade[16];
assign Res_configs[18][2] = Res_cascade[17];
assign Res_configs[19][2] = Res_cascade[18];

assign Res_out_temp[0][2] = Res_cascade[9];
assign Res_out_temp[1][2] = Res_cascade[19];
