module Miller_Demodule(
 	input   		clk					,//32M      
    output reg  	Bit_in=0			,
    output reg  	Bit_in_valid=0		,        
    input    		Miller_BitIn       	//2M  
);
    
reg     [7:0]   	clk_cnt = 0			;
reg             	bit_cnt = 0			;
reg     [4:0]   	Miller_BitIn_tmp = 0;	
reg             	Bit_sync  = 0		;	
reg     [2:0]   	state_reg = 0		;	
reg             	Miller_BitIn_r1 = 0	;
wire            	Miller_BitIn_posedge = Miller_BitIn && (~Miller_BitIn_r1);

always @(posedge clk) begin
    Miller_BitIn_r1<=Miller_BitIn;
end
    
always @ (posedge clk) begin
    case (state_reg)
    0:begin
        clk_cnt<=0;
        Bit_sync<=0;
        if(Miller_BitIn_posedge)
            state_reg<=1;
    end    
    1:begin 
        if(clk_cnt==7)  //输入时钟32M、曼切斯特速率2M
            clk_cnt<=0;                                                         
        else
            clk_cnt<=clk_cnt+1; 
                         
        if(clk_cnt==7)
        begin                
            if((Miller_BitIn_tmp[3:0]==4'b0000 || Miller_BitIn_tmp[3:0]==4'b1111) && Bit_sync==0)//寻找 同步头   
                Bit_sync<=1;                    
            else 
            if((Miller_BitIn_tmp[3:0]==4'b0000 || Miller_BitIn_tmp[3:0]==4'b0010
                || Miller_BitIn_tmp[3:0]==4'b0100 || Miller_BitIn_tmp[3:0]==4'b0101  
                || Miller_BitIn_tmp[3:0]==4'b1010  || Miller_BitIn_tmp[3:0]==4'b1011
                || Miller_BitIn_tmp[3:0]==4'b1101  || Miller_BitIn_tmp[3:0]==4'b1111) 
                && bit_cnt==1) //同步头 丢失后 重新寻找头
            begin
                Bit_sync<=0;
                state_reg<=0;
            end
            //else if(Miller_BitIn_tmp[4:0] == 5'b00000 || Miller_BitIn_tmp[4:0] == 5'b11111)  //当超过5个0或5个1时，Miller解码结束
            //    state_reg<=0;                 
        end   
                          
    end       
   endcase 
end

always @ (posedge clk) begin
    if(Bit_sync==1)
    begin
        if(clk_cnt==4)
            bit_cnt<=bit_cnt+1;
     end
     else
        bit_cnt<=0;
end
    
    
always @ (posedge clk) begin
    if(state_reg==1) begin
        if(clk_cnt==4)
            Miller_BitIn_tmp[4:0]<={Miller_BitIn_tmp[3:0],Miller_BitIn};
    end
    else
        Miller_BitIn_tmp[4:0]<=0;
end
    
always @ (posedge clk) begin
    if(clk_cnt==7 && bit_cnt==1) begin
         case(Miller_BitIn_tmp[1:0])
             2'b01,2'b10:Bit_in<=1;
             2'b11,2'b00:Bit_in<=0;
             default:Bit_in<=0;
      endcase
    end
end
    
always @ (posedge clk) begin
    if(bit_cnt==1 && clk_cnt==0 && Bit_sync==1) begin              
        Bit_in_valid<=1;              
    end
    else
        Bit_in_valid<=0; 

end
endmodule