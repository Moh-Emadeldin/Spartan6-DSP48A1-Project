module DSP48A1 #(
    parameter A0REG = 1'b0 ,
    parameter A1REG = 1'b1 ,
    parameter B0REG = 1'b0 ,
    parameter B1REG = 1'b1 ,
    parameter CREG  = 1'b1 ,
    parameter DREG  = 1'b1 ,
    parameter MREG  = 1'b1 ,
    parameter PREG  = 1'b1 ,
    parameter CARRYINREG  = 1'b1 ,
    parameter CARRYOUTREG  = 1'b1 ,
    parameter OPMODEREG  = 1'b1 ,
    parameter CARRYINSEL  = "OPMODE5" ,
    parameter B_INPUT  = "DIRECT" ,
    parameter RSTTYPE  = "SYNC" )(
        input [17:0] A , B , D ,
        input [47:0] C ,
        input [17:0] BCIN ,
        input [47:0] PCIN ,
        input CARRYIN , 
        input clk ,
        input [7:0] OPMODE ,
        input CEA , CEB , CEC , CECARRYIN , CED , CEM , CEOPMODE , CEP ,
        input RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP ,
        output  CARRYOUT , CARRYOUTF , 
        output  [47:0] P ,
        output  [35:0] M ,
        output  [17:0] BCOUT ,
        output  [47:0] PCOUT );

wire [7:0] opmode ;
wire [17:0] W0 , W1 , W2 , W3 , W5 , W6 , W7 , W8;
wire [47:0] W4  , W13 , W14 , DAB , W15 ;
wire [35:0] W9 , W10;
wire W11 , W12 , W16 ;
    assign W0 = (B_INPUT == "DIRECT")? B : (B_INPUT == "CASCADE")? BCIN : 18'b0 ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(8)) OPMODE_REG (.IN(OPMODE),.PIPELINE_EN(OPMODEREG),.clk(clk),.rst(RSTOPMODE),.CE(CEOPMODE),.out(opmode)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(18)) D_REG (.IN(D),.PIPELINE_EN(DREG),.clk(clk),.rst(RSTD),.CE(CED),.out(W1)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(18)) B0_REG (.IN(W0),.PIPELINE_EN(B0REG),.clk(clk),.rst(RSTB),.CE(CEB),.out(W2)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(18)) A0_REG (.IN(A),.PIPELINE_EN(A0REG),.clk(clk),.rst(RSTA),.CE(CEA),.out(W3)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(48)) C_REG (.IN(C),.PIPELINE_EN(CREG),.clk(clk),.rst(RSTC),.CE(CEC),.out(W4)) ;
    assign W5 = (opmode[6])? W1-W2 : W1+W2 ;
    assign W6 = (opmode[4])? W5 : W2 ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(18)) B1_REG (.IN(W6),.PIPELINE_EN(B1REG),.clk(clk),.rst(RSTB),.CE(CEB),.out(W7)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(18)) A1_REG (.IN(W3),.PIPELINE_EN(A1REG),.clk(clk),.rst(RSTA),.CE(CEA),.out(W8)) ;
    assign BCOUT = W7 ;
    assign DAB = {W1[11:0] , W8[17:0] , W7[17:0]} ;
    assign W9 = W7 * W8 ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(36)) M_REG (.IN(W9),.PIPELINE_EN(MREG),.clk(clk),.rst(RSTM),.CE(CEM),.out(W10)) ;
    assign M = W10 ;
    assign W11 = (CARRYINSEL == "OPMODE5")? opmode[5] : (CARRYINSEL == "CARRYIN")? CARRYIN : 1'b0 ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(1)) CYI (.IN(W11),.PIPELINE_EN(CARRYINREG),.clk(clk),.rst(RSTCARRYIN),.CE(CECARRYIN),.out(W12)) ;
    assign W13 = (opmode[1:0] == 2'b00) ? 48'b0 :
                 (opmode[1:0] == 2'b01) ? {12'b0,W10} :
                 (opmode[1:0] == 2'b10) ? P :
                 (opmode[1:0] == 2'b11) ? DAB : 48'bx ;
    assign W14 = (opmode[3:2] == 2'b00) ? 48'b0 :
                 (opmode[3:2] == 2'b01) ? PCIN :
                 (opmode[3:2] == 2'b10) ? P :
                 (opmode[3:2] == 2'b11) ? W4 : 48'bx ;
    assign {W16,W15} = (opmode[7])? (W14 - (W13 + W12 )) : (W14 + (W13 + W12)) ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(1)) CYO_REG (.IN(W16),.PIPELINE_EN(CARRYOUTREG),.clk(clk),.rst(RSTCARRYIN),.CE(CECARRYIN),.out(CARRYOUT)) ;
    assign CARRYOUTF =  CARRYOUT ;
    REG_MUX #(.RSTTYPE(RSTTYPE),.reg_SIZE(48)) P_REG (.IN(W15),.PIPELINE_EN(PREG),.clk(clk),.rst(RSTP),.CE(CEP),.out(P)) ;
    assign PCOUT = P ;
    
endmodule