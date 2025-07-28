# Logic Gates

By using just the NAND gate, all the following logic gates have been built.

- NOT
- AND
- OR
- XOR


NAND is the basic building block from which all the other logic gates can be built. 
This is because:
- AND, OR and NOT gates can be built just using NAND.
- Given the `canonical representation` of a boolean function we derive that every boolean function can be built by just using AND, OR, NOT.

The canonical representation of a boolean function can be built from the truth table representing it. Looking at the truth table, consider all the rows with value 1. For each such row a term is created by ANDing together the literals that fix the values all the row's inputs. For example for a row like

a  |  b  |  c   |  out

1  |  0  |  1   |  1

then you do: 

a AND NOT(b) AND c

Then the canonical representation is obtained ORing all the terms created like this. The canonical representation is very helpful in building the chips.


The language used to specify the logic gates is a simplified HDL (Hardware Description Language) interpreted by the Hardware Simulator provided with the book.

