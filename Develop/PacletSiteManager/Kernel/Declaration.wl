(* ::Package:: *)

(* ::Chapter:: *)
(*Symbol Declaration*)


(*
"PacletSiteManager`Private`" ~~ "$" | "" ~~ CharacterRange["A", "Z"] ~~ ___ // Names;
StringReplace[StartOfString ~~ "PacletSiteManager`Private`" ~~ name__ ~~ EndOfString :> name] /@ %;
StringRiffle[%, "\n"]
*)


(* ::Subsection:: *)
(*Constant*)


$Downloader
$VersionStringComplete
$WolframPacletSite
$PartSize
$RequirementFile


(* ::Subsection:: *)
(*Encapsulation*)


`Private`Paclet
`Private`PacletObject
`Private`PacletSite


`Private`Paclet /: MakeBoxes[paclet:_`Private`Paclet, form_] := MakeBoxes[#, form] &@StringTemplate["[Paclet: ``]"]@ToString@GetPacletValue["QualifiedName"]@paclet


`Private`PacletObject /: MakeBoxes[paclet:_`Private`PacletObject, form_] := MakeBoxes[#, form] &@StringTemplate["[PacletObject: ``]"]@GetPacletValue["QualifiedName"]@paclet


(* ::Subsection:: *)
(*Function*)


ApplyPacletChanges
BlockedExport
BlockedImport
BuildTreeBySeries
CatenateParts
DownloadCommand
DownloadPaclet
DownloadRequest
ExportURLList
GetPacletInfo
GetPacletValue
GetRequirementInfo
GetSiteInfo
GroupByValue
KernelVersionMatchQ
ListPacletChanges
ListRequiredPaclet
PacletExpressionConvert
PacletList
PacletPartList
PacletQuery
PacletSearch
PartsRegularize
PutRequirementInfo
PutSiteInfo
SiteRegularize
SortByVersion
SplitPaclet
ValidPacletFileQ
ValidPacletQ


(*
WithContext
*)
