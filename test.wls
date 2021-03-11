#!/usr/bin/env wolframscript
(* ::Package:: *)

localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4;
Print@"Requirement:";
Print@PutRequirementInfo@GetRequirementInfo@localSiteInfo
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo@localSiteInfo,
	cloudSiteInfo
];
Print@"Required:";
Print@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	localSiteInfo
];
Print@"Changes:";
Print@pacletChanges;
Print@"Result:";
Print@ApplyPacletChanges@pacletChanges;
