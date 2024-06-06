from z3 import *

# Create a solver instance
solver = Solver()

# Define a 32-character array of bit-vectors (8 bits each)
v4 = [BitVec(f'v4_{i}', 8) for i in range(32)]

# Add constraints based on the provided conditions
solver.add(v4[29] == v4[5] - v4[3] + 70)
solver.add(v4[22] + v4[2] == v4[13] + 123)
solver.add(v4[4] + v4[12] == v4[5] + 28)
solver.add(v4[23] * v4[25] == v4[17] + v4[0] + 23)
solver.add(v4[1] * v4[27] == v4[22] + v4[5] - 21)
solver.add(v4[13] * v4[9] == v4[3] * v4[28] - 9)
solver.add(v4[9] == 112)
solver.add(v4[21] + v4[19] == v4[6] + 0x80)
solver.add(v4[16] == v4[15] - v4[11] + 48)
solver.add(v4[27] * v4[7] == v4[13] * v4[1] + 45)
solver.add(v4[13] == v4[13] + v4[18] - 101)
solver.add(v4[20] - v4[8] == v4[9] + 124)
solver.add(v4[31] == v4[8] - v4[31] - 121)
solver.add(v4[31] * v4[20] == v4[20] + 4)
solver.add(v4[24] - v4[17] == v4[8] + v4[21] - 23)
solver.add(v4[5] + v4[7] == v4[29] + v4[5] + 44)
solver.add(v4[10] * v4[12] == v4[1] - v4[11] - 36)
solver.add(v4[0] * v4[31] == v4[26] - 27)
solver.add(v4[20] + v4[1] == v4[10] - 125)
solver.add(v4[18] == v4[14] + v4[27] + 2)
solver.add(v4[11] * v4[30] == v4[21] + 68)
solver.add(v4[19] * v4[5] == v4[1] - 44)
solver.add(v4[13] - v4[26] == v4[21] - 127)
solver.add(v4[23] == v4[29] - v4[0] + 88)
solver.add(v4[19] == v4[13] * v4[8] - 23)
solver.add(v4[22] + v4[6] == v4[3] + 83)
solver.add(v4[12] == v4[7] + v4[26] - 114)
solver.add(v4[16] == v4[18] - v4[5] + 51)
solver.add(v4[30] - v4[8] == v4[29] - 77)
solver.add(v4[20] - v4[11] == v4[3] - 76)
solver.add(v4[16] - v4[7] == v4[17] + 102)
solver.add(v4[21] + v4[1] == v4[18] + v4[11] + 43)

# Check if the constraints are satisfiable
if solver.check() == sat:
    model = solver.model()
    license_key = ''.join(chr(model[v4[i]].as_long()) for i in range(32))
    print(f'License Correct: {license_key}')
else:
    print('No solution found')

