(* ::Package:: *)

(* ::Title:: *)
(*PacletMirrorClient*)


(* ::Chapter:: *)
(*Client Tools*)


BeginPackage["PacletMirrorClient`", {"PacletManager`", "GeneralUtilities`"}]


SetMirrorSites
UpdateMirrorSites
TryCatenatePaclet


Get /@ FileNames["Kernel/*.wl", DirectoryName@FindFile@"PacletMirrorClient`"];


EndPackage[]
