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
assign I_configs[1][2] = I_cascade[0];
assign I_configs[2][2] = I_cascade[1];
assign I_configs[3][2] = I_in_temp[1];
assign I_configs[4][2] = I_cascade[3];
assign I_configs[5][2] = I_cascade[4];
assign I_configs[6][2] = I_in_temp[2];
assign I_configs[7][2] = I_cascade[6];
assign I_configs[8][2] = I_cascade[7];
assign I_configs[9][2] = I_in_temp[3];
assign I_configs[10][2] = I_cascade[9];
assign I_configs[11][2] = I_cascade[10];

assign Res_configs[0][2] = Res_cas_in_temp[0];
assign Res_configs[1][2] = Res_cascade[0];
assign Res_configs[2][2] = Res_cascade[1];
assign Res_configs[3][2] = Res_cas_in_temp[1];
assign Res_configs[4][2] = Res_cascade[3];
assign Res_configs[5][2] = Res_cascade[4];
assign Res_configs[6][2] = Res_cas_in_temp[2];
assign Res_configs[7][2] = Res_cascade[6];
assign Res_configs[8][2] = Res_cascade[7];
assign Res_configs[9][2] = Res_cas_in_temp[3];
assign Res_configs[10][2] = Res_cascade[9];
assign Res_configs[11][2] = Res_cascade[10];

assign Res_out_temp[0][2] = Res_cascade[2];
assign Res_out_temp[1][2] = Res_cascade[5];
assign Res_out_temp[2][2] = Res_cascade[8];
assign Res_out_temp[3][2] = Res_cascade[11];
//////////////
//impconf_3

assign I_configs[0][3] = I_in_temp[0];
assign I_configs[1][3] = I_cascade[0];
assign I_configs[2][3] = I_cascade[1];
assign I_configs[3][3] = I_in_temp[1];
assign I_configs[4][3] = I_cascade[3];
assign I_configs[5][3] = I_cascade[4];
assign I_configs[6][3] = I_in_temp[2];
assign I_configs[7][3] = I_cascade[6];
assign I_configs[8][3] = I_cascade[7];
assign I_configs[9][3] = I_in_temp[3];
assign I_configs[10][3] = I_cascade[9];
assign I_configs[11][3] = I_cascade[10];

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
//////////////
//impconf_4

assign I_configs[0][4] = I_in_temp[1];
assign I_configs[1][4] = I_cascade[0];
assign I_configs[2][4] = I_cascade[1];
assign I_configs[3][4] = I_in_temp[1];
assign I_configs[4][4] = I_cascade[3];
assign I_configs[5][4] = I_cascade[4];
assign I_configs[6][4] = I_in_temp[3];
assign I_configs[7][4] = I_cascade[6];
assign I_configs[8][4] = I_cascade[7];
assign I_configs[9][4] = I_in_temp[3];
assign I_configs[10][4] = I_cascade[9];
assign I_configs[11][4] = I_cascade[10];

assign Res_configs[0][4] = Res_cas_in_temp[0];
assign Res_configs[1][4] = Res_cascade[0];
assign Res_configs[2][4] = Res_cascade[1];
assign Res_configs[3][4] = Res_cas_in_temp[1];
assign Res_configs[4][4] = Res_cascade[3];
assign Res_configs[5][4] = Res_cascade[4];
assign Res_configs[6][4] = Res_cas_in_temp[2];
assign Res_configs[7][4] = Res_cascade[6];
assign Res_configs[8][4] = Res_cascade[7];
assign Res_configs[9][4] = Res_cas_in_temp[3];
assign Res_configs[10][4] = Res_cascade[9];
assign Res_configs[11][4] = Res_cascade[10];

assign Res_out_temp[0][4] = Res_cascade[2];
assign Res_out_temp[1][4] = Res_cascade[5];
assign Res_out_temp[2][4] = Res_cascade[8];
assign Res_out_temp[3][4] = Res_cascade[11];
//////////////
//impconf_5

assign I_configs[0][5] = I_in_temp[1];
assign I_configs[1][5] = I_cascade[0];
assign I_configs[2][5] = I_cascade[1];
assign I_configs[3][5] = I_in_temp[3];
assign I_configs[4][5] = I_cascade[3];
assign I_configs[5][5] = I_cascade[4];
assign I_configs[6][5] = I_in_temp[1];
assign I_configs[7][5] = I_cascade[6];
assign I_configs[8][5] = I_cascade[7];
assign I_configs[9][5] = I_in_temp[3];
assign I_configs[10][5] = I_cascade[9];
assign I_configs[11][5] = I_cascade[10];

