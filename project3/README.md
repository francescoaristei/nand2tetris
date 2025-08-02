### Sequential Logic

The chips defined so far, were combinational chips.
This means their output depends only on their input, without having any ability to preserve state.

Computers must be able to not only compute values but also store and recall values, they must be equipped
with memory elements that can preserve data over time. These memory elements are built from sequential
chips.
The basic building block to obtain such chips is the `flip-flop`.
Using these flip-flops, we will specify and build all the memory devices employed by typical modern computers, from binary cells to registers to memory banks and counters.


Remembering is inherently time-dependent. Thus, in order to build chips that “remember” information, we must first
develop the concept of the progression of time.

#### Clock

In most computers, the passage of time is represented by a master clock that continuosly sends signals to the other components. The time between the beginning of a “tick” and the end of the subsequent “tock” is called cycle, and each clock cycle is taken to model one discrete time unit. The current clock phase (tick or tock) is represented by a binary signal. Using the hardware’s circuitry, this signal is simultaneously broadcast to every sequential chip throughout the computer platform.

#### Flip-Flop

The project uses a DFF (Data Flip Flop).
Takes a input in and a clock input which change following the master clock.
The function of the DFF is:
- out(t) = in(t-1) --> The output at time t is the input at the time t - 1.

t is the current clock cycle.

From such element all the other chips having memory are built.

#### Register

A register is a storage device that can store a value, implementing the classical storage behavior out(t) = out(t - 1).
A DFF, on the other hand, can only output its previous input, namely, out(t) = in(t - 1).

To solve this, it can be introduced a multiplexor into the design. The sel bit of this multiplexor can become the load of the
overall register chip: If we want the register to start storing a new value, we can put this value in the in
input and set the load bit to 1; if we want the register to keep storing its internal value until further notice,
we can set the load bit to 0.

Registers of n-bits can be obtained forming an array of as many single-bit registers as needed, creating a register that holds multi-bit values. 

- width: number of bits that it holds—e.g., 16, 32, or 64. 
- words: multi-bit contents of such registers.

#### Memory

Once we have the basic ability to represent words, we can proceed to build memory banks of arbitrary length. Stacking together many registers we can form a Random Access Memory RAM unit. Random means that it is required that any word in the memory irrespective of its physical location can be accessed directly, in equal speed.


First, we assign each word in the n-register RAM a unique address (an integer between 0 to n - 1), according to which it will be accessed. Second, in addition to building an array of n registers, we build a gate logic design that, given an address j, is capable of selecting the individual register whose address is j.

In sum, a classical RAM device accepts three inputs:
- data input
- address input
- load bit. 

The address specifies which RAM register should be accessed in the current time unit. 
In the case of a read operation (load=0), the RAM’s output immediately emits the value of the selected register. In the case of a write operation (load=1), the selected memory register commits to the input value in the next time unit,
at which point the RAM’s output will start emitting it. 

The basic design parameters of a RAM device are its data width—the width of each one of its words, and its size—the number of words in the RAM.


#### (Program) Counter

Sequential chip whose state is an integer number that increments every time unit, executing the function 
- out(t) = out(t - 1) + c

Where c is typically 1. 

Counters play an important role in digital architectures. For example, a typical CPU includes a program counter whose output is interpreted as the address of the instruction that should be executed next in the current program.

The counter will have to be equipped with some additional functionality, such as possibilities for resetting the count to zero, loading a new counting base, or decrementing instead of incrementing.


#### Clock and Synchronization

In combinational chips output depends only on the input, without considering the time.
In sequential architectures the output changes only moving from one clock cycle to the next one, meaning the 
output has to be correct at the beginning of the next clock cycle.

The sequential chips can have unstable states inside a clock cycle.
This discretization allows to synchronize the whole computer.

##### Example


Suppose we instruct the arithmetic logic unit (ALU) to compute x + y where x is the value of a nearby register and y is the value of a remote RAM register. Because of various physical constraints (distance, resistance, interference, random noise, etc.) the electric signals representing x and y will likely arrive at the ALU at different times.

The ALU is insensitive to the concept of time, it continuously adds up whichever data values happen to lodge in its inputs. 

Thus, it will take some time before the ALU’s output stabilizes to the correct x + y result. Until then, the ALU will generate garbage.

But since the output of the ALU is always routed to some sort of a sequential chip (a register, a RAM location, etc.), we don’t really care. All we have to do is ensure, when we build the computer’s clock, that the length of the clock cycle will be slightly longer that the time it takes a bit to travel the longest distance from one chip in the architecture to another. This way, we are guaranteed that by the time the sequential chip updates its state (at the beginning of the next clock cycle), the inputs that it receives from the ALU will be valid. 

This is the trick that synchronizes a set of stand-alone hardware components into a well-coordinated system.