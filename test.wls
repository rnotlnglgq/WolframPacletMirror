#!/usr/bin/env wolframscript
(* ::Package:: *)

localSiteInfo = GetSiteInfo@2;
cloudSiteInfo = GetSiteInfo@4
PutRequirementInfo@GetRequirementInfo@localSiteInfo
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo@localSiteInfo,
	cloudSiteInfo
];
Print@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	localSiteInfo
];
Print@pacletChanges;
ApplyPacletChanges@pacletChanges;
