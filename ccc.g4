grammar ccc;

unit: generic_attribution+ | EOF;

command: (
		expression
		| function_call
		| for_loop
		| match_conditional
		| return_call
	) SEMICOLON
	| generic_attribution;

assignables:
	match_conditional
	| function_call
	| expression
	| expression_block;

generic_attribution:
	ID COLON type_identifier? OP_ASSING assignables SEMICOLON;

expression_block: command | LEFTKEY command+ RIGHTKEY;

type_identifier:
	function_declaration
	| LEFTBRACK TYPELIST RIGHTBRACK
	| TYPELIST;

function_declaration:
	'fn' LEFTPAREN (
		ID COLON type_identifier (COMMA ID COLON type_identifier)?
	)? RIGHTPAREN COLON type_identifier;

function_call: ID LEFTPAREN (ID (COMMA ID)?)? RIGHTPAREN;

for_loop:
	'for' LEFTPAREN ID COLON type_identifier 'in' (
		ID
		| RANGE_LITERAL
	) RIGHTPAREN expression_block;

match_conditional:
	'match' LEFTPAREN ID RIGHTPAREN LEFTKEY match_branch+ RIGHTKEY;

match_branch:
	'as' LEFTPAREN (comparison) RIGHTPAREN OP_ASSING command
	| 'default' OP_ASSING command;

return_call: 'ret' assignables;

expression:
	lhs = expression_atom op = binary_operators rhs = expression_atom
	| expression_atom;

expression_atom:
	STRING_LITERAL
	| FLOAT_LITERAL
	| INT_LITERAL
	| ID;

comparison:
	lhs = expression op = comparison_operators rhs = expression;

arithmethic_operators:
	OP_PLUS
	| OP_MINUS
	| OP_MULT
	| OP_DIV
	| OP_EXPONENTIAL
	| OP_INTDIV
	| OP_MOD;
comparison_operators:
	OP_VAL_EQ
	| OP_REF_EQ
	| OP_GREATER
	| OP_LOWER
	| OP_GREATEREQ
	| OP_LOWEREQ
	| OP_NOTEQ;

binary_operators: arithmethic_operators | comparison_operators;

CONST: 'const';
LET: 'let';

OP_PLUS: '+';
OP_MINUS: '-';
OP_MULT: '*';
OP_DIV: '/';
OP_MOD: '%';
OP_NOTEQ: '!=';
OP_INTDIV: '//';
OP_EXPONENTIAL: '**';
OP_ASSING: '=';
OP_VAL_EQ: '==';
OP_REF_EQ: '===';
OP_GREATER: '>';
OP_LOWER: '<';
OP_GREATEREQ: '>=';
OP_LOWEREQ: '<=';

IGNORE: [\t\r\n] -> skip;
WHITESPACE: ' ' -> skip;
COLON: ':';
SEMICOLON: ';';
COMMA: ',';
QUESTIONMARK: '?';
PIPEMARK: '|';
DOT: '.';
LEFTKEY: '{';
RIGHTKEY: '}';
LEFTPAREN: '(';
RIGHTPAREN: ')';
LEFTBRACK: '[';
RIGHTBRACK: ']';
DOUBLEQOUTE: '"';

TYPELIST: 'r64' | 'r32' | 'r16' | 'r8' | 'num' | 'str';

STRING_LITERAL: DOUBLEQOUTE .*? DOUBLEQOUTE;

FLOAT_LITERAL: [0-9]+ DOT [0-9]+ | DOT [0-9]+;

RANGE_LITERAL: INT_LITERAL '..' INT_LITERAL;
INT_LITERAL: [0-9]+;
ID: [a-zA-Z_]+;
COMMENT: OP_DIV OP_MULT .*? OP_MULT OP_DIV -> skip;
