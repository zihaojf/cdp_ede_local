module tb;
reg        clk   ;
reg        resetn;     
reg [3 :0] switch;    //input

initial
begin
    #100;
    clk    = 1'b0;
    resetn = 1'b0;

    #500;
    resetn = 1'b1;
end
always #5 clk = ~clk;

//set switch
initial
begin
    #100;
    switch = 4'h0;
    #500;
    #1;
    switch = 4'h7;  //switch: 7
    #100;
    switch = 4'h6;  //switch: 6
    #100;
    switch = 4'h1;  //switch: 1
    #100;
    switch = 4'hd;  //switch: d
    #100;
    switch = 4'hf;  //switch: f
end

show_sw  u_show_sw(
    .clk    (clk    ),          
    .resetn (resetn ),     

    .switch (switch ),    //input

    .num_csn(),   //new value   
    .num_a_g(),      

    .led    ()    //previous value
);
endmodule
