grammar ccc;

unit: command+ | EOF;

command: (
		expression
		| function_call
		| for_loop
		| match_conditional
		| return_call
	) terminator
	| generic_attribution;

assignables:
	match_conditional
	| function_call
	| expression
	| expression_block;

generic_attribution:
	ID COLON type_identifier? OPERATOR_ASSIGNMENT assignables terminator;

expression_block: command | LEFTKEY command+ RIGHTKEY;

type_identifier:
	function_declaration
	| LEFTBRACK TYPELIST RIGHTBRACK
	| TYPELIST;

function_declaration:
	'fn' LEFTPAREN (
		ID COLON type_identifier (COMMA ID COLON type_identifier)?
	)? RIGHTPAREN COLON type_identifier;

function_call:
	ID LEFTPAREN (ID (COMMA ID)?)? RIGHTPAREN
	| ID DOT function_call
	| function_call DOT function_call
	;

for_loop:
	'for' LEFTPAREN ID COLON type_identifier 'in' (
		ID
		| RANGE_LITERAL
	) RIGHTPAREN expression_block;

match_conditional:
	'match' LEFTPAREN ID RIGHTPAREN LEFTKEY match_branch+ RIGHTKEY;

match_branch:
	'as' LEFTPAREN (comparison) RIGHTPAREN OPERATOR_ASSIGNMENT command
	| 'default' OPERATOR_ASSIGNMENT command;

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
	OPERATOR_PLUS
	| OPERATOR_MINUS
	| OPERATOR_MULTIPLICATION
	| OPERATOR_DIVISION
	| OEPRATOR_EXPONENTIAL
	| OPERATOR_INTEGER_DIVISION
	| OPERATOR_MODULUS;
comparison_operators:
	OPERATOR_EQUAL_BY_VALUE
	| OPERATOR_EQUAL_BY_REFERENCE
	| OPERATOR_GREATER
	| OPERATOR_LOWER
	| OPERATOR_GREATER_OR_EQUAL
	| OPERATOR_LOWER_OR_EQUAL
	| OPERATOR_NOT_EQUALS;

binary_operators: arithmethic_operators | comparison_operators;
terminator: SEMICOLON; // maybe?? | NEWLINE | SEMICOLON NEWLINE;

OPERATOR_PLUS: '+';
OPERATOR_MINUS: '-';
OPERATOR_MULTIPLICATION: '*';
OPERATOR_DIVISION: '/';
OPERATOR_MODULUS: '%';
OPERATOR_NOT_EQUALS: '!=';
OPERATOR_INTEGER_DIVISION: '//';
OEPRATOR_EXPONENTIAL: '**';
OPERATOR_ASSIGNMENT: '=';
OPERATOR_EQUAL_BY_VALUE: '==';
OPERATOR_EQUAL_BY_REFERENCE: '===';
OPERATOR_GREATER: '>';
OPERATOR_LOWER: '<';
OPERATOR_GREATER_OR_EQUAL: '>=';
OPERATOR_LOWER_OR_EQUAL: '<=';

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
ID: [a-zA-Z_][a-zA-Z_0-9]*;
COMMENT:
	OPERATOR_DIVISION OPERATOR_MULTIPLICATION .*? OPERATOR_MULTIPLICATION OPERATOR_DIVISION -> skip;