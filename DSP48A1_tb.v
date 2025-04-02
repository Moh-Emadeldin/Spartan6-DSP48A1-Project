module DSP48A1_tb ();
    parameter A0REG = 0 ;
    parameter A1REG = 1 ;
    parameter B0REG = 0 ;
    parameter B1REG = 1 ;
    parameter CREG  = 1 ;
    parameter DREG  = 1 ;
    parameter MREG  = 1 ;
    parameter PREG  = 1 ;
    parameter CARRYINREG  = 1 ;
    parameter CARRYOUTREG  = 1 ;
    parameter OPMODEREG  = 1 ;
    parameter CARRYINSEL  = "OPMODE5" ;
    parameter B_UNPUT  = "DIRECT" ;
    parameter RSTTYPE  = "SYNC"  ;
        reg [17:0] A , B , D ;
        reg [47:0] C ;
        reg [17:0] BCIN ;
        reg [47:0] PCIN ;
        reg CARRYIN ; 
        reg clk ;
        reg [7:0] OPMODE ;
        reg CEA , CEB , CEC , CECARRYIN , CED , CEM , CEOPMODE , CEP ;
        reg RSTA , RSTB , RSTC , RSTCARRYIN , RSTD , RSTM , RSTOPMODE , RSTP ;
        reg [47:0] P_expected  ;
        reg CARRYOUT_expected ; 
        wire  CARRYOUT , CARRYOUTF ; 
        wire [47:0] P ;
        wire  [35:0] M ;
        wire  [17:0] BCOUT ;
        wire  [47:0] PCOUT ;

        DSP48A1 DUT(.*);

initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk ;
    end
end
initial begin
    RSTA = 1 ; RSTB = 1 ; RSTC = 1 ; RSTD = 1 ;
    RSTCARRYIN = 1 ;
    RSTM = 1 ;
     
    RSTP = 1 ;
    @(negedge clk) ;
    RSTA = 0 ;
    RSTB = 0 ;
    RSTC = 0 ;
    RSTCARRYIN = 0 ;
    RSTD = 0 ;
    RSTM = 0 ;
    RSTOPMODE = 0 ;
    RSTP = 0 ;
    CEA = 1'b1 ;
    CEB = 1'b1 ;
    CEC = 1'b1 ; 
    CECARRYIN = 1'b1 ;
    CED = 1'b1 ;
    CEM = 1'b1;
    CEOPMODE = 1'b1 ;
    CEP = 1'b1 ;
    ///////1///////
    OPMODE = 8'b00100000 ;
    {CARRYOUT_expected,P_expected} = 1 ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b", P, P_expected, CARRYOUT);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////2///////
    OPMODE = 8'b10100000 ;
    {CARRYOUT_expected,P_expected} = -1 ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b", P, P_expected, CARRYOUT);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////3///////
    OPMODE = 8'b00100011 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    {CARRYOUT_expected,P_expected} = {D[11:0] , A[17:0] , B[17:0]} + OPMODE[5] ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b", P, P_expected, CARRYOUT);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////4///////
    OPMODE = 8'b00110011 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    {CARRYOUT_expected,P_expected} = {D[11:0] , A[17:0] , (D+B)} + OPMODE[5] ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;
    
    ///////5///////
    OPMODE = 8'b00100001 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    {CARRYOUT_expected,P_expected} = (A*B) + OPMODE[5] ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////6///////
    OPMODE = 8'b01010001 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    {CARRYOUT_expected,P_expected} = (A*(D-B)) + OPMODE[5] ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, OPMODE=%b, CARRYIN=%b", A, B, D, C, OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////7///////
    OPMODE = 8'b00000111 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    PCIN = $random ;
    {CARRYOUT_expected,P_expected} = PCIN + ({D[11:0] , A[17:0] , B[17:0]} + OPMODE[5]) ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, PCIN=%h OPMODE=%b, CARRYIN=%b", A, B, D, C, PCIN , OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////8///////
    OPMODE = 8'b00110111 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    PCIN = $random ;
    {CARRYOUT_expected,P_expected} = PCIN + ({D[11:0] , A[17:0] , (D+B)} + OPMODE[5]) ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, PCIN=%h OPMODE=%b, CARRYIN=%b", A, B, D, C, PCIN , OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////9///////
    OPMODE = 8'b00100101 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    PCIN = $random ;
    {CARRYOUT_expected,P_expected} = PCIN + ((A*B)+ OPMODE[5]) ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, PCIN=%h OPMODE=%b, CARRYIN=%b", A, B, D, C, PCIN , OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    ///////10///////
    OPMODE = 8'b00111111 ;
    A = $random ;
    B = $random ;
    C = $random ;
    D = $random ;
    PCIN = $random ;
    {CARRYOUT_expected,P_expected} = C + ({D[11:0] , A[17:0] , (D+B)}) + OPMODE[5] ;
    repeat(4) @ (negedge clk) ;
    $display("Inputs: A=%h, B=%h, D=%h, C=%h, PCIN=%h OPMODE=%b, CARRYIN=%b", A, B, D, C, PCIN , OPMODE, CARRYIN);
    $display("Outputs: P=%h, Expected P=%h, CARRYOUT=%b ,CARRYOUT_expected=%b", P, P_expected, CARRYOUT,CARRYOUT_expected);
    $display("_________________________________________________________");

    if ((P != P_expected)||(CARRYOUT!=CARRYOUT_expected)) $display ("%t : ERROR ",$time) ;

    $stop;
 
end   
   

endmodule