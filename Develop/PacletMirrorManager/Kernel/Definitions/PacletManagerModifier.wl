(* ::Package:: *)

(* ::Title:: *)
(*PacletManagerModifier*)


(* ::Text:: *)
(*Not loaded and automatically loaded yet.*)


(* ::Section:: *)
(*Paclet*)


(* ::Subsection:: *)
(*MakeBoxes*)


Paclet /: MakeBoxes[paclet_Paclet, _] := With[
	{
		literalName = "\"\<" <> paclet["Name"] <> "\>\"",
		literalVersion = "\"\<" <> paclet["Version"] <> "\>\"",
		literalWolframVersion = "\"\<" <> paclet["WolframVersion"] <> "\>\"",
		literalSystemID = "\"\<" <> paclet["SystemID"] <> "\>\""
	},
	InterpretationBox[
		RowBox[{"Paclet", "[", literalName, ",", literalVersion, ",", literalWolframVersion, ",", literalSystemID, ",", "<>", "]"}],
		paclet
	]
] /; AllTrue[paclet[{"Name", "Version"}], StringQ]