assign Res_configs[0][5] = Res_cas_in_temp[0];
assign Res_configs[1][5] = Res_cascade[0];
assign Res_configs[2][5] = Res_cascade[1];
assign Res_configs[3][5] = Res_cas_in_temp[1];
assign Res_configs[4][5] = Res_cascade[3];
assign Res_configs[5][5] = Res_cascade[4];
assign Res_configs[6][5] = Res_cas_in_temp[2];
assign Res_configs[7][5] = Res_cascade[6];
assign Res_configs[8][5] = Res_cascade[7];
assign Res_configs[9][5] = Res_cas_in_temp[3];
assign Res_configs[10][5] = Res_cascade[9];
assign Res_configs[11][5] = Res_cascade[10];

assign Res_out_temp[0][5] = Res_cascade[2];
assign Res_out_temp[1][5] = Res_cascade[5];
assign Res_out_temp[2][5] = Res_cascade[8];
assign Res_out_temp[3][5] = Res_cascade[11];
//////////////
//impconf_6

assign I_configs[0][6] = I_in_temp[0];
assign I_configs[1][6] = I_cascade[0];
assign I_configs[2][6] = I_cascade[1];
assign I_configs[3][6] = I_in_temp[1];
assign I_configs[4][6] = I_cascade[3];
assign I_configs[5][6] = I_cascade[4];
assign I_configs[6][6] = I_in_temp[2];
assign I_configs[7][6] = I_cascade[6];
assign I_configs[8][6] = I_cascade[7];
assign I_configs[9][6] = I_in_temp[3];
assign I_configs[10][6] = I_cascade[9];
assign I_configs[11][6] = I_cascade[10];

assign Res_configs[0][6] = Res_cas_in_temp[1];
assign Res_configs[1][6] = Res_cascade[0];
assign Res_configs[2][6] = Res_cascade[1];
assign Res_configs[3][6] = Res_cascade[2];
assign Res_configs[4][6] = Res_cascade[3];
assign Res_configs[5][6] = Res_cascade[4];
assign Res_configs[6][6] = Res_cas_in_temp[3];
assign Res_configs[7][6] = Res_cascade[6];
assign Res_configs[8][6] = Res_cascade[7];
assign Res_configs[9][6] = Res_cascade[8];
assign Res_configs[10][6] = Res_cascade[9];
assign Res_configs[11][6] = Res_cascade[10];

