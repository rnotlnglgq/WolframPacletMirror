#!/usr/bin/env wolframscript
(* ::Package:: *)

CatenateParts[];
localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4;
Print@"Requirement:";
Print@ToString@PutRequirementInfo[{All, "12.0.0.0"}& /@ GetRequirementInfo@localSiteInfo]
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo@localSiteInfo,
	cloudSiteInfo
];
Print@"Required:";
Print@ToString@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	localSiteInfo
];
Print@"Changes:";
Print@ToString@pacletChanges;
Print@"Result:";
Print@ToString@ApplyPacletChanges@pacletChanges;
