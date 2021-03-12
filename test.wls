#!/usr/bin/env wolframscript
(* ::Package:: *)

Print@"\nParts:";
Print@ToString@CatenateParts[];
DeleteFile@PartsRegularize[];
localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4;
Print@"\nRequirement:";
Print@ToString@PutRequirementInfo[{All, "12.0.0.0"}& /@ GetRequirementInfo@localSiteInfo]
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo@localSiteInfo,
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
DeleteFile@PartsRegularize[];
