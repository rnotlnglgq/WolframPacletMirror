(* ::Package:: *)

(* ::Title:: *)
(*PacletSiteManager*)


BeginPackage["PacletSiteManager`"]


PacletSiteManager`Private`$Test = False;


SetDirectory@If[PacletSiteManager`Private`$Test && $Notebooks,
	NotebookDirectory[],
	DirectoryName@$InputFileName
];

<< Declaration.wl;

Begin["`Private`"]
	Get /@ FileNames["*.wl", "Definitions"];
End[]

ResetDirectory[];


EndPackage[]
