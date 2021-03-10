#!/usr/bin/env wolframscript
(* ::Package:: *)

 PackPaclet@"Develop/PacletSiteManager"


(
	CopyFile["Develop/"<>#, "Paclets/"<>#, OverwriteTarget -> True];
	CopyFile["Develop/"<>#, "latest/PacletSiteManager.paclet", OverwriteTarget -> True];
	DeleteFile["Develop/"<>#]
)&@FileNameTake@First@FileNames["PacletSiteManager*.paclet", "Paclets"]
