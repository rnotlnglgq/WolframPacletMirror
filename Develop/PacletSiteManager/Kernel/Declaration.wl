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
$RemotePacletSite
$PartSize
$RequirementFile


(* ::Subsection:: *)
(*Encapsulation*)


`Private`Paclet
`Private`PacletObject
`Private`PacletSite


`Private`Paclet /: Format[paclet:`Private`Paclet[(_String -> _)...]] := StringTemplate["<[Type-2 Paclet: ``]>"]@ToString@GetPacletValue["QualifiedName"]@paclet


`Private`Paclet /: Format[paclet:`Private`Paclet[(_Symbol -> _)...]] := StringTemplate["<[Type-1 Paclet: ``]>"]@ToString@GetPacletValue["QualifiedName"]@PacletExpressionConvert[2]@paclet


`Private`PacletObject /: Format[paclet:_`Private`PacletObject] := StringTemplate["<[Type-3 Paclet: ``]>"]@GetPacletValue["QualifiedName"]@paclet


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
