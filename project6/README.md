### Assembler

The assembler parses each assembly command into its underlying fields, translates each field into its equivalent binary code, and assembles the generated codes into a binary instruction that can be actually executed by the hardware.

Given the following 32 bits binary code: 110000101000000110000000000000111

Depending on the Hardware logic design and agree-upon machine language, this could be translated into the operation: load content of Memory[7] into register R3.

The trickiest part of writing an assembler regards the translation of symbols:

- Variables: The programmer can use symbolic variable names, and the translator will "automatically" assign them to memory addresses.
- Labels:  The programmer can mark various locations in the program with symbols. For example, one can declare the label LOOP to refer to the beginning of a certain code segment.

Translating agreed-upon symbols into agreedupon binary codes is not a complicated task but the mapping of user-defined variable names and symbolic labels on actual memory addresses is not trivial.

The challenge of `symbol resolution` can be highlighted by three questions:

- Suppose we could start storing variables from adress N in the memory. How can be known that the lenght of the program won't exceed such address? Therefore, from which address to start storing the variables?
-  Typically, some assembly command may translate into several machine instructions and thus will end up occupying several memory locations. How many instruction for an assembly command?
- How much memory for a variable? When allocating memory space for variables, the translator must take into account both their data types and the word width of the target hardware.

The tasks of an assembler are the following:

- Parse the symbolic command into its underlying fields.
- For each field, generate the corresponding bits in the machine language.
- Replace all symbolic references (if any) with numeric addresses of memory locations.
- Assemble the binary codes into a complete machine instruction.


### Hack Assembly

Quick summary of the Hack assembly.

The assembler needs to translate programs written in .asm extension into .hack files (binary files).

In Hack a binary code file is composed of text lines.
Each line is a sequence of sixteen 0 and 1 ASCII characters, coding a 16-bit machine language instruction.
When a machine language program is loaded into the computer's instruction memory, the binary code represented by the file's nth line is stored in address n of the instruction memory --> the count of both program lines and memory addresses starts at 0.

For more details, check README in project4.

It is useful to propose the tables associating to a symbol of the language, the binary code.

For DEST:

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

For JUMP:

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

For COMP:

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


