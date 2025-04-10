
# parsetab.py
# This file is automatically generated. Do not edit.
# pylint: disable=W,C,R
_tabversion = '3.10'

_lr_method = 'LALR'

_lr_signature = 'leftPLUSMINUSleftTIMESDIVIDEDIVIDE LPAREN MINUS NUMBER PLUS RPAREN TIMESexpr : expr PLUS termexpr : expr MINUS termexpr : termterm : term TIMES factorterm : term DIVIDE factorterm : factorfactor : LPAREN expr RPARENfactor : NUMBER'
    
_lr_action_items = {'LPAREN':([0,4,6,7,8,9,],[4,4,4,4,4,4,]),'NUMBER':([0,4,6,7,8,9,],[5,5,5,5,5,5,]),'$end':([1,2,3,5,11,12,13,14,15,],[0,-3,-6,-8,-1,-2,-4,-5,-7,]),'PLUS':([1,2,3,5,10,11,12,13,14,15,],[6,-3,-6,-8,6,-1,-2,-4,-5,-7,]),'MINUS':([1,2,3,5,10,11,12,13,14,15,],[7,-3,-6,-8,7,-1,-2,-4,-5,-7,]),'RPAREN':([2,3,5,10,11,12,13,14,15,],[-3,-6,-8,15,-1,-2,-4,-5,-7,]),'TIMES':([2,3,5,11,12,13,14,15,],[8,-6,-8,8,8,-4,-5,-7,]),'DIVIDE':([2,3,5,11,12,13,14,15,],[9,-6,-8,9,9,-4,-5,-7,]),}

_lr_action = {}
for _k, _v in _lr_action_items.items():
   for _x,_y in zip(_v[0],_v[1]):
      if not _x in _lr_action:  _lr_action[_x] = {}
      _lr_action[_x][_k] = _y
del _lr_action_items

_lr_goto_items = {'expr':([0,4,],[1,10,]),'term':([0,4,6,7,],[2,2,11,12,]),'factor':([0,4,6,7,8,9,],[3,3,3,3,13,14,]),}

_lr_goto = {}
for _k, _v in _lr_goto_items.items():
   for _x, _y in zip(_v[0], _v[1]):
       if not _x in _lr_goto: _lr_goto[_x] = {}
       _lr_goto[_x][_k] = _y
del _lr_goto_items
_lr_productions = [
  ("S' -> expr","S'",1,None,None,None),
  ('expr -> expr PLUS term','expr',3,'p_expression_plus','aritmetico_validador.py',54),
  ('expr -> expr MINUS term','expr',3,'p_expression_minus','aritmetico_validador.py',59),
  ('expr -> term','expr',1,'p_expression_term','aritmetico_validador.py',63),
  ('term -> term TIMES factor','term',3,'p_term_times','aritmetico_validador.py',67),
  ('term -> term DIVIDE factor','term',3,'p_term_divide','aritmetico_validador.py',71),
  ('term -> factor','term',1,'p_term_factor','aritmetico_validador.py',75),
  ('factor -> LPAREN expr RPAREN','factor',3,'p_factor_paren','aritmetico_validador.py',79),
  ('factor -> NUMBER','factor',1,'p_factor_number','aritmetico_validador.py',83),
]
