(* ::Package:: *)

(* ::Chapter:: *)
(*PacletSearch*)


(* ::Text:: *)
(*These functions will return regularized paclet expressions.*)


(* ::Subsection:: *)
(*Grouping*)


groupByDepth = GroupBy[Length@Keys@# - 1 &]@*Normal;

crossPlatformQ = GetPacletValue[{"SystemID", "Qualifier"}]@# === {All, ""} &;

splitSeriesName = KeyMap[StringSplit[#, "_"]&];

buildTreeByNameAndPlatform = MapIndexed[
	If[#2[[1,1]],
		GroupByValue["Name"]@#,
		Normal@*GroupByValue[{"SystemID", "Qualifier"}] /@ GroupByValue["Name"]@#
	]&,
	GroupBy[crossPlatformQ]@*List@@SiteRegularize@#
] &;


BuildTreeBySeries[siteInfo:_[__Paclet]] := Catenate[
	Nest[
		Normal@*GroupBy @ Most@*Keys,
		#2,
		#1
	]&@@@Normal@groupByDepth@splitSeriesName@#
]& /@ buildTreeByNameAndPlatform@siteInfo
BuildTreeBySeries[] := BuildTreeBySeries@GetSiteInfo@1;


(* ::Subsection:: *)
(*Version Matching*)


$VersionStringComplete = StringRiffle[#, "."]&@{
	If[StringMatchQ[#, "*."], # <> "0", #]&@ToString@$VersionNumber,
	ToString@$ReleaseNumber,
	ToString@$MinorReleaseNumber
}


(* ::Text:: *)
(*Accept: Paclet*)


(*
	PacletManager`Package`kernelVersionMatches
		PacletManager`Utils`Private`storeInCache
*)
KernelVersionMatchQ[spec_String][version_String] := Which[
	StringMatchQ["*,*"]@spec,
		AnyTrue[
			StringSplit[spec, ","],
			KernelVersionMatchQ[#][version] &
		],
	StringMatchQ["*+"]@spec,
		FromDigits/@StringSplit[#, "."]&/@{StringDrop[spec, -1], version} //OrderedQ@*PadRight,
	StringMatchQ["*-"]@spec,
		FromDigits/@StringSplit[#, "."]&/@{version, StringDrop[spec, -1]} //OrderedQ@*PadRight,
	True,
		And@@Replace[
			Transpose@PadRight[StringSplit[#, "."]&/@{version, spec}, Automatic, "*"],
			{
				{_, "*"} -> True,
				{"*", y_} :> FromDigits@y === 0,
				{x_, y_} :> FromDigits@x === FromDigits@y
			},
			1
		]
]
KernelVersionMatchQ[paclet_Paclet][version_String] := KernelVersionMatchQ[GetPacletValue["WolframVersion"]@PacletExpressionConvert[2]@paclet]@version
KernelVersionMatchQ[spec_String][All] := True
KernelVersionMatchQ[paclet_Paclet][All] := True


(* ::Subsection:: *)
(*Search*)


PacletQuery[partSpec:{___String}:{}, OptionsPattern@{"SiteInfo" -> Hold@GetSiteInfo@1}] := Fold[
	Query[Key@#2]@<|#1|>&,(* Catenate Cases Rule *)
	#,
	Flatten@*List /@ FoldList[List, partSpec](* Map Take Range Length*)
]& /@ BuildTreeBySeries@ReleaseHold@OptionValue@"SiteInfo"
PacletQuery[partSpec_String, opts:OptionsPattern[]] := PacletQuery[StringSplit[partSpec, "_"], opts]


(* ::Text:: *)
(*Platform Compatibility Test Not Implemented !*)


getNewestCompatible[version_][_[paclets__Paclet]] := SelectFirst[{paclets}, KernelVersionMatchQ[#][version] &, Nothing]


PacletSearch[partSpec:{___String}|_String:{}, OptionsPattern[]] := Cases[
	PacletQuery[partSpec, "SiteInfo" -> ReleaseHold@OptionValue@"SiteInfo"],
	paclets:{__Paclet} :> getNewestCompatible[OptionValue@"KernelVer"]@paclets
, Infinity]
Options[PacletSearch] = {"SiteInfo" -> Hold@OriginalSiteInfo[], "KernelVer" -> $VersionStringComplete};
