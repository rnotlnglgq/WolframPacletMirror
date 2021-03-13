(* ::Package:: *)

(* ::Title:: *)
(*PacletMirrorClient*)


(* ::Chapter:: *)
(*Client Tools*)


BeginPackage["PacletMirrorClient`", {"PacletManager`", "GeneralUtilities`"}]


SetMirrorSites
UpdateMirrorSites
TryCatenatePaclet


PackageLoader::nosup = "Support for `1` is not implemented."


SetDirectory@FileNameJoin@{DirectoryName@FindFile@"PacletMirrorClient`", "Kernel"}

<< CommandLineUtilities.wl
<< PartDownloader.wl
Catch[
	Switch[#,
		"3.0.0",
			SetDirectory@"v3",
		"4.0.0"|"5.0.0",
			SetDirectory@"v4",
		_,
			Throw@Message[PackageLoader::nosup, "PacletManager " <> #]
	]&@First[PacletFind@"PacletManager"]["Version"];
	<< UserTools.wl;
	<< PacletManagerModifier.wl;
	ResetDirectory[]
]
ResetDirectory[]


EndPackage[]
