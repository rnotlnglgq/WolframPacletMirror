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
(*Local: Load from Directory[]*)


GetSiteInfo[1] := PacletExpressionConvert[2] /@ BlockedImport["PacletSite.mz", {"ZIP", "PacletSite.m"}]


(* ::Text:: *)
(*Local: Fetch now*)


GetSiteInfo[2] := `PacletSite @@ PacletExpressionConvert[2]@*GetPacletInfo /@ PacletList[]


(* ::Text:: *)
(*Cloud: Load from cache*)


GetSiteInfo[3] := With[
	{
		info = SelectFirst[
			PacletManager`Services`Private`$pacletSiteData,
			StringContainsQ["pacletserver.wolfram.com"]@*First
		]
	},
	If[MissingQ@info,
		`PacletSite[],
		`PacletSite @@ PacletExpressionConvert[2] /@ (Last@info /. {System`Paclet -> `Paclet, System`PacletObject -> `PacletObject})
	]
]


(* ::Text:: *)
(*Cloud: Fetch now*)


GetSiteInfo[4] := PacletExpressionConvert[2] /@ BlockedImport["http://pacletserver.wolfram.com/PacletSite.mz", {"ZIP", "PacletSite.m"}]


(* ::Subsection:: *)
(*Paclet Information*)


(* ::Subsubsection:: *)
(*File names*)


PacletList[] := FileNames["*.paclet", "Paclets"]


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
	"PacletSite.m" -> `PacletSite @@ PacletExpressionConvert[0] /@ siteInfo
, "ZIP"]
PutSiteInfo[i_Integer] := PutSiteInfo@SiteRegularize@GetSiteInfo@i
PutSiteInfo[] := PutSiteInfo@2
