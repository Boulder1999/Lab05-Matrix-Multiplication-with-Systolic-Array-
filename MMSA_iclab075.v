module MMSA(
// input signals
    clk,
    rst_n,
    in_valid,
	in_valid2,
    matrix,
	matrix_size,
    i_mat_idx,
    w_mat_idx,
	
// output signals
    out_valid,
    out_value
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input        clk, rst_n, in_valid, in_valid2;
input [15:0] matrix;
input [1:0]  matrix_size;
input [3:0]  i_mat_idx, w_mat_idx;

output reg       	     out_valid;
output reg signed [39:0] out_value;
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
parameter IDLE=3'd0,LOAD=3'd1,IN_TWO=3'd2,STOP=3'd3,PROCESS=3'd4,OUT=3'd5;
reg [2:0] cs,ns;
integer i;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg process_flag;
reg signed [15:0]data_d;
reg [31:0]write;
reg [7:0] cnt_addr;
reg [7:0] cnt_addr_w;
reg [5:0] cnt_matrix;
reg [7:0] cnt_matrix_out;
reg [5:0] cnt_matrix_w;
reg [5:0] cnt_out;
reg [9:0] cnt_start;
reg [17:0] cnt_size;
reg [1:0] size_matrix;
reg [3:0] x_idx;
reg [4:0] w_idx;
reg CEN_0;
wire [15:0] z_q[0:31];
reg signed [15:0] x_data [0:255];
reg signed [15:0] w_data [0:255];
reg signed [39:0] y_data [0:255];
wire signed [39:0] z_ans2,z_ans4,z_ans8,z_ans16;
reg [8:0] mem_idx_w;
reg [8:0] mem_idx_x;
reg signed [15:0] mult2_x [0:1],mult2_w [0:1];
reg signed [15:0] mult4_x [0:3],mult4_w [0:3];
reg signed [15:0] mult8_x [0:7],mult8_w [0:7];
reg signed [15:0] mult16_x [0:15],mult16_w [0:15];

//---------------------------------------------------------------------
//   MEM DECLARATION
//---------------------------------------------------------------------
//x
RA1SH x00 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[0]), .OEN(1'b0), .Q(z_q[0]));
RA1SH x01 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[1]), .OEN(1'b0), .Q(z_q[1]));
RA1SH x02 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[2]), .OEN(1'b0), .Q(z_q[2]));
RA1SH x03 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[3]), .OEN(1'b0), .Q(z_q[3]));
RA1SH x04 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[4]), .OEN(1'b0), .Q(z_q[4]));
RA1SH x05 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[5]), .OEN(1'b0), .Q(z_q[5]));
RA1SH x06 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[6]), .OEN(1'b0), .Q(z_q[6]));
RA1SH x07 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[7]), .OEN(1'b0), .Q(z_q[7]));
RA1SH x08 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[8]), .OEN(1'b0), .Q(z_q[8]));
RA1SH x09 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[9]), .OEN(1'b0), .Q(z_q[9]));
RA1SH x10 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[10]), .OEN(1'b0), .Q(z_q[10]));
RA1SH x11 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[11]), .OEN(1'b0), .Q(z_q[11]));
RA1SH x12 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[12]), .OEN(1'b0), .Q(z_q[12]));
RA1SH x13 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[13]), .OEN(1'b0), .Q(z_q[13]));
RA1SH x14 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[14]), .OEN(1'b0), .Q(z_q[14]));
RA1SH x15 (.A(cnt_addr), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[15]), .OEN(1'b0), .Q(z_q[15]));
//W
RA1SH w00 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[16]), .OEN(1'b0), .Q(z_q[16]));
RA1SH w01 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[17]), .OEN(1'b0), .Q(z_q[17]));
RA1SH w02 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[18]), .OEN(1'b0), .Q(z_q[18]));
RA1SH w03 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[19]), .OEN(1'b0), .Q(z_q[19]));
RA1SH w04 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[20]), .OEN(1'b0), .Q(z_q[20]));
RA1SH w05 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[21]), .OEN(1'b0), .Q(z_q[21]));
RA1SH w06 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[22]), .OEN(1'b0), .Q(z_q[22]));
RA1SH w07 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[23]), .OEN(1'b0), .Q(z_q[23]));
RA1SH w08 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[24]), .OEN(1'b0), .Q(z_q[24]));
RA1SH w09 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[25]), .OEN(1'b0), .Q(z_q[25]));
RA1SH w10 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[26]), .OEN(1'b0), .Q(z_q[26]));
RA1SH w11 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[27]), .OEN(1'b0), .Q(z_q[27]));
RA1SH w12 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[28]), .OEN(1'b0), .Q(z_q[28]));
RA1SH w13 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[29]), .OEN(1'b0), .Q(z_q[29]));
RA1SH w14 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[30]), .OEN(1'b0), .Q(z_q[30]));
RA1SH w15 (.A(cnt_addr_w), .D(data_d), .CLK(clk), .CEN(CEN_0), .WEN(write[31]), .OEN(1'b0), .Q(z_q[31]));
//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        cs<=IDLE;
    end
    else begin
        cs<=ns;
    end
end
always@(*)
begin
    case(cs)
    IDLE:begin
        if(in_valid) begin
            ns = LOAD;
        end
        else begin
            ns = IDLE;
        end
    end
    LOAD:begin
        if(cnt_matrix < 6'd32)
        begin
            ns = LOAD;
        end
        else begin
            ns = STOP;
        end
    end
    STOP:begin
        if(in_valid2) begin
             ns = IN_TWO;
        end
        else begin
            ns =STOP;
        end
    end
    IN_TWO:begin
        if(in_valid2) begin
            ns = IN_TWO;
        end
        else begin
            ns = PROCESS;
        end
    end
    PROCESS:begin
        if(process_flag)
        begin
            ns = OUT;
        end
        else begin
            ns = PROCESS;
        end
    end
    OUT:begin
        if(cnt_matrix_out < 6'd16) begin
            case(size_matrix)
            2'b00:begin
                if(cnt_out<6'd3) begin
                    ns = OUT;
                end
                else begin
                    ns = STOP;
                end
            end
            2'b01:begin
                if(cnt_out<6'd7) begin
                    ns = OUT;
                end
                else begin
                    ns = STOP;
                end
            end
            2'b10:begin
                if(cnt_out<6'd15) begin
                    ns = OUT;
                end
                else begin
                    ns = STOP;
                end
            end
            2'b11:begin
                if(cnt_out<6'd31) begin
                    ns = OUT;
                end
                else begin
                    ns = STOP;
                end
            end
            endcase
        end
        else begin
            ns = IDLE;
        end
    end
    default:begin
        ns = IDLE;
    end
    endcase
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        for(i=0;i<256;i=i+1) begin 
            w_data[i]<=16'd0;
        end
    end
    else if(ns == IDLE) begin 
        for(i=0;i<256;i=i+1)  begin
            w_data[i]<=16'd0;
        end
    end
    else if(ns == STOP) begin
         for(i=0;i<256;i=i+1) begin 
            w_data[i]<=16'd0;
         end
    end
    else if( ns == PROCESS)
    begin
        w_data[mem_idx_w]<=z_q[w_idx + 5'd16];
    end
end    
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) for(i=0;i<256;i=i+1) x_data[i]<=16'd0;
    else if(ns == IDLE) for(i=0;i<256;i=i+1) x_data[i]<=16'd0;
    else if(ns == STOP) for(i=0;i<256;i=i+1) x_data[i]<=16'd0;
    else if( ns == PROCESS)
    begin
        x_data[mem_idx_x]<=z_q[x_idx];
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        mem_idx_w<=9'b0;
    end
    else if(ns == IDLE)
    begin
        mem_idx_w<=9'b0;
    end
    else if(ns == PROCESS)
    begin
        mem_idx_w<=cnt_addr_w;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        mem_idx_x<=9'b0;
    end
    else if(ns == IDLE)
    begin
        mem_idx_x<=9'b0;
    end
    else if(ns == PROCESS)
    begin
        mem_idx_x<=cnt_addr ;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cnt_addr<=9'b0;
    end
    else if(ns == IDLE) cnt_addr<=9'b0;
    else if(ns == STOP) cnt_addr<=9'b0;
    else if(cs == LOAD)
    begin
        if(cnt_matrix < 6'd16)
        begin
            case(size_matrix)
            2'b00:begin
                if(cnt_addr > 9'd2) cnt_addr<=9'd0;
                else cnt_addr<= cnt_addr + 9'd1;
            end
            2'b01:begin
                if(cnt_addr > 9'd14) cnt_addr<=9'd0;
                else cnt_addr<= cnt_addr + 9'd1;
            end
            2'b10:begin
                if(cnt_addr > 9'd62) cnt_addr<=9'd0;
                else cnt_addr<= cnt_addr + 9'd1;
            end
            2'b11:begin
                if(cnt_addr > 9'd254) cnt_addr<=9'd0;
                else cnt_addr<= cnt_addr + 9'd1;
            end
            default:cnt_addr<= cnt_addr;
            endcase
        end
        else cnt_addr<=9'd0;
    end
    else if(ns == PROCESS)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_addr > 9'd2) cnt_addr<=9'd0;
            else cnt_addr<= cnt_addr + 9'd1;
        end
        2'b01:begin
            if(cnt_addr > 9'd14) cnt_addr<=9'd0;
            else cnt_addr<= cnt_addr + 9'd1;
        end
        2'b10:begin
            if(cnt_addr > 9'd62) cnt_addr<=9'd0;
            else cnt_addr<= cnt_addr + 9'd1;
        end
        2'b11:begin
            if(cnt_addr > 9'd254) cnt_addr<=9'd0;
            else cnt_addr<= cnt_addr + 9'd1;
        end
        default:cnt_addr<= cnt_addr;
        endcase
    end
    else  cnt_addr<= cnt_addr;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cnt_addr_w<=9'b0;
    end
    else if(ns == IDLE) cnt_addr_w<=9'b0;
    else if(ns == STOP) cnt_addr_w<=9'b0;
    else if(cs == LOAD)
    begin
        if(cnt_matrix < 6'd32)
        begin
            case(size_matrix)
            2'b00:begin
                if(cnt_addr_w > 9'd2) cnt_addr_w<=9'd0;
                else cnt_addr_w<= cnt_addr_w + 9'd1;
            end
            2'b01:begin
                if(cnt_addr_w > 9'd14) cnt_addr_w<=9'd0;
                else cnt_addr_w<= cnt_addr_w + 9'd1;
            end
            2'b10:begin
                if(cnt_addr_w > 9'd62) cnt_addr_w<=9'd0;
                else cnt_addr_w<= cnt_addr_w + 9'd1;
            end
            2'b11:begin
                if(cnt_addr_w > 9'd254) cnt_addr_w<=9'd0;
                else cnt_addr_w<= cnt_addr_w + 9'd1;
            end
            default:cnt_addr_w<= cnt_addr_w;
            endcase
        end
        else cnt_addr_w<=9'd0;
    end
    else if(ns == PROCESS)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_addr_w > 9'd2) cnt_addr_w<=9'd0;
            else cnt_addr_w<= cnt_addr_w + 9'd1;
        end
        2'b01:begin
            if(cnt_addr_w > 9'd14) cnt_addr_w<=9'd0;
            else cnt_addr_w<= cnt_addr_w + 9'd1;
        end
        2'b10:begin
            if(cnt_addr_w > 9'd62) cnt_addr_w<=9'd0;
            else cnt_addr_w<= cnt_addr_w + 9'd1;
        end
        2'b11:begin
            if(cnt_addr_w > 9'd254) cnt_addr_w<=9'd0;
            else cnt_addr_w<= cnt_addr_w + 9'd1;
        end
        default:cnt_addr_w<= cnt_addr_w;
        endcase
    end
    else cnt_addr_w<= cnt_addr_w;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cnt_matrix<=6'd0;
    end
    else if(ns == IDLE) begin
        cnt_matrix<=6'd0;
    end
    else if(ns == LOAD)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_addr==9'd2 || cnt_addr_w==9'd2) begin
                 cnt_matrix<=cnt_matrix+6'd1;
            end
        end
        2'b01:begin
            if(cnt_addr==9'd14|| cnt_addr_w==9'd14) begin
                cnt_matrix<=cnt_matrix+6'd1;
            end
        end
        2'b10:begin
            if(cnt_addr==9'd62|| cnt_addr_w==9'd62) begin
                cnt_matrix<=cnt_matrix+6'd1;
            end
        end
        2'b11:begin
            if(cnt_addr==9'd254|| cnt_addr_w==9'd254) begin
                cnt_matrix<=cnt_matrix+6'd1;
            end
        end
        default : begin 
            cnt_matrix<=cnt_matrix;
        end
        endcase
    end
    else begin 
        cnt_matrix<=cnt_matrix;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) cnt_out<=6'd0;
    else if(ns == IDLE) cnt_out<=6'd0;
    else if(ns == STOP) cnt_out<=6'd0;
    else if(ns == OUT)
    begin
        cnt_out<=cnt_out+6'd1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) cnt_start<=6'd0;
    else if(ns == IDLE) cnt_start<=6'd0;
    else if(ns == STOP) cnt_start<=6'd0;
    else if(ns == PROCESS) cnt_start<=cnt_start+6'd1;
    else if(ns == OUT) cnt_start<=6'd0;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) cnt_size<=18'd0;
    else if(ns == IDLE) cnt_size<=18'd0;
    else if(ns != IDLE) cnt_size<=cnt_size +18'd1;
end
//write & size & data_d
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(i=0;i<32;i=i+1)
        begin
            write[i]<=1'b1;
        end
    end
    else if(ns ==IDLE)
    begin
        for(i=0;i<32;i=i+1)
        begin
            write[i]<=1'b1;
        end
    end
    else if(in_valid==1'b1)
    begin
        case(cnt_matrix)
        6'd0:write<={{31{1'b1}},1'b0};
        6'd1:write<={{30{1'b1}},1'b0,{1{1'b1}}};
        6'd2:write<={{29{1'b1}},1'b0,{2{1'b1}}};
        6'd3:write<={{28{1'b1}},1'b0,{3{1'b1}}};
        6'd4:write<={{27{1'b1}},1'b0,{4{1'b1}}};
        6'd5:write<={{26{1'b1}},1'b0,{5{1'b1}}};
        6'd6:write<={{25{1'b1}},1'b0,{6{1'b1}}};
        6'd7:write<={{24{1'b1}},1'b0,{7{1'b1}}};
        6'd8:write<={{23{1'b1}},1'b0,{8{1'b1}}};
        6'd9:write<={{22{1'b1}},1'b0,{9{1'b1}}};
        6'd10:write<={{21{1'b1}},1'b0,{10{1'b1}}};
        6'd11:write<={{20{1'b1}},1'b0,{11{1'b1}}};
        6'd12:write<={{19{1'b1}},1'b0,{12{1'b1}}};
        6'd13:write<={{18{1'b1}},1'b0,{13{1'b1}}};
        6'd14:write<={{17{1'b1}},1'b0,{14{1'b1}}};
        6'd15:write<={{16{1'b1}},1'b0,{15{1'b1}}};
        6'd16:write<={{15{1'b1}},1'b0,{16{1'b1}}};
        6'd17:write<={{14{1'b1}},1'b0,{17{1'b1}}};
        6'd18:write<={{13{1'b1}},1'b0,{18{1'b1}}};
        6'd19:write<={{12{1'b1}},1'b0,{19{1'b1}}};
        6'd20:write<={{11{1'b1}},1'b0,{20{1'b1}}};
        6'd21:write<={{10{1'b1}},1'b0,{21{1'b1}}};
        6'd22:write<={{9{1'b1}},1'b0,{22{1'b1}}};
        6'd23:write<={{8{1'b1}},1'b0,{23{1'b1}}};
        6'd24:write<={{7{1'b1}},1'b0,{24{1'b1}}};
        6'd25:write<={{6{1'b1}},1'b0,{25{1'b1}}};
        6'd26:write<={{5{1'b1}},1'b0,{26{1'b1}}};
        6'd27:write<={{4{1'b1}},1'b0,{27{1'b1}}};
        6'd28:write<={{3{1'b1}},1'b0,{28{1'b1}}};
        6'd29:write<={{2{1'b1}},1'b0,{29{1'b1}}};
        6'd30:write<={1'b1,1'b0,{30{1'b1}}};
        6'd31:write<={1'b0,{31{1'b1}}};
        endcase
    end
    else if(ns == STOP) begin
        for(i=0;i<32;i=i+1) begin 
            write[i]<=1'b1; 
        end
    end
    else begin 
        write<=write;    
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) CEN_0<=1'b1;
    else if(ns == IDLE) CEN_0<=1'b1;
    else if(ns == LOAD) CEN_0<=1'b0;
    else if(ns == IN_TWO) CEN_0<=1'b0;
    else if(ns == PROCESS) CEN_0<=1'b0;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)  begin
        size_matrix<=2'b00;
    end
    else if(cnt_size==11'd0) begin 
            if(matrix_size == 2'b00) begin
                size_matrix<=2'b00;
            end
            else if(matrix_size == 2'b01) begin
                size_matrix<=2'b01;
            end
            else if(matrix_size == 2'b10) begin
                size_matrix<=2'b10;
            end
            else if(matrix_size == 2'b11) begin
                size_matrix<=2'b11;
            end
            else begin
                size_matrix<=size_matrix;
            end
        end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) data_d <= 16'd0;
    else if(ns == IDLE) data_d<=16'd0;
    else if(ns == LOAD)
    begin
        data_d<=matrix;
    end
    else if(ns == PROCESS) data_d<=16'd0;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) x_idx<=4'd0;
    else if(ns == IDLE) x_idx<=4'd0;
    else if(ns == IN_TWO) 
    begin
        if(in_valid2)
        x_idx<=i_mat_idx;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) w_idx<=4'd0;
    else if(ns == IDLE) w_idx<=4'd0;
    else if(ns == IN_TWO) 
    begin
        if(in_valid2)
        w_idx<=w_mat_idx;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
         out_value <= 40'd0;
    end
    else if(ns == IDLE) begin
        out_value<=40'd0;
    end
    else if(ns == STOP) out_value<=40'd0;
    else if(ns == OUT)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_out==6'd0) out_value <= y_data[0];
            if(cnt_out==6'd1) out_value <= y_data[1]+y_data[2];
            if(cnt_out==6'd2) begin
                out_value <= y_data[3];
            end
        end
        2'b01:begin
            if(cnt_out==6'd0) out_value <= y_data[0];
            if(cnt_out==6'd1) out_value <= y_data[1]+y_data[4];
            if(cnt_out==6'd2) out_value <= y_data[8]+y_data[5]+y_data[2];
            if(cnt_out==6'd3) out_value <= y_data[12]+y_data[9]+y_data[6]+y_data[3];
            if(cnt_out==6'd4) out_value <= y_data[13]+y_data[10]+y_data[7];
            if(cnt_out==6'd5) out_value <= y_data[14]+y_data[11];
            if(cnt_out==6'd6) begin
                out_value <= y_data[15];
            end
        end
        2'b10:begin
            if(cnt_out==6'd0) out_value <= y_data[0];
            if(cnt_out==6'd1) out_value <= y_data[1]+y_data[8];
            if(cnt_out==6'd2) out_value <= y_data[16]+y_data[9]+y_data[2];
            if(cnt_out==6'd3) out_value <= y_data[24]+y_data[17]+y_data[10]+y_data[3];
            if(cnt_out==6'd4) out_value <= y_data[32]+y_data[25]+y_data[18]+y_data[11]+y_data[4];
            if(cnt_out==6'd5) out_value <= y_data[40]+y_data[33]+y_data[26]+y_data[19]+y_data[12]+y_data[5];
            if(cnt_out==6'd6) out_value <= y_data[48]+y_data[41]+y_data[34]+y_data[27]+y_data[20]+y_data[13]+y_data[6];
            if(cnt_out==6'd7) out_value <= y_data[56]+y_data[49]+y_data[42]+y_data[35]+y_data[28]+y_data[21]+y_data[14]+y_data[7];
            if(cnt_out==6'd8) out_value <= y_data[57]+y_data[50]+y_data[43]+y_data[36]+y_data[29]+y_data[22]+y_data[15];
            if(cnt_out==6'd9) out_value <= y_data[58]+y_data[51]+y_data[44]+y_data[37]+y_data[30]+y_data[23];
            if(cnt_out==6'd10) out_value <= y_data[59]+y_data[52]+y_data[45]+y_data[38]+y_data[31];
            if(cnt_out==6'd11) out_value <= y_data[60]+y_data[53]+y_data[46]+y_data[39];
            if(cnt_out==6'd12) out_value <= y_data[61]+y_data[54]+y_data[47];
            if(cnt_out==6'd13) out_value <= y_data[62]+y_data[55];
            if(cnt_out==6'd14) begin
                out_value <= y_data[63];
            end
        end
        2'b11:begin
            if(cnt_out==6'd0) out_value <= y_data[0];
            if(cnt_out==6'd1) out_value <= y_data[1]+y_data[16];
            if(cnt_out==6'd2) out_value <= y_data[32]+y_data[17]+y_data[2];
            if(cnt_out==6'd3) out_value <= y_data[48]+y_data[33]+y_data[18]+y_data[3];
            if(cnt_out==6'd4) out_value <= y_data[64]+y_data[49]+y_data[34]+y_data[19]+y_data[4];
            if(cnt_out==6'd5) out_value <= y_data[80]+y_data[65]+y_data[50]+y_data[35]+y_data[20]+y_data[5];
            if(cnt_out==6'd6) out_value <= y_data[96]+y_data[81]+y_data[66]+y_data[51]+y_data[36]+y_data[21]+y_data[6];
            if(cnt_out==6'd7) out_value <= y_data[112]+y_data[97]+y_data[82]+y_data[67]+y_data[52]+y_data[37]+y_data[22]+y_data[7];
            if(cnt_out==6'd8) out_value <= y_data[128]+y_data[113]+y_data[98]+y_data[83]+y_data[68]+y_data[53]+y_data[38]+y_data[23]+y_data[8];
            if(cnt_out==6'd9) out_value <= y_data[144]+y_data[129]+y_data[114]+y_data[99]+y_data[84]+y_data[69]+y_data[54]+y_data[39]+y_data[24]+y_data[9];
            if(cnt_out==6'd10) out_value <= y_data[160]+y_data[145]+y_data[130]+y_data[115]+y_data[100]+y_data[85]+y_data[70]+y_data[55]+y_data[40]+y_data[25]+y_data[10];
            if(cnt_out==6'd11) out_value <= y_data[176]+y_data[161]+y_data[146]+y_data[131]+y_data[116]+y_data[101]+y_data[86]+y_data[71]+y_data[56]+y_data[41]+y_data[26]+y_data[11];
            if(cnt_out==6'd12) out_value <= y_data[192]+y_data[177]+y_data[162]+y_data[147]+y_data[132]+y_data[117]+y_data[102]+y_data[87]+y_data[72]+y_data[57]+y_data[42]+y_data[27]+y_data[12];
            if(cnt_out==6'd13) out_value <= y_data[208]+y_data[193]+y_data[178]+y_data[163]+y_data[148]+y_data[133]+y_data[118]+y_data[103]+y_data[88]+y_data[73]+y_data[58]+y_data[43]+y_data[28]+y_data[13];
            if(cnt_out==6'd14) out_value <= y_data[224]+y_data[209]+y_data[194]+y_data[179]+y_data[164]+y_data[149]+y_data[134]+y_data[119]+y_data[104]+y_data[89]+y_data[74]+y_data[59]+y_data[44]+y_data[29]+y_data[14];
            if(cnt_out==6'd15) out_value <= y_data[240]+y_data[225]+y_data[210]+y_data[195]+y_data[180]+y_data[165]+y_data[150]+y_data[135]+y_data[120]+y_data[105]+y_data[90]+y_data[75]+y_data[60]+y_data[45]+y_data[30]+y_data[15];
            if(cnt_out==6'd16) out_value <= y_data[241]+y_data[226]+y_data[211]+y_data[196]+y_data[181]+y_data[166]+y_data[151]+y_data[136]+y_data[121]+y_data[106]+y_data[91]+y_data[76]+y_data[61]+y_data[46]+y_data[31];
            if(cnt_out==6'd17) out_value <= y_data[242]+y_data[227]+y_data[212]+y_data[197]+y_data[182]+y_data[167]+y_data[152]+y_data[137]+y_data[122]+y_data[107]+y_data[92]+y_data[77]+y_data[62]+y_data[47];
            if(cnt_out==6'd18) out_value <= y_data[243]+y_data[228]+y_data[213]+y_data[198]+y_data[183]+y_data[168]+y_data[153]+y_data[138]+y_data[123]+y_data[108]+y_data[93]+y_data[78]+y_data[63];
            if(cnt_out==6'd19) out_value <= y_data[244]+y_data[229]+y_data[214]+y_data[199]+y_data[184]+y_data[169]+y_data[154]+y_data[139]+y_data[124]+y_data[109]+y_data[94]+y_data[79];
            if(cnt_out==6'd20) out_value <= y_data[245]+y_data[230]+y_data[215]+y_data[200]+y_data[185]+y_data[170]+y_data[155]+y_data[140]+y_data[125]+y_data[110]+y_data[95];
            if(cnt_out==6'd21) out_value <= y_data[246]+y_data[231]+y_data[216]+y_data[201]+y_data[186]+y_data[171]+y_data[156]+y_data[141]+y_data[126]+y_data[111];
            if(cnt_out==6'd22) out_value <= y_data[247]+y_data[232]+y_data[217]+y_data[202]+y_data[187]+y_data[172]+y_data[157]+y_data[142]+y_data[127];
            if(cnt_out==6'd23) out_value <= y_data[248]+y_data[233]+y_data[218]+y_data[203]+y_data[188]+y_data[173]+y_data[158]+y_data[143];
            if(cnt_out==6'd24) out_value <= y_data[249]+y_data[234]+y_data[219]+y_data[204]+y_data[189]+y_data[174]+y_data[159];
            if(cnt_out==6'd25) out_value <= y_data[250]+y_data[235]+y_data[220]+y_data[205]+y_data[190]+y_data[175];
            if(cnt_out==6'd26) out_value <= y_data[251]+y_data[236]+y_data[221]+y_data[206]+y_data[191];
            if(cnt_out==6'd27) out_value <= y_data[252]+y_data[237]+y_data[222]+y_data[207];
            if(cnt_out==6'd28) out_value <= y_data[253]+y_data[238]+y_data[223];
            if(cnt_out==6'd29) out_value <= y_data[254]+y_data[239];
            if(cnt_out==6'd30) begin
                out_value <= y_data[255];
            end
        end
        endcase
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
         cnt_matrix_out<= 6'd0;
    end
    else if(ns == IDLE) begin
        cnt_matrix_out<= 6'd0;
    end
    else if(ns == OUT)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_out==6'd2) begin
                cnt_matrix_out<=cnt_matrix_out+6'd1;
            end
        end
        2'b01:begin
            if(cnt_out==6'd6) begin
                cnt_matrix_out<=cnt_matrix_out+6'd1;
            end
        end
        2'b10:begin
            if(cnt_out==6'd14) begin
                cnt_matrix_out<=cnt_matrix_out+6'd1;
            end
        end
        2'b11:begin
            if(cnt_out==6'd30) begin
                cnt_matrix_out<=cnt_matrix_out+6'd1;
            end
        end
        default:cnt_matrix_out<=cnt_matrix_out;
        endcase
    end
    else cnt_matrix_out<=cnt_matrix_out;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) out_valid <= 1'b0;
    else if(ns == IDLE) out_valid <=1'b0;
    else if(ns == STOP) out_valid <=1'b0;
    else if(ns == PROCESS) out_valid <=1'b0;
    else if(ns == OUT) out_valid <=1'b1;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) process_flag <= 1'b0;
    else if(ns == IDLE) process_flag <=1'b0;
    else if(ns == IN_TWO) process_flag <=1'b0;
    else if(ns == PROCESS)
    begin
        case(size_matrix)
        2'b00:if(cnt_start==9) process_flag<=1'b1;
        2'b01:if(cnt_start==34) process_flag<=1'b1;
        2'b10:if(cnt_start==129) process_flag<=1'b1;
        2'b11:if(cnt_start==513) process_flag<=1'b1;
        endcase
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        for(i=0;i<256;i=i+1) y_data[i]<=40'd0;
    end
    else if(ns == IDLE) begin
         for(i=0;i<256;i=i+1) y_data[i]<=40'd0;
    end
    else if(ns == PROCESS)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_start==6)  y_data[0]<=z_ans2; 
            else if(cnt_start==7)  y_data[1]<=z_ans2; 
            else if(cnt_start==8)  y_data[2]<=z_ans2; 
            else if(cnt_start==9)  y_data[3]<=z_ans2;
        end
        2'b01:begin
            if(cnt_start==18)  y_data[0]<=z_ans4; 
            else if(cnt_start==19)  y_data[1]<=z_ans4; 
            else if(cnt_start==20)  y_data[2]<=z_ans4; 
            else if(cnt_start==21)  y_data[3]<=z_ans4; 
            else if(cnt_start==22)  y_data[4]<=z_ans4; 
            else if(cnt_start==23)  y_data[5]<=z_ans4;
            else if(cnt_start==24)  y_data[6]<=z_ans4;
            else if(cnt_start==25)  y_data[7]<=z_ans4;
            else if(cnt_start==26)  y_data[8]<=z_ans4;
            else if(cnt_start==27)  y_data[9]<=z_ans4;
            else if(cnt_start==28)  y_data[10]<=z_ans4;
            else if(cnt_start==29)  y_data[11]<=z_ans4;
            else if(cnt_start==30)  y_data[12]<=z_ans4;
            else if(cnt_start==31)  y_data[13]<=z_ans4;
            else if(cnt_start==32)  y_data[14]<=z_ans4;
            else if(cnt_start==33)  y_data[15]<=z_ans4;
        end
        2'b10:begin
            if(cnt_start==66)  y_data[0]<=z_ans8; 
            else if(cnt_start==67)  y_data[1]<=z_ans8; 
            else if(cnt_start==68)  y_data[2]<=z_ans8; 
            else if(cnt_start==69)  y_data[3]<=z_ans8; 
            else if(cnt_start==70)  y_data[4]<=z_ans8; 
            else if(cnt_start==71)  y_data[5]<=z_ans8;
            else if(cnt_start==72)  y_data[6]<=z_ans8; 
            else if(cnt_start==73)  y_data[7]<=z_ans8; 
            else if(cnt_start==74)  y_data[8]<=z_ans8; 
            else if(cnt_start==75)  y_data[9]<=z_ans8; 
            else if(cnt_start==76)  y_data[10]<=z_ans8; 
            else if(cnt_start==77)  y_data[11]<=z_ans8;
            else if(cnt_start==78)  y_data[12]<=z_ans8; 
            else if(cnt_start==79)  y_data[13]<=z_ans8; 
            else if(cnt_start==80)  y_data[14]<=z_ans8; 
            else if(cnt_start==81)  y_data[15]<=z_ans8; 
            else if(cnt_start==82)  y_data[16]<=z_ans8; 
            else if(cnt_start==83)  y_data[17]<=z_ans8;
            else if(cnt_start==84)  y_data[18]<=z_ans8; 
            else if(cnt_start==85)  y_data[19]<=z_ans8; 
            else if(cnt_start==86)  y_data[20]<=z_ans8; 
            else if(cnt_start==87)  y_data[21]<=z_ans8; 
            else if(cnt_start==88)  y_data[22]<=z_ans8; 
            else if(cnt_start==89)  y_data[23]<=z_ans8;
            else if(cnt_start==90)  y_data[24]<=z_ans8; 
            else if(cnt_start==91)  y_data[25]<=z_ans8; 
            else if(cnt_start==92)  y_data[26]<=z_ans8; 
            else if(cnt_start==93)  y_data[27]<=z_ans8; 
            else if(cnt_start==94)  y_data[28]<=z_ans8; 
            else if(cnt_start==95)  y_data[29]<=z_ans8;
            else if(cnt_start==96)  y_data[30]<=z_ans8; 
            else if(cnt_start==97)  y_data[31]<=z_ans8; 
            else if(cnt_start==98)  y_data[32]<=z_ans8; 
            else if(cnt_start==99)  y_data[33]<=z_ans8; 
            else if(cnt_start==100)  y_data[34]<=z_ans8; 
            else if(cnt_start==101)  y_data[35]<=z_ans8; 
            else if(cnt_start==102)  y_data[36]<=z_ans8; 
            else if(cnt_start==103)  y_data[37]<=z_ans8; 
            else if(cnt_start==104)  y_data[38]<=z_ans8; 
            else if(cnt_start==105)  y_data[39]<=z_ans8; 
            else if(cnt_start==106)  y_data[40]<=z_ans8; 
            else if(cnt_start==107)  y_data[41]<=z_ans8; 
            else if(cnt_start==108)  y_data[42]<=z_ans8; 
            else if(cnt_start==109)  y_data[43]<=z_ans8; 
            else if(cnt_start==110)  y_data[44]<=z_ans8; 
            else if(cnt_start==111)  y_data[45]<=z_ans8; 
            else if(cnt_start==112)  y_data[46]<=z_ans8; 
            else if(cnt_start==113)  y_data[47]<=z_ans8; 
            else if(cnt_start==114)  y_data[48]<=z_ans8; 
            else if(cnt_start==115)  y_data[49]<=z_ans8; 
            else if(cnt_start==116)  y_data[50]<=z_ans8;
            else if(cnt_start==117)  y_data[51]<=z_ans8;  
            else if(cnt_start==118)  y_data[52]<=z_ans8; 
            else if(cnt_start==119)  y_data[53]<=z_ans8; 
            else if(cnt_start==120)  y_data[54]<=z_ans8; 
            else if(cnt_start==121)  y_data[55]<=z_ans8; 
            else if(cnt_start==122)  y_data[56]<=z_ans8; 
            else if(cnt_start==123)  y_data[57]<=z_ans8; 
            else if(cnt_start==124)  y_data[58]<=z_ans8; 
            else if(cnt_start==125)  y_data[59]<=z_ans8; 
            else if(cnt_start==126)  y_data[60]<=z_ans8; 
            else if(cnt_start==127)  y_data[61]<=z_ans8;
            else if(cnt_start==128)  y_data[62]<=z_ans8; 
            else if(cnt_start==129)  y_data[63]<=z_ans8; 
        end
        2'b11:begin
            for( i=0;i<256;i=i+1)
            begin
                if(cnt_start==258+i) y_data[i]<=z_ans16;
            end
        end
        endcase
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        for(i=0;i<2;i=i+1)
        begin
            mult2_w[i]<=16'd0;
            mult2_x[i]<=16'd0;
        end
        for(i=0;i<4;i=i+1)
        begin
            mult4_w[i]<=16'd0;
            mult4_x[i]<=16'd0;
        end
        for(i=0;i<8;i=i+1)
        begin
            mult8_w[i]<=16'd0;
            mult8_x[i]<=16'd0;
        end
        for(i=0;i<16;i=i+1)
        begin
            mult16_w[i]<=16'd0;
            mult16_x[i]<=16'd0;
        end
    end
    else if(ns == IDLE) begin
         for(i=0;i<2;i=i+1)
        begin
            mult2_w[i]<=16'd0;
            mult2_x[i]<=16'd0;
        end
        for(i=0;i<4;i=i+1)
        begin
            mult4_w[i]<=16'd0;
            mult4_x[i]<=16'd0;
        end
        for(i=0;i<8;i=i+1)
        begin
            mult8_w[i]<=16'd0;
            mult8_x[i]<=16'd0;
        end
        for(i=0;i<16;i=i+1)
        begin
            mult16_w[i]<=16'd0;
            mult16_x[i]<=16'd0;
        end
    end
    else if(ns == PROCESS)
    begin
        case(size_matrix)
        2'b00:begin
            if(cnt_start== 5)
            begin
                    for(i=0;i<2;i=i+1)
                    begin
                        mult2_w[i]<=w_data[i*2];
                        mult2_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 6)
            begin
                    for(i=0;i<2;i=i+1)
                    begin
                        mult2_w[i]<=w_data[i*2+1];
                        mult2_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 7)
            begin
                    for(i=0;i<2;i=i+1)
                    begin
                        mult2_w[i]<=w_data[i*2];
                        mult2_x[i]<=x_data[i+2];
                    end
            end
            else if(cnt_start== 8)
            begin
                    for(i=0;i<2;i=i+1)
                    begin
                        mult2_w[i]<=w_data[i*2+1];
                        mult2_x[i]<=x_data[i+2];
                    end
            end
        end
        2'b01:begin
                if(cnt_start == 17)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4];
                        mult4_x[i]<=x_data[i];
                    end
                end
                else if(cnt_start == 18)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+1];
                        mult4_x[i]<=x_data[i];
                    end
                end
                else if(cnt_start == 19)
                begin
                   for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+2];
                        mult4_x[i]<=x_data[i];
                    end
                end
                else if(cnt_start == 20)
                begin
                   for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+3];
                        mult4_x[i]<=x_data[i];
                    end
                end
                else if(cnt_start == 21)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4];
                        mult4_x[i]<=x_data[i+4];
                    end
                end
                else if(cnt_start == 22)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+1];
                        mult4_x[i]<=x_data[i+4];
                    end
                end
                else if(cnt_start == 23)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+2];
                        mult4_x[i]<=x_data[i+4];
                    end
                end
                else if(cnt_start == 24)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+3];
                        mult4_x[i]<=x_data[i+4];
                    end
                end
                else if(cnt_start == 25)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4];
                        mult4_x[i]<=x_data[i+8];
                    end
                end
                else if(cnt_start == 26)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+1];
                        mult4_x[i]<=x_data[i+8];
                    end
                end
                else if(cnt_start == 27)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+2];
                        mult4_x[i]<=x_data[i+8];
                    end
                end
                else if(cnt_start == 28)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+3];
                        mult4_x[i]<=x_data[i+8];
                    end
                end
                else if(cnt_start == 29)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4];
                        mult4_x[i]<=x_data[i+12];
                    end
                end
                else if(cnt_start == 30)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+1];
                        mult4_x[i]<=x_data[i+12];
                    end
                end
                else if(cnt_start == 31)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+2];
                        mult4_x[i]<=x_data[i+12];
                    end
                end
                else if(cnt_start == 32)
                begin
                    for(i=0;i<4;i=i+1)
                    begin
                        mult4_w[i]<=w_data[i*4+3];
                        mult4_x[i]<=x_data[i+12];
                    end
                end
        end
        2'b10:begin
            if(cnt_start == 65)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 66)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 67)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 68)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 69)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 70)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 71)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 72)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i];
                end
            end
            else if(cnt_start == 73)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 74)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 75)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 76)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 77)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 78)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 79)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 80)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+8];
                end
            end
            else if(cnt_start == 81)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 82)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 83)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 84)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 85)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 86)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 87)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 88)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+16];
                end
            end
            else if(cnt_start == 89)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 90)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 91)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 92)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 93)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 94)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 95)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 96)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+24];
                end
            end
            else if(cnt_start == 97)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 98)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 99)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 100)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 101)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 102)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 103)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 104)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+32];
                end
            end
            else if(cnt_start == 105)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 106)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 107)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 108)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 109)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 110)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 111)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 112)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+40];
                end
            end
            else if(cnt_start == 113)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 114)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 115)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 116)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 117)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 118)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 119)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 120)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+48];
                end
            end
            else if(cnt_start == 121)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 122)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+1];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 123)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+2];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 124)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+3];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 125)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+4];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 126)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+5];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 127)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+6];
                    mult8_x[i]<=x_data[i+56];
                end
            end
            else if(cnt_start == 128)
            begin
                for(i=0;i<8;i=i+1)
                begin
                    mult8_w[i]<=w_data[i*8+7];
                    mult8_x[i]<=x_data[i+56];
                end
            end
        end
        2'b11:begin
            if(cnt_start== 257)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 258)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 259)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 260)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 261)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 262)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 263)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 264)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 265)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 266)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 267)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 268)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 269)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 270)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 271)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 272)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i];
                    end
            end
            else if(cnt_start== 273)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 274)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 275)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 276)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 277)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 278)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 279)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 280)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 281)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 282)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 283)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 284)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 285)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 286)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 287)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 288)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+16];
                    end
            end
            else if(cnt_start== 289)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 290)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 291)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 292)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 293)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 294)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 295)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 296)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 297)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 298)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 299)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 300)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 301)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 302)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 303)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 304)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+32];
                    end
            end
            else if(cnt_start== 305)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 306)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 307)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 308)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 309)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 310)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 311)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 312)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 313)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 314)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 315)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 316)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 317)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 318)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 319)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 320)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+48];
                    end
            end
            else if(cnt_start== 321)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 322)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 323)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 324)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 325)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 326)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 327)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 328)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 329)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 330)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 331)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 332)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 333)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 334)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 335)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 336)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+64];
                    end
            end
            else if(cnt_start== 337)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 338)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 339)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 340)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 341)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 342)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 343)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 344)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 345)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 346)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 347)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 348)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 349)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 350)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 351)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 352)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+80];
                    end
            end
            else if(cnt_start== 353)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 354)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 355)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 356)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 357)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 358)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 359)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 360)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 361)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 362)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 363)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 364)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 365)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 366)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 367)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 368)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+96];
                    end
            end
            else if(cnt_start== 369)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 370)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 371)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 372)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 373)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 374)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 375)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 376)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 377)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 378)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 379)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 380)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 381)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 382)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 383)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 384)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+112];
                    end
            end
            else if(cnt_start== 385)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 386)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 387)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 388)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 389)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 390)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 391)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 392)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 393)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 394)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 395)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 396)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 397)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 398)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 399)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 400)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+128];
                    end
            end
            else if(cnt_start== 401)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 402)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 403)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 404)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 405)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 406)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 407)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 408)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 409)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 410)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 411)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 412)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 413)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 414)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 415)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 416)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+144];
                    end
            end
            else if(cnt_start== 417)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 418)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 419)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 420)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 421)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 422)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 423)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 424)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 425)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 426)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 427)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 428)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 429)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 430)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 431)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 432)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+160];
                    end
            end
            else if(cnt_start== 433)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 434)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 435)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 436)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 437)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 438)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 439)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 440)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 441)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 442)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 443)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 444)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 445)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 446)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 447)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 448)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+176];
                    end
            end
            else if(cnt_start== 449)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 450)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 451)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 452)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 453)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 454)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 455)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 456)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 457)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 458)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 459)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 460)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 461)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 462)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 463)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 464)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+192];
                    end
            end
            else if(cnt_start== 465)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 466)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 467)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 468)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 469)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 470)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 471)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 472)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 473)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 474)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 475)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 476)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 477)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 478)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 479)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 480)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+208];
                    end
            end
            else if(cnt_start== 481)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 482)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 483)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 484)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 485)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 486)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 487)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 488)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 489)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 490)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 491)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 492)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 493)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 494)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 495)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 496)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+224];
                    end
            end
            else if(cnt_start== 497)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 498)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+1];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 499)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+2];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 500)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+3];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 501)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+4];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 502)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+5];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 503)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+6];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 504)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+7];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 505)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+8];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 506)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+9];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 507)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+10];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 508)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+11];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 509)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+12];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 510)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+13];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 511)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+14];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
            else if(cnt_start== 512)
            begin
                    for(i=0;i<16;i=i+1)
                    begin
                        mult16_w[i]<=w_data[i*16+15];
                        mult16_x[i]<=x_data[i+240];
                    end
            end
        end
        endcase
    end
