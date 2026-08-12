# Voting Machine

A digital **Voting Machine** designed using **Verilog HDL** and verified through simulation.

## Project Overview

This project implements a simple digital voting machine that allows users to cast votes for different candidates. The system counts the votes received by each candidate and provides the corresponding vote count.

The design was developed using **Verilog HDL** and its functionality was verified using a simulation testbench.

##  Working

The voting machine accepts candidate selection inputs and registers a vote when a valid voting condition occurs.

* A candidate is selected using the corresponding input.
* When a valid vote is cast, the selected candidate's vote count is incremented.
* The vote counters maintain the total number of votes received by each candidate.
* Reset initializes all vote counts to zero.

The design can be extended to support additional candidates and result-display logic.

## Tools & Technologies

* Verilog HDL
* ModelSim / Vivado Simulator
* RTL Design
* Digital Counters
* Sequential Logic

##  Project Files

* voting_machine.v – Main Verilog design
* voting_machine_tb.v – Verilog testbench
* voting_machine_simulation.png-Simualtion waveform

##  Simulation

The design was simulated using a Verilog simulation environment to verify:

* Correct candidate selection
* Proper vote registration
* Accurate vote counting
* Reset operation
* Sequential behavior of the voting system

##  Expected Output

During simulation, whenever a valid vote is cast for a candidate, the corresponding vote counter is incremented.

For example:

**Candidate 1 → Vote Count increases by 1**

**Candidate 2 → Vote Count increases by 1**

**Candidate 3 → Vote Count increases by 1**

The waveform is used to verify that the vote counts change correctly for each valid voting input.

##  Author

**Voo Upasana**


