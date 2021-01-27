from init import *
from main import *

print('Test 1')
print('1 ! ?\n? 2 ?      ! -- bomb\n1 ? ?      ? -- empty\n')
T = [[1, -1, -2], [-2, 2, -2], [1, -2, -2]]
for i in range(3):
    for j in range(3):
        if (i, j) != (0, 0) and (i, j) != (0, 1) and (i, j) != (1, 1) and (i, j) != (2, 0):
            print('cell (' + str(i) + ', ' + str(j) + ') --', is_cell_safe(T, i, j))                        
print('-----------------------------\n')

print('Test 2')
print('1 ? ? 0\n? ! ? 0\n? ? 3 ?      ! -- bomb\n? ? ? 1      ? -- empty\n')
T = [[1, -2, -2, 0], [-2, -1, -2, 0], [-2, -2, 3, -2], [-2, -2, -2, 1]]
for i in range(4):
    for j in range(4):
        if (i, j) != (0, 0) and (i, j) != (0, 3) and (i, j) != (1, 1) and (i, j) != (1, 3) and (i, j) != (2, 2) and (i, j) != (3, 3):
            print('cell (' + str(i) + ', ' + str(j) + ') --', is_cell_safe(T, i, j))                        

print('-----------------------------\n')
