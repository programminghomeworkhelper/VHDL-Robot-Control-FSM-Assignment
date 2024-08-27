`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2024 10:08:32 AM
// Design Name:
// Module Name: my_tb_debug
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module my_tb_debug;

    reg CLK; //clock
    reg [1:0] ONOFF; // on/off
    reg [7:0] LCN_0; //starting location
    reg [3:0] MTN_SENSOR; //maintenance sensor
    reg [3:0] CMPS; //compass
    reg [3:0] WLL; //wall locations
    
    wire [1:0] TURN;
    wire       DRIVING;
    wire [7:0] LOCATION;
    wire [2:0] ACTION;
    
    // Clock generation
    initial begin
        CLK = 0;
        forever #2 CLK = ~CLK; // 250 MHz
    end
    
    pipeFSM inst0(
        CLK,
        ONOFF,
        LCN_0,
        MTN_SENSOR,
        CMPS,
        WLL,
        TURN,
        DRIVING,
        LOCATION,
        ACTION
    );

    initial begin

    // initialize the inputs

    ONOFF      = 2'b00;
    LCN_0      = 8'b0;
    MTN_SENSOR = 4'b0;
    CMPS       = 4'b0;
    WLL        = 3'b0;

    #50

    // start the robot
    ONOFF = 2'b01;
    LCN_0  =  8'b0110_0000;
    MTN_SENSOR = 4'b0000;
    CMPS = 4'b0000;
    WLL = 3'b000;

    //1
    #10 
    ONOFF = 2'b00;

    #40
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //2
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0100;
    CMPS = 4'b1000;
    WLL = 3'b011;

    //3
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b0001;
    WLL = 3'b101;

    //4
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b1000;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //5
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b1000;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //6
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //7
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0010;
    CMPS = 4'b1000;
    WLL = 3'b011;

    //8
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0010;
    CMPS = 4'b0001;
    WLL = 3'b110;

    //9
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0010;
    CMPS = 4'b0001;
    WLL = 3'b011;

    //10
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0100;
    CMPS = 4'b0010;
    WLL = 3'b101;

    //11
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b0001;
    WLL = 3'b110;

    //12
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b1000;
    CMPS = 4'b0001;
    WLL = 3'b101;

    //13
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //14
    #10
    WLL = 3'b000;

    #40
    MTN_SENSOR = 4'b0100;
    CMPS = 4'b1000;
    WLL = 3'b110;

    //15 the end
    #10
    WLL = 3'b000;

    #40
    ONOFF = 2'b10;
    MTN_SENSOR = 4'b0001;
    CMPS = 4'b1000;
    WLL = 3'b110;

    #10
    ONOFF = 2'b00;
    WLL = 3'b000;

    #10
    $stop;

    end


endmodule
