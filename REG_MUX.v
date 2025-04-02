module REG_MUX #(
    parameter RSTTYPE = "SYNC" ,
    parameter reg_SIZE = 18 )(
        input [reg_SIZE-1:0] IN ,
        input clk , rst , CE ,PIPELINE_EN , 
        output   [reg_SIZE-1:0] out );
// INSTANTIATION TEMPLATE:
// REG_MUX #(.RSTTYPE("SYNC"),.reg_SIZE()) YOUR_INSTANCE_NAME (.IN(),.clk(),.rst(),.CE(),.PIPELINE_EN(),.out()) ;

reg  [reg_SIZE-1:0] REG ;

generate
    if (RSTTYPE == "SYNC") begin
        always @(posedge clk ) begin
            if (rst) REG <= {reg_SIZE{1'b0}} ;
            else if (CE) REG <= IN ;
        end
    end
    else if (RSTTYPE == "ASYNC") begin
        always @(posedge clk or posedge rst) begin
            if (rst) REG <= {reg_SIZE{1'b0}} ;
            else if (CE) REG <= IN ;
        end
    end
endgenerate

assign out = (PIPELINE_EN)? REG : IN ;

endmodule