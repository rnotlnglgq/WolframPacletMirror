#!/usr/bin/env wolframscript
(* ::Package:: *)

localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4;
Print@"Requirement:";
Print@OutputForm@PutRequirementInfo@GetRequirementInfo@localSiteInfo
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo@localSiteInfo,
	cloudSiteInfo
];
Print@"Required:";
Print@OutputForm@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	localSiteInfo
];
Print@"Changes:";
Print@OutputForm@pacletChanges;
Print@"Result:";
Print@OutputForm@ApplyPacletChanges@pacletChanges;
