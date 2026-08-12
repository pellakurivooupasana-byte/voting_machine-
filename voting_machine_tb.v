module test;

    reg clock;
    reg reset;
    reg mode;
    reg button1, button2, button3, button4;

    wire [7:0] led;

    votingMachine dut (
        .clock(clock),
        .reset(reset),
        .mode(mode),
        .button1(button1),
        .button2(button2),
        .button3(button3),
        .button4(button4),
        .led(led)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Stimulus
    initial begin

        // Initial values
        reset   = 1;
        mode    = 0;
        button1 = 0;
        button2 = 0;
        button3 = 0;
        button4 = 0;

        #100;
        reset = 0;

        // Candidate-1 Vote
        button1 = 1;
        #200;
        button1 = 0;
        #20;

        // Candidate-2 Vote
        button2 = 1;
        #200;
        button2 = 0;
        #20;

        // Candidate-2 and Candidate-3 Vote Together
        button2 = 1;
        button3 = 1;
        #200;
        button2 = 0;
        button3 = 0;
        #20;

        // Result Mode
        mode = 1;
        button2 = 1;
        #200;
        button2 = 0;
        #20;

        // Back to Voting Mode
        mode = 0;

        // Candidate-3 Vote
        button3 = 1;
        #200;
        button3 = 0;
        #20;

        #100;
        $finish;

    end

endmodule
