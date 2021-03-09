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
		(* You must not create symbol System`Paclet. That will redirect PacletManager`Private`Paclet to the one you've created, which make that related functions fail. *)
		`PacletSite @@ PacletExpressionConvert[2] /@ Replace[Last@info,
			{h_@s___ /; {Context@h,SymbolName@h}==={"System`","Paclet"} :> `Paclet@s, h_@s___ /; {Context@h,SymbolName@h}==={"System`","PacletObject"} :> `PacletObject@s}
		, 1]
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
