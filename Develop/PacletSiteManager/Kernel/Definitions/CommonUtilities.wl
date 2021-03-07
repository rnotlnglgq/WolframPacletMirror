(* ::Package:: *)

SetAttributes[WithContext, HoldAllComplete]
WithContext[context_String, expr_] := Block[{$Context = context, $ContextPath = {}},
	expr
]


$VersionStringComplete = StringRiffle[#, "."]&@{
	If[StringMatchQ[#, "*."], # <> "0", #]&@ToString@$VersionNumber,
	ToString@$ReleaseNumber,
	ToString@$MinorReleaseNumber
}
