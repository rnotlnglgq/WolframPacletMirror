(* ::Package:: *)

(* ::Chapter:: *)
(*File Import*)


(* ::Subsection:: *)
(*Site Information*)


(* ::Code::Initialization:: *)
OriginalSiteInfo[] := With[
	{
		localInfo = SelectFirst[
			PacletManager`Services`Private`$pacletSiteData,
			StringContainsQ["pacletserver.wolfram.com"]@*First
		]
	},
	If[MissingQ@localInfo,
		PacletSite[],
		PacletSite @@ Last@localInfo //PacletDeregularize
	]
]


(* ::Code::Initialization:: *)
ThisSiteInfo[] := PacletRegularize@Import["PacletSite.mz", "PacletSite.m"]


(* ::Subsection:: *)
(*Paclet Information*)


(* ::Subsubsection:: *)
(*File names*)


(* ::Code::Initialization:: *)
PacletList[] := FileNames["*.paclet", "Paclets"]


(* ::Code::Initialization:: *)
PacletPartList[] := FileNames["*.paclet.*", "Paclets"]


(* ::Subsubsection:: *)
(*Import PacletInfo in paclets*)


(* ::Code::Initialization:: *)
GetPacletInfo[filePath_] := First@Import[filePath, StringRiffle[{"*", "PacletInfo.*"}, "/"]]
SetAttributes[GetPacletInfo, Listable]
GetPacletInfo[] := GetPacletInfo@PacletList[]


(* ::Chapter:: *)
(*File Export*)


(* ::Subsection:: *)
(*SiteInfo*)


(* ::Code::Initialization:: *)
$PacletInfoKeys = {"BackwardCompatible","BuildNumber","Category","Creator","Description","Extensions","Internal","Loading","MathematicaVersion","Name","Published","Qualifier","Root","Support","SystemID","Updating","URL","Version","WolframVersion"};
toReleaseType[paclet_Paclet] := PacletDeregularize@*Paclet@@FilterRules[List@@#, Alternatives@@$PacletInfoKeys]&@Replace[PacletRegularize@paclet, {
	(key:"PlatformQualifier" -> val_) :> ("Qualifier" -> val)
}, 1]
toReleaseType[_[paclets__Paclet]] := toReleaseType /@ PacletSite[paclets]


(* ::Code::Initialization:: *)
ExportSiteInfo[siteInfo_] := Export["PacletSite.mz", "PacletSite.m" -> toReleaseType@siteInfo, "ZIP"]
ExportSiteInfo[] := ExportSiteInfo@SiteRegularize[]


(* ::Code::Initialization:: *)
BuildSiteInfo[] := (
	CatenateParts[];
	ExportSiteInfo[];
	DeleteFile/@Keys@PartsRegularize[];
	ThisSiteInfo[]
)
