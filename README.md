# MiniRISC Soft CPU
This CPU was explicitly designed to teach me computer architecture.
This is my project-based learning attempt to internalize the ideas I've touched on in my self-study.
I used Digital Design and Computer Architecture by Harris and Harris in addition to the amazing videos of Core Dumped, as well as some insightful chats with ChatGPT to fill some minor knowledge gaps.
This was also my first non-trivial, non-tutorial-based project in Verilog.

I think that although there are some serious design flaws, this project served its purpose completely. I have a much deeper understanding of CPU design and computer architecture now.
Additionally, a lot of great practice with Verilog.

## Design and Modules
This design I consider to be the naive CPU design. Everything is done in the straightforward textbook way, with few optimizations and a lot of missing features.
Certain components were omitted either as a design choice for simplicity or due to gaps in my understanding at the time.

- Program Counter
- ROM
- RAM
- Register File
- Control Module
- ALU
- Instruction Decode

### Testing
I additionally added a 7-segment display module to my design to be able to test the output of my programs.
I preloaded values into RAM by hard-coding them in the RAM.v module. I then exported the value of RAM[6].
I loaded the value of RAM[6] to be viewed on the display. My test program loads these 2 values from RAM, adds them together, then stores the result at RAM[6].
Beyond test benches, this was my physical test to see the CPU working physically on the FPGA.

## Notes and Limitations
- This project was created with 2 main goals in mind: 
Make it simple enough that someone relatively new to CPU design can make it, and make it small enough to fit on my very tiny FPGA.
I'm using the NandLand GoBoard, which has a whopping 1280 LUTs. Although this is considered very small, I may have underestimated how much logic can really pack into that space.
My finished CPU is only ~150 LUTs. This gives me some ideas for new projects without buying a new board.

- I started this project thinking I should aim for a 3-bit opcode and 8-bit instructions since I'm not super comfortable with assembly language. This may have been a mistake.
Firstly, I left out a crucial "Load Immediate" instruction, meaning that I have no way of putting data in my RAM using instructions. Instead of complicating my ISA or adding additional modules, I stuck with the simplest option: to add data to RAM you must preload it in the RAM module.
This was a major oversight in my initial ISA design.

- Additionally, I initialized the RAM module to be able to hold 32 bytes of RAM. This would be great, except my design limits access to only 7 bytes of RAM.
My ISA format is 8-bit: [3-bit Opcode, 2-bit Rdst, 3-bit Rsrc or Imm3]. This is fine for simple instructions, but due to the immediate being truncated to 3 bits, the instructions LOAD and STORE limit the immediate to a maximum value of 7.

Example: LOAD R0, 7 loads the value of RAM[7] into R0,
but LOAD R0, 8 loads the value of RAM[0] into R0,
Since the binary 8 (0b1000) gets truncated to 0 when the value of 8 gets transformed into machine code.

## Future Directions
I consider this project functionally complete, but it opens the door to a few future branches. Although some of these would likley require starting from scratch
- A revised version with a Load Immediate instruction and a rethought ISA.
- Implement indirect access for more RAM access and increased functionality
- A 16-bit version with more RAM access, maybe even pipelining.
- Adding serial interfacing (UART, SPI)


### Project Goals Recap
- Build a real working CPU from scratch
- Get it running on physical hardware
- Understand every signal and every instruction
- Avoid tutorials and copy-paste logic
- Keep it small enough to run on a Nandland GoBoard
- Finish the project
