from init import *
from random import seed, randint, shuffle
import time
import sys
import itertools

sys.setrecursionlimit(10000)
v_cnt = 1
v = 0

def tseitin(f, D): #Tseityn transformation for formula f
    global v_cnt
    if f.ar == 0:
        return (f, D)
    if f.ar == 1:
        f1, D1 = tseitin(f.arg, D)
        return (rm_nn(Not(f1)), D1)
    if f.ar == 2:
        f1, D1 = tseitin(f.arg1, D)
        f2, D2 = tseitin(f.arg2, D1)
        v = Var('v' + str(v_cnt))
        v_cnt += 1
        if isinstance(f, And):
            D3 = D2 + [Or(rm_nn(Not(v)), f1), Or(rm_nn(Not(v)), f2), Or(Or(rm_nn(Not(f1)), rm_nn(Not(f2))), v)]
            return (v, D3) 
        if isinstance(f, Or):
            D3 = D2 + [Or(Or(rm_nn(Not(v)), f1), f2), Or(rm_nn(Not(f1)), v), Or(rm_nn(Not(f2)), v)]
            return (v, D3) 

def clause_to_arr(d): #convert clauses to arrays of literals
    arr = []
    if d.ar == 0:
        arr.append(Lit(d, True))
    if d.ar == 1:
        arr.append(Lit(d.arg, False))
    if d.ar == 2:
        arr = arr + clause_to_arr(d.arg1) + clause_to_arr(d.arg2)
    return arr

def cnf_to_arr(f): #convert formula in cnf to 2D array of literals
    arr = []
    left, right = f.arg1, f.arg2
    while isinstance(left, And):
        arr.append(clause_to_arr(right))
        right = left.arg2
        left = left.arg1
    arr.append(clause_to_arr(right))
    arr.append(clause_to_arr(left))
    return arr

def cnf(f, print_flag=False): #get cnf by Tseityn, print it if necessary and convert output to 2D array of literals
    global v_cnt
    v_cnt = 1
    S = []
    f, D = tseitin(f, [])
    S.append(clause_to_arr(f))
    S += [clause_to_arr(d) for d in D]
    if print_flag:
        out = 'Result of Tseitin transformation\n{'
        out = out + to_str(f).replace(')', '').replace('(', '').replace('!!', '')
        for d in D:
            out = out + '; ' + to_str(d).replace(')', '').replace('(', '').replace('!!', '')
        out += '}\n'
        print(out)
    return S
  
def dpll(S, M): #dpll algorithm for a set of clauses

    def eliminate_pure_literal(S, l):
        S = list(filter(lambda d: not l in d, S))
        return S

    def unit_propagate(S, l):
        S = list(map(lambda d: list(filter(lambda x: x != -1 * l, d)),S))
        return eliminate_pure_literal(S, l)

    def get_unit_literals(S):
        unit_literals = []
        unit_literals += [d[0] for d in S if len(d) == 1 and d[0] not in unit_literals]
        return unit_literals

    def get_pure_literals(S):
        pure_literals = []
        variables = dict()
        for d in S:
            for l in d:
                if not abs(l) in variables.keys():
                    variables[abs(l)] = [l / abs(l)]
                else:
                    variables[abs(l)].append(l / abs(l))
        pure_literals += [v * variables[v][0] for v in variables.keys() if len(set(variables[v])) == 1]
        return pure_literals

    def choose_literal(S):
        seed()
        i = randint(0, len(S) - 1)
        j = randint(0, len(S[i]) - 1)
        return S[i][j]
    
    while len(u := get_unit_literals(S)) > 0:
        for l in u:
            S = unit_propagate(S, l)
            if not (l, 1) in M:
                M.append((l, 1))
    if [] in S:
        return ('UNSAT', [])
    while len(p := get_pure_literals(S)) > 0:
        for l in p:
            S = eliminate_pure_literal(S, l)
            S = list(filter(lambda d: len(d) > 0, S))
            if not (l, 1) in M:
                M.append((l, 1))
    if len(S) == 0:
        return ('SAT', M)
    l = choose_literal(S)
    check_for_l = dpll(S + [[l]], M + [(l, 1)])
    if check_for_l[0] == 'SAT':
        return check_for_l
    else:
        return dpll(S + [[-1 * l]], M + [(l, 0)])  

def solve(S, print_flag=False): #launch dpll algortithm and print the output if necessary

    def simplify_input(S): #transform 2D array of literals to 2D array of integers to speed up the calculations
        S_new = []
        cnt = 1
        map_dict = dict()
        for d in S:
            S_new.append([])
            for l in d:
                if not l.arg.name in map_dict.keys():
                    map_dict[l.arg.name] = cnt
                    cnt += 1
                if l.sign == True:
                    S_new[-1].append(map_dict[l.arg.name])
                else:
                    S_new[-1].append(-1 * map_dict[l.arg.name])
        return S_new, map_dict
    
    S, map_dict = simplify_input(S)
    res, M = dpll(S, [])
    if print_flag:
        print('DPLL algorithm output')
        print(res)
        if res == 'SAT':
            for el in M:
                if el[0] != abs(el[0]):
                    print(list(map_dict.keys())[list(map_dict.values()).index(abs(el[0]))], '->', int(not el[1]))
                else:
                    print(list(map_dict.keys())[list(map_dict.values()).index(abs(el[0]))], '->', el[1])
    return (res, M)

