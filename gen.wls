#!/usr/bin/env wolframscript
(* ::Package:: *)

PackPaclet@"Develop/PacletSiteManager"

(
	CopyFile["Develop/"<>#, "Paclets/"<>#, OverwriteTarget -> True];
	CopyFile["Develop/"<>#, "latest/PacletSiteManager.paclet", OverwriteTarget -> True];
	DeleteFile["Develop/"<>#]
)&@FileNameTake@Last@FileNames["PacletSiteManager*.paclet", "Develop"]

PackPaclet@"Develop/PacletMirrorClient"

(
	CopyFile["Develop/"<>#, "Paclets/"<>#, OverwriteTarget -> True];
	CopyFile["Develop/"<>#, "latest/PacletMirrorClient.paclet", OverwriteTarget -> True];
	DeleteFile["Develop/"<>#]
)&@FileNameTake@Last@FileNames["PacletMirrorClient*.paclet", "Develop"]
