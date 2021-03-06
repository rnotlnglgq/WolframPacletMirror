(* ::Package:: *)

(* ::Chapter:: *)
(*File Import*)


(* ::Subsection:: *)
(*Blocked Import*)


BlockedImport[args___] := WithContext["PacletSiteManager`Private`", Import@args]


BlockedExport[args___] := WithContext["PacletSiteManager`Private`", Export@args]


(* ::Subsection:: *)
(*Site Information*)


(* ::Text:: *)
(*Cloud: Last fetch*)


GetSiteInfo[1] := With[
	{
		info = SelectFirst[
			PacletManager`Services`Private`$pacletSiteData,
			StringContainsQ["pacletserver.wolfram.com"]@*First
		]
	},
	If[MissingQ@info,
		PacletSite[],
		PacletSite @@ PacletExpressionConvert[2] /@ Last@info
	]
]


(* ::Text:: *)
(*Local: Directory[]*)


GetSiteInfo[2] := PacletExpressionConvert[2] /@ BlockedImport["PacletSite.mz", {"ZIP", "PacletSite.m"}]


(* ::Subsection:: *)
(*Paclet Information*)


(* ::Subsubsection:: *)
(*File names*)


PacletList[] := FileNames["*.paclet", "Paclets"]


PacletPartList[] := FileNames["*.paclet.*", "Paclets"]


(* ::Subsubsection:: *)
(*Import PacletInfo in paclets*)


GetPacletInfo[filePath_] := First@BlockedImport[filePath, StringRiffle[{"*", "PacletInfo.*"}, "/"]]
SetAttributes[GetPacletInfo, Listable]
GetPacletInfo[] := GetPacletInfo@PacletList[]


(* ::Chapter:: *)
(*File Export*)


(* ::Subsection:: *)
(*SiteInfo*)


PutSiteInfo[siteInfo_] := BlockedExport["PacletSite.mz",
	"PacletSite.m" -> PacletSiteManager`Private`PacletSite @@ PacletExpressionConvert[0] /@ siteInfo
, "ZIP"]
PutSiteInfo[] := PutSiteInfo@SiteRegularize[]
