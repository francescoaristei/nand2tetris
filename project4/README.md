### Machine Language

This project won't actually develop new parts of the Hardware-Software stack of the Hack Computer, however
is essential to understand the Hack machine language and get acquainted with how the binary code is executed by the
hardware and the translation process from assembly to binary code performed by the Assembler (that will be implemented later).

The machine language mainly commands the hardware to perform the following operations:

- Arithmetic operations.
- Logic operations.
- Fetch/Store values from and to memory.
- Move values from one register to another.
- ...

To describe a machine language we can focus on just three hardware components:

- CPU
    - Arithmetic/logic operations (via ALU).
    - Memory access operations.
    - Control operations (branching).
    - Operands of operations are binary values coming from:
        - Registers.
        - Memory locations.
- Memory
    - Hardware used to store data and instructions.
    - Continuous array of cells of a fixed width (called word) having a unique address.
- Registers:
    - Memory chips located close to the CPU.
    - Can hold a single value (word).
    - High speed local memory --> allow CPU to manipulate data and instructions quickly.

#### Instruction Set

Given the binary code:  1010001100011001.

To know what instruction is, is required to know the instruction set of the hardware platform.
For example, the instruction set may specify that each instruction consists of 4 bits field and that the 
the four most left bits codify a CPU operation while the others the operands.
In this context the code above may be translated as: set register R3 to R1 + R9.

The machine languages are defined to have more human readable syntax. Associating each binary code to a certain human readable string.
For example, knowing now what operation the previous binary code is defining, a machine language could associate to it the following instruction:

- ADD R3, R1, R9.

Since each hardware platform (computer) has different operations, number and type of registers there are various machine languages, each associated to a hardware platform.

In general however, the main operations done by each machine language are the following:

- Arithmatic and logic operations.
- Memory access --> Used to load data from memory cells (to perform arithmetic/logic instructions on it) and to store the result of such instructions in memory cells. There are various kind of addressing mode:
    - Direct addressing: Express a specific address: LOAD R1, 67 --> loads in register R1 the cells Memory[67].
    - Immediate addressing: It loads a numeric value into a register: LOAD R1, 67 --> load in register R1 the value 67.
    - Indirect addressing: LOAD R1, 67 --> loads in register R1 the content of the memory cell whose address is written in the memory location 67.

- Flow of Control:
    - Jumps to locations other than the next instruction (repetition, conditional executiong, subroutine calling).


#### Hack Machine Language

The Hack Computer is a 16-bit Von Neumann architecture consisting of:
- CPU.
- Two memory modules:
    - Instruction memory.
    - Data memory.
- Two memory mapped I/O devices:
    - Screen.
    - Keyboard.


##### Memory

Composed by two 16-bit wide (words of 16 bits) memories of 32K 16 bits words size (address space of 15 bits):
    - Instruction memory.
    - Data memory.

The instruction memory is a read-only device (ROM chip), programs are loaded and "burned" in it. Everytime a new program is loaded, the whole ROM is substituted.
The CPU can only executes program in the instruction memory.

##### Registers

Two 16-bit registers:
- D store data values.
- A
    - Both data register and address register (depending on the instruction its value is pure data, or an address in data memory or instruction memory).
    - Hack instructions are 16 bits long, addresses are specified with 15 bits --> impossible to have operation code + address in one 16-bits instruction, A plays a special role both with data and instruction memory.
        - Data memory
            - Convention: each memory access instructions refer to said memory location M.
            - D = M + 1 --> convention is that M refers to a memory location whose address is contained in the A register.
            - To perform D = M + 1 where we want M = Memory[516] then before we need to perform an instruction to set the content of register A to 516.
        - Instruction memory
            - Hack jump instruction never specify an address.
            - Any jump operation always jump to the instruction in the memory instruction whose address is the content of the register A.
            - To jump to instruction 35: first we set address A with the value 35 then we perform goto instruction, which implicitly knows where to jump (looking in register A).

Manipulated directly by arithmetic/logical instructions (A = D - 1, D != A etc)


##### @value 

Stores the specified value in the A register.
value is either an actual number or a symbol defining a number, which has been defined before.
@17 or @sum do the same thing if sum has been previously defined as equal to 17.

##### A-instruction

Used to set the A register to a 15-bit value.

A @value

Binary code: | 0 v v v  |  v v v v   |  v v v v   |  v v v v |

@5 is eq to: | 0 0 0 0  |  0 0 0 0   |  0 0 0 0   |  0 1 0 1 |

