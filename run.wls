#!/usr/bin/env wolframscript
(* ::Package:: *)

readme = StringRiffle[StringTemplate["* ``\n\t* ``"]@@@Normal@GetRequirementInfo[], "\n"];
Export["README.MD", readme, "String"];
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo[],
	GetSiteInfo@4
];
Print@"\nRequired:";
Print@ToString@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	GetSiteInfo@2
];
Print@"\nChanges:";
Print@ToString@pacletChanges;
Print@"\nApplyResult:";
Print@ToString@ApplyPacletChanges@pacletChanges;
Print@"\nSiteInfo:";
Print@ToString@PutSiteInfo[];
Print@"\nSplitResult:";
Print@ToString@SplitPaclet[];
DeleteFile@Keys@PartsRegularize[];
