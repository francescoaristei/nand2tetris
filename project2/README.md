### Boolean Arithmetic

Objective of the project is to build the ALU (Arithmetic Logical Unit).

The ALU is the part of the CPU in charge of perfoming all arithmetic and logical operations.

To do so it defines the following:

- Adoption of the binary system on base 2.
    - (10011) base 2 = 1 * 2^4 + 0 * 2^3 + 0 * 2^2 + 1 * 2^1 + 1 ^ 2^0 = (19) base 10.
    - In general given a number as a string of n digits x = xn xn-1....x0 the value of x in base b (x)b:
        - (xn xn-1....x0)b = sum(i = 0..n) of xi * b^i

- Binary addition of two binary numbers.
    - Start adding two right-most digits of the binary numbers. Next we add the resulting carry bit (0 or 1) to the sum of the next pair of bits on the right. Continue until adding the two most significant bits. If the last two bits generate a carry of 1 we report overflow otherwise the addition is finished. Example:

            0   0   0   1    <-- carry

                1   0   0   1 <-- operand

            +   0   1   0   1 <-- operand
            -----------------
            0   1   1   1   0


- Addition performed via 2's complement techinque.
    - Used to obtain signed (positive, negative) binary numbers.
    - Given x, -x obtained leaving least significant 0's until least significant 1 as is and flipping 0's to 1's and viceversa from than on e.g 2 = 00010, -2 = 11110. In Hardware it is obtained flipping all the bits of x and adding 1 to the result.
    - Then usual binary addition is performed.

The chips to implement are:
- Half adder -> adds two bits.
- Full adder -> adds three bits.
- Adder -> adds two 16-bit numbers.
- Incrementer -> Add constant 1 to a given 16-bit number.
- ALU.


#### ALU

- 18 possible functions f(x, y).
    - x, y are both 16-bit binary numbers.
- 6 control bits.
    - if (zx == 1) sets x = 0        // 16-bit constant
    - if (nx == 1) sets x = !x       // bitwise not
    - if (zy == 1) sets y = 0        // 16-bit constant
    - if (ny == 1) sets y = !y       // bitwise not
    - if (f == 1)  sets out = x + y  // integer 2's complement addition
    - if (f == 0)  sets out = x & y  // bitwise and
    - if (no == 1) sets out = !out   // bitwise not
- In theory 2^6 = 64 possible codification for 64 possible functions, but just 18 are defined.
- The possible functions are:
    - 0
    - 1
    - -1
    - x
    - y
    - !x
    - !y
    - -x
    - -y
    - x + 1
    - y + 1
    - x - 1
    - y - 1
    - x + y
    - x - y
    - y - x
    - x & y
    - x | y

Which function to execute is dicated by the combination of the six control bits.
For example, let us consider the case where the ALU is instructed to compute the
function x-1. 
This correspond to the control bits vector: (0, 0, 1, 1, 1, 0)
Indeed, the zx and nx bits are 0, so the x input is neither zeroed nor negated. The zy and ny bits are
1, so the y input is first zeroed, and then negated bit-wise. Bit-wise negation of zero, (000 ...00)2's, gives
(111 ...11)2's, the 2’s complement code of -1. Thus the ALU inputs end up being x and -1. Since the f-bit
is 1, the selected operation is arithmetic addition, causing the ALU to calculate x+ (-1). Finally, since the
no bit is 0, the output is not negated but rather left as is. To conclude, the ALU ends up computing x-1,
which was our goal.