the first 0 is the op code specific for A the rest is the value to store in the A register.
This instruction is used to store a value in A but also to store an address for a data memory instruction or to store an address for an instruction memory instruction as defined earlier.


##### C-instruction

Binary code | 1 1 1 a |  c1 c2 c3 c4 |  c5 c6 d1 d2 |  d3 j1 j2 j3 |

The left most 1 is the op code of the C instruction.

The other two 1's are left as is.

- The c bits are the comp field: instruct the ALU what to compute.

- The d bits are the dest field: where to store the output of the ALU
    - The first and second d-bits code whether to store the computed value in the A register and in the D register, respectively. 
    - The third d-bit codes whether to store the computed value in M (i.e., in Memory[A]).
    - One, more than one, or none of these bits may be asserted.

| d1 | d2 | d3 | Mnemonic | Destination (where to store the computed value)                |
|----|----|----|----------|---------------------------------------------------------------|
| 0  | 0  | 0  | null     | The value is not stored anywhere                              |
| 0  | 0  | 1  | M        | Memory[A] (memory register addressed by A)                    |
| 0  | 1  | 0  | D        | D register                                                    |
| 0  | 1  | 1  | MD       | Memory[A] and D register                                      |
| 1  | 0  | 0  | A        | A register                                                    |
| 1  | 0  | 1  | AM       | A register and Memory[A]                                      |
| 1  | 1  | 0  | AD       | A register and D register                                     |
| 1  | 1  | 1  | AMD      | A register, Memory[A], and D register                         |

- The j bits are the jump field: where to jump next (which instruction to fetch and execute next)
    - The computer should either fetch and execute the next instruction in the program, which
is the default.
    - The computer should fetch and execute an instruction located elsewhere in the program
        - We assume that the A register has been previously set to the address to which we have to jump.
    - The first j-bit specifies whether to jump in case this value is negative, the second j-bit in case the value is zero, and the third j-bit in case it is positive.
        - More can be set at the same time (>= or <=).
        - If they are all 1 then an unconditional jump is performed.

| j1 | j2 | j3 | Mnemonic | Jump Condition                       |
|----|----|----|----------|--------------------------------------|
| 0  | 0  | 0  | null     | No jump                              |
| 0  | 0  | 1  | JGT      | Jump if out > 0                      |
| 0  | 1  | 0  | JEQ      | Jump if out == 0                     |
| 0  | 1  | 1  | JGE      | Jump if out >= 0                     |
| 1  | 0  | 0  | JLT      | Jump if out < 0                      |
| 1  | 0  | 1  | JNE      | Jump if out != 0                     |
| 1  | 1  | 0  | JLE      | Jump if out <= 0                     |
| 1  | 1  | 1  | JMP      | Unconditional jump                   |


The Hack ALU is designed to compute a fixed set of functions on the D, A, and M registers (where M stands for Memory[A]). 

The computed function is specified by the a-bit and the six c-bits comprising the instruction’s comp field. This 7-bit pattern can potentially code 128 different functions, of which only the 28 listed.

For example the operation D - 1 is done with the following 3 binary operations:

Compute the constant -1 : 
- 1110 1110 1000 0000

Compute the value of D|M:

-  1111 0101 0100 0000

Compute D - 1: 
- 1110 0011 1000 0000


The following is the table with all the functions that can be instructed to the ALU via the C instruction.

The a bit is used to apply a function either to A or to M as we can see in the table.

