module votingMachine(
    input clock,
    input reset,
    input mode,
    input button1,
    input button2,
    input button3,
    input button4,
    output [7:0] led
);

wire valid_vote_1;
wire valid_vote_2;
wire valid_vote_3;
wire valid_vote_4;

wire [7:0] cand1_vote_recvd;
wire [7:0] cand2_vote_recvd;
wire [7:0] cand3_vote_recvd;
wire [7:0] cand4_vote_recvd;

wire anyValidVote;

assign anyValidVote =
            valid_vote_1 |
            valid_vote_2 |
            valid_vote_3 |
            valid_vote_4;

// Button Controllers
buttonControl BC1(
    .clock(clock),
    .reset(reset),
    .button(button1),
    .valid_vote(valid_vote_1)
);

buttonControl BC2(
    .clock(clock),
    .reset(reset),
    .button(button2),
    .valid_vote(valid_vote_2)
);

buttonControl BC3(
    .clock(clock),
    .reset(reset),
    .button(button3),
    .valid_vote(valid_vote_3)
);

buttonControl BC4(
    .clock(clock),
    .reset(reset),
    .button(button4),
    .valid_vote(valid_vote_4)
);

// Vote Counter
voteLogger VL(
    .clock(clock),
    .reset(reset),
    .mode(mode),

    .cand1_vote_valid(valid_vote_1),
    .cand2_vote_valid(valid_vote_2),
    .cand3_vote_valid(valid_vote_3),
    .cand4_vote_valid(valid_vote_4),

    .cand1_vote_recvd(cand1_vote_recvd),
    .cand2_vote_recvd(cand2_vote_recvd),
    .cand3_vote_recvd(cand3_vote_recvd),
    .cand4_vote_recvd(cand4_vote_recvd)
);

// LED Controller
modeControl MC(
    .clock(clock),
    .reset(reset),
    .mode(mode),
    .valid_vote_casted(anyValidVote),

    .candidate1_vote(cand1_vote_recvd),
    .candidate2_vote(cand2_vote_recvd),
    .candidate3_vote(cand3_vote_recvd),
    .candidate4_vote(cand4_vote_recvd),

    .candidate1_button_press(valid_vote_1),
    .candidate2_button_press(valid_vote_2),
    .candidate3_button_press(valid_vote_3),
    .candidate4_button_press(valid_vote_4),

    .leds(led)
);

endmodule


//========================
// Button Control Module
//========================
module buttonControl(
    input clock,
    input reset,
    input button,
    output reg valid_vote
);

reg [3:0] counter;

always @(posedge clock) begin
    if (reset) begin
        counter <= 0;
        valid_vote <= 0;
    end
    else begin
        if (button) begin
            if (counter < 10)
                counter <= counter + 1;
        end
        else
            counter <= 0;

        if (counter == 9)
            valid_vote <= 1'b1;
        else
            valid_vote <= 1'b0;
    end
end

endmodule


//========================
// Vote Logger Module
//========================
module voteLogger(
    input clock,
    input reset,
    input mode,

    input cand1_vote_valid,
    input cand2_vote_valid,
    input cand3_vote_valid,
    input cand4_vote_valid,

    output reg [7:0] cand1_vote_recvd,
    output reg [7:0] cand2_vote_recvd,
    output reg [7:0] cand3_vote_recvd,
    output reg [7:0] cand4_vote_recvd
);

always @(posedge clock) begin
    if (reset) begin
        cand1_vote_recvd <= 0;
        cand2_vote_recvd <= 0;
        cand3_vote_recvd <= 0;
        cand4_vote_recvd <= 0;
    end
    else if (!mode) begin
        if (cand1_vote_valid)
            cand1_vote_recvd <= cand1_vote_recvd + 1;

        if (cand2_vote_valid)
            cand2_vote_recvd <= cand2_vote_recvd + 1;

        if (cand3_vote_valid)
            cand3_vote_recvd <= cand3_vote_recvd + 1;

        if (cand4_vote_valid)
            cand4_vote_recvd <= cand4_vote_recvd + 1;
    end
end

endmodule


//========================
// Mode Control Module
//========================
module modeControl(
    input clock,
    input reset,
    input mode,
    input valid_vote_casted,

    input [7:0] candidate1_vote,
    input [7:0] candidate2_vote,
    input [7:0] candidate3_vote,
    input [7:0] candidate4_vote,

    input candidate1_button_press,
    input candidate2_button_press,
    input candidate3_button_press,
    input candidate4_button_press,

    output reg [7:0] leds
);

reg [3:0] counter;

always @(posedge clock) begin
    if (reset)
        counter <= 0;

    else if (valid_vote_casted)
        counter <= 10;

    else if (counter > 0)
        counter <= counter - 1;
end

always @(posedge clock) begin
    if (reset)
        leds <= 8'h00;

    else begin

        // Voting Mode
        if (!mode) begin
            if (counter > 0)
                leds <= 8'hFF;
            else
                leds <= 8'h00;
        end

        // Result Mode
        else begin
            if (candidate1_button_press)
                leds <= candidate1_vote;
            else if (candidate2_button_press)
                leds <= candidate2_vote;
            else if (candidate3_button_press)
                leds <= candidate3_vote;
            else if (candidate4_button_press)
                leds <= candidate4_vote;
            else
                leds <= 8'h00;
        end

    end
end

endmodule
