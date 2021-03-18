#!/usr/bin/env wolframscript
(* ::Package:: *)

Print@"\nParts:";
Print@ToString@CatenateParts[];
DeleteFile@PacletPartList[];
localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4;
Print@"\nRequirement:";
requirement = {All, "12.0.0.0"}& /@ GetRequirementInfo@localSiteInfo;
Print@ToString@PutRequirementInfo@requirement;
readme = "```mathematica\n"<>ExportString[List@@@Normal@GetRequirementInfo[], "TSV"]<>"\n```";
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