| a | comp mnemonic | c1 | c2 | c3 | c4 | c5 | c6 |
|---|----------------|----|----|----|----|----|----|
| 0 | 0              | 1  | 1  | 1  | 0  | 1  | 0  |
| 0 | 1              | 1  | 1  | 1  | 1  | 1  | 1  |
| 0 | -1             | 1  | 1  | 1  | 0  | 1  | 1  |
| 0 | D              | 0  | 0  | 1  | 1  | 0  | 0  |
| 0 | A              | 1  | 1  | 0  | 0  | 0  | 0  |
| 0 | !D             | 0  | 0  | 1  | 1  | 0  | 1  |
| 0 | !A             | 1  | 1  | 0  | 0  | 0  | 1  |
| 0 | -D             | 0  | 0  | 1  | 1  | 1  | 1  |
| 0 | -A             | 1  | 1  | 0  | 0  | 1  | 1  |
| 0 | D+1            | 0  | 1  | 1  | 1  | 1  | 1  |
| 0 | A+1            | 1  | 1  | 0  | 1  | 1  | 1  |
| 0 | D-1            | 0  | 0  | 1  | 1  | 1  | 0  |
| 0 | A-1            | 1  | 1  | 0  | 0  | 1  | 0  |
| 0 | D+A            | 0  | 0  | 0  | 1  | 0  | 1  |
| 0 | D-A            | 0  | 1  | 0  | 0  | 1  | 1  |
| 0 | A-D            | 0  | 0  | 0  | 0  | 1  | 1  |
| 0 | D&A            | 0  | 0  | 0  | 0  | 0  | 0  |
| 0 | D\|A           | 0  | 1  | 0  | 1  | 0  | 1  |
| 1 | M              | 1  | 1  | 0  | 0  | 0  | 0  |
| 1 | !M             | 1  | 1  | 0  | 0  | 0  | 1  |
| 1 | -M             | 1  | 1  | 0  | 0  | 1  | 1  |
| 1 | M+1            | 1  | 1  | 0  | 1  | 1  | 1  |
| 1 | M-1            | 1  | 1  | 0  | 0  | 1  | 0  |
| 1 | D+M            | 0  | 0  | 0  | 1  | 0  | 1  |
| 1 | D-M            | 0  | 1  | 0  | 0  | 1  | 1  |
| 1 | M-D            | 0  | 0  | 0  | 0  | 1  | 1  |
| 1 | D&M            | 0  | 0  | 0  | 0  | 0  | 0  |
| 1 | D\|M           | 0  | 1  | 0  | 1  | 0  | 1  |


##### RAM Addresses

- Virtual Registers: symbols R0 to R15 are predefined to refer to RAM addressed 0 to 15.
- Predefined pointers: Symbols SP, LCL, ARG, THIS and THAT are predefined to refer to RAM addresses 0 to 4. Therefore RAM addresses can be referenced using two symbolic notations (will need later for the virtual machine).
- I/0 pointers: Symbols SCREEN and KBD are predefined to refer to RAM addresses 16384 (0x4000) and 24576 (0x6000), base addresses of the screen and keyboard memory maps.
- Label symbols: Declared via the pseudo command "(Xxx)". Are used to label the destination of a goto command, e.g the instruction memory location holding the next command in the program.
- Variable symbols: Variable that is not defined with the pseudo command "(Xxx)". Is assigned a unique memory address by the assembler, starting at RAM address 16 (0x0010).


##### Input/Output Handling

Hack platform connected to two peripheral devices:
- screen
- keyboard

They both interact with the computer via memory maps.
This means that drawing pixels on the screen is achieved by writing binary values into a memory segment associated with the screen. Likewise, listening to the keyboard is done by reading a memory location associated with the keyboard. The physical I/O devices and their memory maps are synchronized via continuous refresh loops.

###### Screen

The Hack computer includes a black-and-white screen organized as 256 rows of 512 pixels per row. The screen’s contents are represented by an 8K memory map that starts at RAM address 16384 (0x4000). Each row in the physical screen, starting at the screen’s top left corner, is represented in the RAM by 32 consecutive 16-bit words (32 * 16 = 512). Thus the pixel at row r from the top and column c from the left is mapped on the c%16 bit (counting from LSB to MSB) of the word located at RAM[16384 + r · 32 + c/16]. To write or read a pixel of the physical screen, one reads or writes the corresponding bit in the
RAM-resident memory map (1 = black, 0 = white).

###### Keyboard

The Hack computer interfaces with the physical keyboard via a single-word memory map located in RAM address 24576 (0x6000). Whenever a key is pressed on the physical keyboard, its 16-bit ASCII code appears in RAM[24576]. When no key is pressed, the code 0 appears in this location. In addition to the usual ASCII codes, the Hack keyboard recognizes additional keys show below.

| Key Pressed   | Code |   | Key Pressed | Code |
|---------------|------|---|--------------|------|
| newline       | 128  |   | end          | 135  |
| backspace     | 129  |   | page up      | 136  |
| left arrow    | 130  |   | page down    | 137  |
| up arrow      | 131  |   | insert       | 138  |
| right arrow   | 132  |   | delete       | 139  |
| down arrow    | 133  |   | esc          | 140  |
| home          | 134  |   | f1–f12       | 141–152 |

##### Binary Code Files

A binary code file is composed of text lines. Each line is a sequence of sixteen “0”
and “1” ASCII characters, coding a single machine language instruction. Taken together, all the lines in
the file represent a machine language program. The contract is such that when a machine language
program is loaded into the computer’s instruction memory, the binary code represented by the file’s nth
line is stored in address n of the instruction memory (the count of both program lines and memory
addresses starts at 0). 


By convention, machine language programs are stored in text files with a “hack” extension, for example, Prog.hack, while assembly programs in file with extensions .asm.