def max_clique_size(k): #find max size v of the clique that can be painted in k colors such as no triangle is monochrome

    def generate_formula(v, k): #describe the fact that clique with v > 2 vertices can be painted in k > 0 colors such as no triangle is monochrome
        formula = None
        for i in range(v - 2): #describe that no triangle is monochrome
            for j in range(i + 1, v - 1):
                for m in range(j + 1, v):
                    for c in range(k):
                        pijc = Var('p' + str(i) + '_' + str(j)+ '_' + str(c))
                        pimc = Var('p' + str(i) + '_' + str(m) + '_' + str(c))
                        pjmc = Var('p' + str(j) + '_' + str(m) + '_' + str(c))
                        if formula is None:
                            formula = Or(Or(Not(pijc), Not(pimc)), Not(pjmc))
                        else:
                            formula = And(formula, Or(Or(Not(pijc), Not(pimc)), Not(pjmc)))
        for i in range(v - 1): #describe that each edge is painted in at least one color
            for j in range(i + 1, v):
                tmp_formula = None
                for c in range(k):
                    pijc = Var('p' + str(i) + '_' + str(j) + '_' + str(c))
                    if tmp_formula is None:
                        tmp_formula = pijc
                    else:
                        tmp_formula = Or(tmp_formula, pijc)
                formula = And(formula, tmp_formula)
        for i in range(v - 1): #describe that each edge cannot be painted in two colors at once
            for j in range(i + 1, v):
                for c1 in range(k - 1):
                    for c2 in range(c1 + 1, k):
                        pijc1 = Var('p' + str(i) + '_' + str(j) + '_' + str(c1))
                        pijc2 = Var('p' + str(i) + '_' + str(j) + '_' + str(c2))
                        formula = And(formula, Or(Not(pijc1), Not(pijc2)))
        return formula

    def is_satisfiable(f): #convert formula to 2D array of literals and check DPLL output on this cnf
        S = cnf_to_arr(f)
        res = solve(S, [])[0]
        if res == 'UNSAT':
            return False
        else:
            return True

    print('For', k, 'colors')
    global v
    if k <= 0:
        return 0
    else:
        v = 3
        start = time.time()
        while is_satisfiable(generate_formula(v, k)):
            print('     ', v, 'vertices: SAT (', round(time.time() - start, 3), 'sec )')
            start = time.time()
            v += 1
        print('     ', v, 'vertices: UNSAT (', round(time.time() - start, 3), 'sec )')
        print('Max clique size is', v - 1)

def is_cell_safe(T, i0, j0):
    
    def get_nbs(i, j): #create variables for all (i, j) neighbors
        nbs = []
        nbs += [Var('p' + str(m) + '_' + str(n)) for m in range(max(0, i - 1), min(N, i + 2))
                for n in range(max(0, j - 1), min(N, j + 2)) if (i, j) != (m, n)]
        return nbs

    def make_conj(nbs, comb, zeros, ones): #make conjunction that describes possible bombs combination around the cell with number 1-8
        conj = None
        for v in nbs:
            if v in comb: #cells that we suppose to be bombs
                if v in zeros:
                    v = Const('F')
                if v in ones:
                    v = Const('T')
                if conj is None:
                    conj = v
                else:
                    conj = And(conj, v)
            else: #cells that we suppose to be empty
                if v in zeros:
                    v = Const('F')
                if v in ones:
                    v = Const('T')
                if conj is None:
                    conj = Not(v)
                else:
                    conj = And(conj, Not(v))                 
        return conj
        
    def generate_formula(): #describe the playing field for configuration T; pij = 1 <=> (i, j) cell contains bomb
        zeros, ones = [], [] 
        for i in range(N):
            for j in range(N):
                if T[i][j] == 0: #0 bombs around (i, j) cell => all neighbors variables should be set to 0
                    zeros += get_nbs(i, j)
                if T[i][j] == -1 or (i, j) == (i0, j0): #set variables for bomb-cells to 1, assuming that (i0, j0) cell also contains bomb
                    ones.append(Var('p' + str(i) + '_' + str(j)))
                if T[i][j] > 0 and T[i][j] < 9: #such cell is already opened => no bomb here
                    zeros.append(Var('p' + str(i) + '_' + str(j)))
        if Var('p' + str(i0) + '_' + str(j0)) in zeros: #such cell is obviously safe
            return Const('F')
        formula = None
        for i in range(N):
            for j in range(N): 
                if T[i][j] > 0 and T[i][j] < 9: #there are some bombs around this cell
                    nbs = get_nbs(i, j)
                    combinations = list(itertools.combinations(nbs, T[i][j])) #consider all possible choices
                    tmp_formula = None
                    for comb in combinations: #describe that some combination should be true
                        if tmp_formula is None:
                            tmp_formula = make_conj(nbs, comb, zeros, ones)
                        else:
                            tmp_formula = Or(tmp_formula, make_conj(nbs, comb, zeros, ones))
                    if formula is None:
                        formula = tmp_formula
                    else:
                        formula = And(formula, tmp_formula)
                    for i1 in range(len(combinations) - 1): #describe that 2 combinations at a time cannot be true
                        for i2 in range(i1 + 1, len(combinations)):
                            f1 = Not(make_conj(nbs, combinations[i1], zeros, ones))
                            f2 = Not(make_conj(nbs, combinations[i2], zeros, ones))
                            formula = And(formula, Or(f1, f2))
        while ('T' in to_str(formula) or 'F' in to_str(formula)) and len(to_str(formula)) > 1: #simplify for DPLL   
            formula = rm_const(formula)
        return formula

    N = len(T)
    f = generate_formula()
    if isinstance(f, Const): #no variables left after removing constants 
        if f.name == 'F': 
            return 'safe'
        else:
            return 'not safe'
    else:
        res = solve(cnf(f))[0] #else use DPLL on formula
        if res == 'UNSAT':
            return 'safe'
        else:
            return 'not safe'





    
