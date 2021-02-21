(* ::Package:: *)

(* ::Chapter:: *)
(*PacletSearch*)


(* ::Text:: *)
(*These functions will return regularized paclet expressions.*)


(* ::Subsection:: *)
(*Grouping*)


groupByDepth = GroupBy[Length@Keys@# - 1 &]@*Normal;

groupByPlatform = GroupBy[
	#,
	getPacletInfo[{"SystemID", "Qualifier"}]
]&;

crossPlatformQ = getPacletInfo[{"SystemID", "Qualifier"}]@# === {All, ""} &;

splitSeriesName = KeyMap[StringSplit[#, "_"]&];


PacletSeriesRegularize[siteInfo:_[__Paclet]] := Catenate[
	Nest[
		Normal @* GroupBy[Keys[#][[;;-2]] &],
		#2,
		#1
	]&@@@Normal@groupByDepth@splitSeriesName@#
]& /@ MapIndexed[
	If[#2[[1,1]],
		GroupByName@#,
		Normal@*groupByPlatform /@ GroupByName@#
	]&,
	GroupBy[List@@PacletRegularize@SiteRegularize@siteInfo, crossPlatformQ]
]
PacletSeriesRegularize[] := PacletSeriesRegularize@OriginalSiteInfo[];


(* ::Subsection:: *)
(*Version Matching*)


$VersionStringComplete = StringRiffle[#, "."]&@{
	If[StringMatchQ[#, "*."], # <> "0", #]&@ToString@$VersionNumber,
	ToString@$ReleaseNumber,
	ToString@$MinorReleaseNumber
}


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
KernelVersionMatchQ[paclet_Paclet][version_String] := KernelVersionMatchQ[getPacletInfo["WolframVersion"]@PacletRegularize[paclet]]@version
KernelVersionMatchQ[spec_String][All] := True
KernelVersionMatchQ[paclet_Paclet][All] := True


(* ::Subsection:: *)
(*Search*)


PacletQuery[partSpec:{___String}:{}, OptionsPattern@{"SiteInfo" -> Hold@OriginalSiteInfo[]}] := Fold[
	Function[{rules, key}, 
		Catenate@Cases[rules, (key -> value_List) :> value]
	],
	#,
	Flatten@*List /@ FoldList[{##}&, partSpec]
]& /@ PacletSeriesRegularize@ReleaseHold@OptionValue@"SiteInfo"
PacletQuery[partSpec_String, opts:OptionsPattern[]] := PacletQuery[StringSplit[partSpec, "_"], opts]


(*
PacletManager`Package`kernelVersionMatches @ installedPaclet @ "WolframVersion"
PacletManager`Package`systemIDMatches @ installedPaclet @ "SystemID"
PacletManager`Package`productIDMatches @ installedPaclet @ "ProductID"
*)


(* \:53ef\:4ee5\:518d\:8003\:8651\:5e73\:53f0\:517c\:5bb9\:6027\:68c0\:9a8c *)
getNewestCompatible[version_][_[paclets__Paclet]] := SelectFirst[{paclets}, KernelVersionMatchQ[#][version] &, Nothing]


PacletSearch[partSpec:{___String}|_String:{}, OptionsPattern[]] := Cases[
	PacletQuery[partSpec, "SiteInfo" -> ReleaseHold@OptionValue@"SiteInfo"],
	paclets:{__Paclet} :> getNewestCompatible[OptionValue@"KernelVer"]@paclets
, Infinity]
Options[PacletSearch] = {"SiteInfo" -> Hold@OriginalSiteInfo[], "KernelVer" -> $VersionStringComplete};
