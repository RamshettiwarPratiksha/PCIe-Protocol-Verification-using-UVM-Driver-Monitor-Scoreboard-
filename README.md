# PCIe Protocol Verification using UVM (Driver, Monitor, Scoreboard)

Designed and implemented a modular UVM testbench simulating PCIe-like TLP flow with dual agents (RC/EP), PIPE interface, LTSSM link training, and analysis-port-driven scoreboard for transaction-level checking and protocol validation.





PCIe-like UVM Testbench with TLP Flow, LTSSM, and Scoreboard

&#x20;📌 Overview



This project implements a \*\*UVM-based verification environment\*\* for a PCIe-like Transaction Layer Packet (TLP) flow between a Root Complex (RC) and Endpoint (EP).



The testbench models a simplified PIPE interface, performs \*\*link training using LTSSM\*\*, and validates end-to-end data integrity using a \*\*scoreboard with analysis ports\*\*.



&#x20;🧱 Architecture

Sequence → Driver (RC) → PIPE Interface → Monitor (EP) → Scoreboard



RC Agent (Active)

&#x20; Generates and drives TLP transactions



EP Agent (Passive)

&#x20; Monitors and reconstructs incoming TLPs



Scoreboard

&#x20; Compares expected vs actual transactions



🚀 Features



\* UVM-based modular architecture

\* Dual-agent design (RC + EP)

\* PIPE-like interface abstraction

\* LTSSM link training:

&#x20;DETECT → POLLING → CONFIG → L0

\* Transaction-level modeling (TLPs)

\* Analysis port based communication

\* FIFO-based scoreboard

\* Field-by-field validation:



&#x20; \* Tag

&#x20; \* Length

&#x20; \* Address

&#x20; \* Data

🔁 Data Flow



1\. Sequence generates TLP transactions

2\. RC Driver sends packets via PIPE interface

3\. EP Monitor captures and reconstructs packets

4\. Scoreboard compares:



&#x20;  \* Expected (from driver)

&#x20;  \* Actual (from monitor)



TLM Communication



\* `uvm\_analysis\_port`

\* `uvm\_analysis\_imp`

\* Decoupled data flow using `write()` callbacks



Scoreboard Design



\* Queue-based (FIFO) matching

\* Field-wise comparison

\* Debug-friendly logging (`uvm\_info`, `uvm\_error`)



📂 File Structure

├── tlm\_tx.sv              # Transaction (TLP)

├── tlm\_seq.sv             # Sequences

├── tlm\_sqr.sv             # Sequencer

├── tlm\_rc\_driver.sv       # RC Driver

├── tlm\_ep\_monitor.sv      # EP Monitor

├── tlm\_agent.sv           # Agent (RC + EP)

├── tlm\_env.sv             # Environment

├── tlm\_scoreboard.sv      # Scoreboard

├── tlm\_interface.sv       # PIPE Interface + LTSSM

├── tlm\_test.sv            # Test

├── top.sv                 # Top module



&#x20;🔍 Debug Highlights



\* LTSSM training handled in driver using TS1/TS2 sequences

\* Monitor detects STP/END markers to reconstruct TLP

\* Scoreboard logs both expected and actual transactions

\* Detailed mismatch reporting for quick debug



⚠️ Limitations



\* Supports only \*\*MEM\_WR (ordered transactions)\*\*

\* Scoreboard uses FIFO (no out-of-order handling)



\## 🚀 Future Work



\* Add MEM\_RD and Completion (CPL) flow

\* Implement tag-based (associative array) scoreboard

\* Add functional coverage

\* Error injection and corner-case testing

\* Multi-lane / speed scaling support

