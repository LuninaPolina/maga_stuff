from init import *
from main import *

p = Var('p')
q = Var('q')
r = Var('r')

print('Test 1')
print('!(!(p && q) -> !r))\n')
f1 = Not(Impl(Not(And(p, q)), Not(r)))
f1 = prepare(f1)
S1 = cnf(f1, True)
solve(S1, True)
print('-----------------------------\n')

print('Test 2')
print('(!p -> q) && !p && !q\n')
f2 = And(Impl(Not(p), q), And(Not(p), Not(q)))
f2 = prepare(f2)
S2 = cnf(f2, True)
solve(S2, True)
print('-----------------------------\n')

print('Test 3')
print('(p && r <-> q) && (!p -> q)\n')
f3 = And(Xnor(And(p, r), q), Impl(Not(p), q))
f3 = prepare(f3)
S3 = cnf(f3, True)
solve(S3, True)
print('-----------------------------\n')





