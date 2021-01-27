from typing import TypeVar

'''Define consants, propositional variables, literals and operators ! && || -> <-> '''

T = TypeVar('T')

class Const:
    name: str
    ar: int
    def __init__(self, name):
        if name == 'T' or name == 'F':
            self.name = name
            self.ar = 0
    def __eq__(self, other):
        return isinstance(other, Const) and self.name == other.name

class Var:
    name: str
    ar: int
    def __init__(self, name):
        if name != 'T' and name != 'F':
            self.name = name
            self.ar = 0
    def __eq__(self, other):
        return isinstance(other, Var) and self.name == other.name

class Not:
    name: str
    ar: int
    arg: T
    def __init__(self, arg):
        self.name = 'not'
        self.ar = 1
        self.arg = arg

class Lit:
    name: str
    ar: int
    arg: Var
    sign: bool
    def __init__(self, arg, sign):
        self.name = arg.name if sign else 'not_' + arg.name
        self.ar = 1
        self.arg = arg
        self.sign = sign
    def __eq__(self, other):
        return isinstance(other, Lit) and self.name == other.name
        
class And:
    name: str
    ar: int
    arg1: T
    arg2: T
    def __init__(self, arg1, arg2):
        self.name = 'and'
        self.ar = 2
        self.arg1 = arg1
        self.arg2 = arg2
        
class Or:
    name: str
    ar: int
    arg1: T
    arg2: T
    def __init__(self, arg1, arg2):
        self.name = 'or'
        self.ar = 2
        self.arg1 = arg1
        self.arg2 = arg2

class Impl:
    name: str
    ar: int
    arg1: T
    arg2: T
    def __init__(self, arg1, arg2):
        self.name = 'impl'
        self.ar = 2
        self.arg1 = arg1
        self.arg2 = arg2

class Xnor:
    name: str
    ar: int
    arg1: T
    arg2: T
    def __init__(self, arg1, arg2):
        self.name = 'xnor'
        self.ar = 2
        self.arg1 = arg1
        self.arg2 = arg2

class Xor:
    name: str
    ar: int
    arg1: T
    arg2: T
    def __init__(self, arg1, arg2):
        self.name = 'xor'
        self.ar = 2
        self.arg1 = arg1
        self.arg2 = arg2


'''Some basic functions for formulas processing'''

def to_str(f): #nevermind this, just for test printing
    if f.ar == 0 or isinstance(f, Lit):
        return f.name
    else:
        if f.name == 'not':
            return '!(' + to_str(f.arg) + ')'
        if f.name == 'and':
            return '(' + to_str(f.arg1) + ' && ' + to_str(f.arg2) + ')'
        if f.name == 'or':
            return '(' + to_str(f.arg1) + ' || ' + to_str(f.arg2) + ')'
        if f.name == 'impl':
            return '(' + to_str(f.arg1) + ' -> ' + to_str(f.arg2) + ')'
        if f.name == 'xnor':
            return '(' + to_str(f.arg1) + ' <-> ' + to_str(f.arg2) + ')'
        if f.name == 'xor':
            return '(' + to_str(f.arg1) + ' ^ ' + to_str(f.arg2) + ')'

def build(name, args): #create formula from name and args
    if name == 'not':
        return Not(args)
    if name == 'and':
        return And(args[0], args[1])
    if name == 'or':
        return Or(args[0], args[1])
    if name == 'impl':
        return Impl(args[0], args[1])
    if name == 'xnor':
        return Xnor(args[0], args[1])
    if name == 'xor':
        return Xor(args[0], args[1])

def rm_impl(f): #(p -> q) <=> (!p || q)
    if f.ar == 2:
        if isinstance(f, Impl):
            return rm_impl(Or(Not(f.arg1), f.arg2))
        else:
            return build(f.name, (rm_impl(f.arg1), rm_impl(f.arg2)))
    if f.ar == 1:
        return build(f.name, rm_impl(f.arg))
    if f.ar == 0:
        return f

def rm_xnor(f): #(p <-> q) <=> (p && q) || (!p && !q)
    if f.ar == 2:
        if isinstance(f, Xnor):
            return rm_xnor(Or(And(f.arg1, f.arg2), And(Not(f.arg1), Not(f.arg2))))
        else:
            return build(f.name, (rm_xnor(f.arg1), rm_xnor(f.arg2)))
    if f.ar == 1:
        return build(f.name, rm_xnor(f.arg))
    if f.ar == 0:
        return f

def rm_xor(f): #(p ^ q) <=> (p && !q) || (!p && q)
    if f.ar == 2:
        if isinstance(f, Xor):
            return rm_xor(Or(And(f.arg1, Not(f.arg2)), And(Not(f.arg1), f.arg2)))
        else:
            return build(f.name, (rm_xor(f.arg1), rm_xor(f.arg2)))
    if f.ar == 1:
        return build(f.name, rm_xor(f.arg))
    if f.ar == 0:
        return f
    
def rm_nn(f): #!!p <=> p
    if f.ar == 1:
        if isinstance(f, Not) and isinstance(f.arg, Not):
            return rm_nn(f.arg.arg)
        else:
            return build(f.name, rm_nn(f.arg))
    if f.ar == 2:
        return build(f.name, (rm_nn(f.arg1), rm_nn(f.arg2)))
    if f.ar == 0:
        return f

def rm_aa(f): #(a && a) <=> a, (a || a) <=> a
    def compare(a, b):
        if a.ar == 0 and a.ar == b.ar:
            return a == b
        if a.ar == 1 and a.ar == b.ar:
            return compare(a.arg, b.arg)
        if a.ar == 2 and a.ar == b.ar and a.name == b.name:
            return compare(a.arg1, b.arg1) and compare(a.arg2, b.arg2) or compare(a.arg1, b.arg2) and compare(a.arg2, b.arg1)
    if f.ar == 2:
        if compare(f.arg1, f.arg2):
            return rm_aa(f.arg1)
        else:
            return build(f.name, (rm_aa(f.arg1), rm_aa(f.arg2)))
    if f.ar == 1:
        return build(f.name, rm_aa(f.arg))
    if f.ar == 0:
        return f

def rm_const(f): #(a || 0) <=> a, (a || 1) <=> 1, (a && 0) <=> 0, (a && 1) <=> a
    if f.ar == 2:
        if isinstance(f, Or) and f.arg1.name == 'F' or isinstance(f, And) and f.arg1.name == 'T':
            return rm_const(f.arg2)
        elif isinstance(f, Or) and f.arg2.name == 'F' or isinstance(f, And) and f.arg2.name == 'T':
            return rm_const(f.arg1)
        elif isinstance(f, Or) and f.arg1.name == 'T' or isinstance(f, And) and f.arg1.name == 'F':
            return f.arg1
        elif isinstance(f, Or) and f.arg2.name == 'T' or isinstance(f, And) and f.arg2.name == 'F':
            return f.arg2
        else:
            return build(f.name, (rm_const(f.arg1), rm_const(f.arg2)))
    if f.ar == 1:
        if f.arg.name == 'T':
            return rm_const(Const('F'))
        if f.arg.name == 'F':
            return rm_const(Const('T'))
        else:
            return build(f.name, rm_const(f.arg))
    if f.ar == 0:
        return f

def prepare(f): #perform the necessary formula preprocessing before tseityn transformation
    return rm_aa(rm_nn(rm_xnor(rm_xor((rm_impl(f))))))