assign Res_out_temp[0][6] = {RES_W{1'bx}};
assign Res_out_temp[1][6] = Res_cascade[5];
assign Res_out_temp[2][6] = {RES_W{1'bx}};
assign Res_out_temp[3][6] = Res_cascade[11];
//////////////
//impconf_7

assign I_configs[0][7] = I_in_temp[0];
assign I_configs[1][7] = I_cascade[0];
assign I_configs[2][7] = I_cascade[1];
assign I_configs[3][7] = I_cascade[2];
assign I_configs[4][7] = I_in_temp[1];
assign I_configs[5][7] = I_cascade[4];
assign I_configs[6][7] = I_cascade[5];
assign I_configs[7][7] = I_cascade[6];
assign I_configs[8][7] = I_in_temp[2];
assign I_configs[9][7] = I_cascade[8];
assign I_configs[10][7] = I_cascade[9];
assign I_configs[11][7] = I_cascade[10];

assign Res_configs[0][7] = Res_cas_in_temp[0];
assign Res_configs[1][7] = Res_cascade[0];
assign Res_configs[2][7] = Res_cascade[1];
assign Res_configs[3][7] = Res_cascade[2];
assign Res_configs[4][7] = Res_cas_in_temp[1];
assign Res_configs[5][7] = Res_cascade[4];
assign Res_configs[6][7] = Res_cascade[5];
assign Res_configs[7][7] = Res_cascade[6];
assign Res_configs[8][7] = Res_cas_in_temp[2];
assign Res_configs[9][7] = Res_cascade[8];
assign Res_configs[10][7] = Res_cascade[9];
assign Res_configs[11][7] = Res_cascade[10];

assign Res_out_temp[0][7] = Res_cascade[3];
assign Res_out_temp[1][7] = Res_cascade[7];
assign Res_out_temp[2][7] = Res_cascade[11];
assign Res_out_temp[3][7] = {RES_W{1'bx}};
//////////////
//impconf_8

assign I_configs[0][8] = I_in_temp[3];
assign I_configs[1][8] = I_cascade[0];
assign I_configs[2][8] = I_cascade[1];
assign I_configs[3][8] = I_cascade[2];
assign I_configs[4][8] = I_in_temp[3];
assign I_configs[5][8] = I_cascade[4];
assign I_configs[6][8] = I_cascade[5];
assign I_configs[7][8] = I_cascade[6];
assign I_configs[8][8] = I_in_temp[3];
assign I_configs[9][8] = I_cascade[8];
assign I_configs[10][8] = I_cascade[9];
assign I_configs[11][8] = I_cascade[10];

assign Res_configs[0][8] = Res_cas_in_temp[0];
assign Res_configs[1][8] = Res_cascade[0];
assign Res_configs[2][8] = Res_cascade[1];
assign Res_configs[3][8] = Res_cascade[2];
assign Res_configs[4][8] = Res_cas_in_temp[1];
assign Res_configs[5][8] = Res_cascade[4];
assign Res_configs[6][8] = Res_cascade[5];
assign Res_configs[7][8] = Res_cascade[6];
assign Res_configs[8][8] = Res_cas_in_temp[2];
assign Res_configs[9][8] = Res_cascade[8];
assign Res_configs[10][8] = Res_cascade[9];
assign Res_configs[11][8] = Res_cascade[10];

assign Res_out_temp[0][8] = Res_cascade[3];
assign Res_out_temp[1][8] = Res_cascade[7];
assign Res_out_temp[2][8] = Res_cascade[11];
assign Res_out_temp[3][8] = {RES_W{1'bx}};
//////////////
//impconf_9

assign I_configs[0][9] = I_in_temp[0];
assign I_configs[1][9] = I_cascade[0];
assign I_configs[2][9] = I_cascade[1];
assign I_configs[3][9] = I_cascade[2];
assign I_configs[4][9] = I_in_temp[1];
assign I_configs[5][9] = I_cascade[4];
assign I_configs[6][9] = I_cascade[5];
assign I_configs[7][9] = I_cascade[6];
assign I_configs[8][9] = I_in_temp[2];
assign I_configs[9][9] = I_cascade[8];
assign I_configs[10][9] = I_cascade[9];
assign I_configs[11][9] = I_cascade[10];

assign Res_configs[0][9] = Res_cas_in_temp[3];
assign Res_configs[1][9] = Res_cascade[0];
assign Res_configs[2][9] = Res_cascade[1];
assign Res_configs[3][9] = Res_cascade[2];
assign Res_configs[4][9] = Res_cascade[3];
assign Res_configs[5][9] = Res_cascade[4];
assign Res_configs[6][9] = Res_cascade[5];
assign Res_configs[7][9] = Res_cascade[6];
assign Res_configs[8][9] = Res_cascade[7];
assign Res_configs[9][9] = Res_cascade[8];
assign Res_configs[10][9] = Res_cascade[9];
assign Res_configs[11][9] = Res_cascade[10];

assign Res_out_temp[0][9] = {RES_W{1'bx}};
assign Res_out_temp[1][9] = {RES_W{1'bx}};
assign Res_out_temp[2][9] = {RES_W{1'bx}};
assign Res_out_temp[3][9] = Res_cascade[11];
//////////////
//impconf_10

assign I_configs[0][10] = I_in_temp[1];
assign I_configs[1][10] = I_cascade[0];
assign I_configs[2][10] = I_cascade[1];
assign I_configs[3][10] = I_cascade[2];
assign I_configs[4][10] = I_cascade[3];
assign I_configs[5][10] = I_cascade[4];
assign I_configs[6][10] = I_in_temp[3];
assign I_configs[7][10] = I_cascade[6];
assign I_configs[8][10] = I_cascade[7];
assign I_configs[9][10] = I_cascade[8];
assign I_configs[10][10] = I_cascade[9];
assign I_configs[11][10] = I_cascade[10];

assign Res_configs[0][10] = Res_cas_in_temp[1];
assign Res_configs[1][10] = Res_cascade[0];
assign Res_configs[2][10] = Res_cascade[1];
assign Res_configs[3][10] = Res_cascade[2];
assign Res_configs[4][10] = Res_cascade[3];
assign Res_configs[5][10] = Res_cascade[4];
assign Res_configs[6][10] = Res_cas_in_temp[3];
assign Res_configs[7][10] = Res_cascade[6];
assign Res_configs[8][10] = Res_cascade[7];
assign Res_configs[9][10] = Res_cascade[8];
assign Res_configs[10][10] = Res_cascade[9];
assign Res_configs[11][10] = Res_cascade[10];

assign Res_out_temp[0][10] = {RES_W{1'bx}};
assign Res_out_temp[1][10] = Res_cascade[5];
assign Res_out_temp[2][10] = {RES_W{1'bx}};
assign Res_out_temp[3][10] = Res_cascade[11];
