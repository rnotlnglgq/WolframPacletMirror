(* ::Package:: *)

(* ::Chapter:: *)
(*Split and Catenate*)


(* ::Subsection:: *)
(*Paclet Parts*)


(* ::Subsubsection:: *)
(*Parts regularization*)


(* Assertion for the First[{}] situation? *)
groupParts[partPaths_] := GroupBy[
	partPaths,
	First@*StringCases[fileBaseName__~~".paclet."~~__ :> fileBaseName~~".paclet"]
]

PartsRegularize[fileNameList_] := Sort /@ groupParts@fileNameList //Normal
PartsRegularize[] := PartsRegularize@PacletPartList[]


(* ::Subsubsection:: *)
(*Catenate*)


CatenateParts[pacletFilePath_ -> {partFilePaths__}] := Replace[0 -> FileBaseName@pacletFilePath]@Run@StringRiffle@{"cat", partFilePaths, ">", pacletFilePath}
SetAttributes[CatenateParts, Listable]
CatenateParts[] := CatenateParts@PartsRegularize[]


(* ::Subsubsection:: *)
(*Split*)


getPartsNumber[file_] := FileByteCount@file/1024000 //Floor

SplitPaclet[pacletFilePath_] := If[# > 0,
	Replace[0 -> FileBaseName@pacletFilePath]@Run@StringRiffle@{"split", "-b", "1000K", pacletFilePath, "-d", "-a", ToString@IntegerLength@#, pacletFilePath<>"."},
	FileBaseName@pacletFilePath
]&@getPartsNumber@pacletFilePath
SetAttributes[SplitPaclet, Listable]
SplitPaclet[] := SplitPaclet@PacletList[]
