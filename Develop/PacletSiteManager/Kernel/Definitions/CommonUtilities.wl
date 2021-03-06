(* ::Package:: *)

SetAttributes[WithContext, HoldAllComplete]
WithContext[context_String, expr_] := Block[{$Context = context, $ContextPath = {}},
	expr
]
