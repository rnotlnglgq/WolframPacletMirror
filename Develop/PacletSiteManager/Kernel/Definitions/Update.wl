(* ::Package:: *)

(* ::Title:: *)
(**)


(* ::Section:: *)
(*Requirement*)


(* ::Subsection:: *)
(*Manage requirement*)


(* ::Text:: *)
(*Note:*)
(*Requirement information won't include platform information as all paclets for different platforms will be processed together.*)
(*Several special paclets, which need to be separated to different repositories by platform information, should be processed manually.*)


(* https://www.wolfram.com/mathematica/quick-revision-history.html *)
$kernelVersionList = StringSplit@"12.2.0.0 12.1.1 12.1.0 12.0 11.3 11.2 11.1.1 11.1.0 11.0.1 11.0.0 10.4.1 10.4.0 10.3.1 10.3.0 10.2 10.1 10.0.2 10.0.1 10.0.0 9.0.1 9.0.0 8.0.4 8.0.3 8.0.2 8.0.1 8.0.0 7.0.1 7.0.0 6.0.3 6.0.2 6.0.1 6.0.0 5.2 5.1 5.0 4.2 4.1 4.0 3.0 2.2 2.1 2.0 1.2 1.0";


(* Not Implemented: Judge compatibility of 2 version specifications. . *)
GetRequirementInfo[_[paclets__`Paclet]] := SelectFirst[$kernelVersionList, KernelVersionMatchQ[#], Nothing] & /@
	ReverseSortBy[
		#,
		GetPacletValue["VersionNumber"],
		OrderedQ@*PadRight@*List
	] & /@ GroupByValue["Name"]@{paclets}

GetRequirementInfo[0] := Import["Requirement.wl", "Package"]

GetRequirementInfo[i_Integer] := GetRequirementInfo@GetSiteInfo@i

GetRequirementInfo[] := GetRequirementInfo@0


PutRequirementInfo[paclets_[__`Paclet]] := PutRequirementInfo@GetRequirementInfo@paclets

PutRequirementInfo[requirementInfo_Association] := Export["Requirement.wl", requirementInfo, "Package"]

PutRequirementInfo[i_Integer] := PutRequirementInfo@GetRequirementInfo@i


(* ::Subsection:: *)
(*Select needed*)


selectNeeded[{paclets_, versions_}] := Function[kernelVer,
	SelectFirst[paclets, KernelVersionMatchQ[#][kernelVer] &, Nothing]
] /@ ReplacePart[versions, 1 -> All]


ListRequiredPaclet[requirementInfo_Association, cloudSiteInfo_`PacletSite] := {
	SortByVersion /@ GroupByValue["Name"]@cloudSiteInfo //KeyTake[Keys@requirement],
	requirement
} //Merge[selectNeeded]

ListRequiredPaclet[requirementInfo_Association] := ListRequiredPaclet[requirementInfo, GetSiteInfo@3]

ListRequiredPaclet[] := ListRequiredPaclet@GetRequirementInfo[]


(* ::Subsection:: *)
(*Pick new*)


(* return <|"Add"\[Rule]...,"Remove"\[Rule]...|> *)


PickNewPaclet[needed_Association, localSiteInfo_`PacletSite] := {
	GroupByValue["Name"]@localSiteInfo //KeyTake[Keys@needed],
	requirement
} //Merge[selectNeeded]


(* ::Subsection:: *)
(*Download Paclets*)


(* ::Chapter:: *)
(*Update Paclets*)


(* ::Text:: *)
(*The "KernelVer" option is default to be All instead of $VersionStringComplete.*)


(* ::Subsubsection:: *)
(*Find Newest Paclet*)


(* related: PacletNewerQ *)
NewestPaclet[_[paclets__`Paclet], OptionsPattern[{"KernelVer" -> All, "SiteInfo" :> OriginalSiteInfo[]}]] := With[
	{
		regPacletList = List@@SiteRegularize@PacletRegularize@{paclets},
		regSite = List@@SiteRegularize@PacletRegularize@OptionValue@"SiteInfo"
	},
	Function[{paclet},
		SelectFirst[
			regSite,
			And[
				KernelVersionMatchQ[GetPacletValue["WolframVersion"]@#]@OptionValue@"KernelVer",
				!OrderedQ@PadRight[GetPacletValue["VersionNumber"] /@ {#, paclet}],
				SameQ @@ GetPacletValue[{"Name", "Qualifier", "SystemID"}] /@ {#, paclet}
			] &,
			Nothing
		] //Replace[p:Except@Nothing :> paclet -> p]
	] /@ regPacletList
]
NewestPaclet[paclet_Paclet, opts:OptionsPattern[]] := SafeFirst@NewestPaclet[{paclet}, opts]
NewestPaclet[opts:OptionsPattern[]] := NewestPaclet[ThisSiteInfo[], opts]


(* ::Subsubsection:: *)
(*Pick needed paclets*)


PickNewestPaclet[paclets:{(_Paclet -> _Paclet)..}] := With[
	{
		thisSite = GetPacletValue[{"Name", "Version", "Qualifier", "SystemID"}] /@ ThisSiteInfo[]
	},
	If[MemberQ[GetPacletValue[{"Name", "Version", "Qualifier", "SystemID"}]@Values@#]@thisSite, Nothing, #]&/@DeleteDuplicatesBy[Values]@paclets
]


(* ::Subsubsection:: *)
(*Update Specified Paclets*)


ValidPacletQ[expr_] := Head@expr === Paclet; (* Need to be better *)

ValidPacletFileQ[file_] := ValidPacletQ@GetPacletInfo@file;

makePacletPath = FileNameJoin@{"Paclets", #} &;


UpdatePaclet::invalidfile = "File `` is not a valid paclet.";
UpdatePaclet[old_Paclet -> new_Paclet] := Catch@With[
	{
		oldFileName = pacletToFileName@old,
		newFileName = pacletToFileName@new
	},
	DownloadPaclet@new;
	
	If[ValidPacletFileQ@newFileName,
		(
			CopyFile[newFileName, makePacletPath@newFileName, OverwriteTarget -> True];
			DeleteFile@newFileName;
			DeleteFile@FileNames[oldFileName<>"*", "Paclets"];
			SplitPaclet@makePacletPath@newFileName;
			PacletRegularize@new
		),
		(
			DeleteFile@newFileName;
			Message[UpdatePaclet::invalidfile, new];
			$Failed
		)
	]
]


UpdatePaclet[paclets:_[(_Paclet -> _Paclet)..]] := UpdatePaclet /@ paclets


UpdatePaclet[paclets:_[__Paclet], opts:OptionsPattern[]] := UpdatePaclet@PickNewestPaclet@NewestPaclet[paclets, opts]


UpdatePaclet[opts:OptionsPattern[]] := UpdatePaclet[ThisSiteInfo[], opts]