end
assign z_ans2=mult2_x[0]*mult2_w[0]+mult2_x[1]*mult2_w[1];
assign z_ans4=mult4_x[0]*mult4_w[0]+mult4_x[1]*mult4_w[1]+mult4_x[2]*mult4_w[2]+mult4_x[3]*mult4_w[3];
assign z_ans8=mult8_x[0]*mult8_w[0]+mult8_x[1]*mult8_w[1]+mult8_x[2]*mult8_w[2]+mult8_x[3]*mult8_w[3]
                +mult8_x[4]*mult8_w[4]+mult8_x[5]*mult8_w[5]+mult8_x[6]*mult8_w[6]+mult8_x[7]*mult8_w[7];

assign z_ans16=mult16_x[0]*mult16_w[0]+mult16_x[1]*mult16_w[1]+mult16_x[2]*mult16_w[2]+mult16_x[3]*mult16_w[3]
                +mult16_x[4]*mult16_w[4]+mult16_x[5]*mult16_w[5]+mult16_x[6]*mult16_w[6]+mult16_x[7]*mult16_w[7]
                +mult16_x[8]*mult16_w[8]+mult16_x[9]*mult16_w[9]+mult16_x[10]*mult16_w[10]+mult16_x[11]*mult16_w[11]
                +mult16_x[12]*mult16_w[12]+mult16_x[13]*mult16_w[13]+mult16_x[14]*mult16_w[14]+mult16_x[15]*mult16_w[15];
endmodule
