module Miller_top(
    input   			clk					,
    input   			rst_p				,    
    input 	[7:0]   	data_in				,
    input         		data_in_valid		,
    output        		data_tready			,
				
    output  [7:0] 		data_out			,
    output        		data_out_valid		,  
				
    input         		Miller_BitIn		,
    output        		Miller_BitOut   	 
);


reg         			Bit_out  			;//1bit发送数据
reg         			Bit_out_valid =0 	;//1bit发送数据有效信号
wire        			Bit_out_tready		;//发送1bit结束
			
wire        			Bit_in  			;//1bit接收数据
wire        			Bit_in_valid		;//1bit接收数据有效信号

reg     [7:0]   		data_in_reg			;
reg     [7:0]   		bit_cnt = 0			;
reg     [2:0]   		state_reg = 0		;
		
reg             		data_in_valid_r1 = 0;
reg             		data_in_valid_r2 = 0;
wire            		data_in_valid_posedge = data_in_valid_r1 && (~data_in_valid_r2);
    
    
///    
always @(posedge clk) begin
    data_in_valid_r1<=data_in_valid;
    data_in_valid_r2<=data_in_valid_r1;
end


always @ (posedge clk) begin
    case (state_reg)
    0:begin
        if(data_in_valid_posedge)
        begin
            Bit_out_valid<=1;
            state_reg<=1;
        end
    end
    
    1:begin
        if(Bit_out_tready)  begin              
            if(bit_cnt==7)   begin
                bit_cnt<=0;
                if(data_in_valid==0) begin
                    Bit_out_valid<=0;
                    state_reg<=0;
                end
            end                                    
            else
                bit_cnt<=bit_cnt+1;
        end
    end
   endcase 
end

always @ (posedge clk) begin
   if(bit_cnt==0)
       data_in_reg<=data_in;
end

always @ (posedge clk) begin
   case(bit_cnt)
       0:Bit_out<=data_in_reg[7];
       1:Bit_out<=data_in_reg[6];
       2:Bit_out<=data_in_reg[5];
       3:Bit_out<=data_in_reg[4];
       4:Bit_out<=data_in_reg[3];
       5:Bit_out<=data_in_reg[2];
       6:Bit_out<=data_in_reg[1];
       7:Bit_out<=data_in_reg[0];
   endcase
end

assign    data_tready  = (bit_cnt==7)   ?  1: 0;
    
///Miller 编码
Miller_Module Miller_tx(
    .clk(clk),
    .Bit_out(Bit_out),
    .Bit_out_valid(Bit_out_valid),
    .Bit_out_tready(Bit_out_tready),
    .Miller_BitOut(Miller_BitOut)    
);
       
///Miller 解码//    仿真时接上面输出
Miller_Demodule Miller_rx(
     .clk(clk),
     .Bit_in(Bit_in),
     .Bit_in_valid(Bit_in_valid),

     .Miller_BitIn(Miller_BitOut)//Mqst_BitIn    
);
endmodule