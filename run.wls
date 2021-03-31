#!/usr/bin/env wolframscript
(* ::Package:: *)

readme = StringRiffle[StringTemplate["* ``\n\t* ``"]@@@Normal@GetRequirementInfo[], "\n"];
Export["README.MD", readme, "String"];
requiredPaclet = ListRequiredPaclet[
	requirement,
	cloudSiteInfo
];
Print@"\nRequired:";
Print@ToString@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	localSiteInfo
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
