(* ::Package:: *)

Begin["`Private`"]


(* ::Subsection:: *)
(*Define TryCatenatePaclet*)


TryCatenatePaclet[remotePrefix_, localPrefix_] := (
	PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData@{
		"Paclet file not found. Attempting to find paclet parts...",
		"Finding the head of parts...",
		None
	};
	If[$FrontEnd =!= Null,
		$showPanel = True;
		CellPrint@Cell[
			BoxData@ToBoxes@Dynamic[
				If[$showPanel === False, NotebookDelete@EvaluationCell[]];
				GeneralUtilities`ProgressPanel@@PacletMirrorClient`CommandLineUtilities`ProgressPanel`$ProgressData
			]
		, "PrintTemporary"]
	];
	Quiet[Check[
		gitMirrorHandler[remotePrefix, localPrefix],
		genericMirrorHander[remotePrefix, localPrefix]
	, {gitMirrorHandler::notgit}], {gitMirrorHandler::notgit}];
)


gitMirrorHandler::notgit = "No supported git tree page found.";


getPathFromGitee[url_, keyword_] := Cases[
	Import[url, "XMLObject"],
	XMLElement[
		"div",
		List@OrderlessPatternSequence["data-path" -> path_?(StringContainsQ[keyword]), ___],
		_
	] :> FileNameTake@path
, Infinity]

getPathFromGithub[url_, keyword_] := Cases[
	Import[url, "XMLObject"],
	XMLElement[
		"a",
		List@OrderlessPatternSequence["class" -> "js-navigation-open", "title" -> path_?(StringContainsQ[keyword]), "href" -> _, ___],
		{path_}
	] :> FileNameTake@path
, Infinity]

getPathFromTree[url_, keyword_] := Which[
	StringContainsQ["gitee.com"]@url, getPathFromGitee[url, keyword],
	StringContainsQ["github.com"]@url, getPathFromGithub[url, keyword],
	True, Message@gitMirrorHandler::notgit
]

gitMirrorHandler[remotePrefix_, localPrefix_] := Catch[With[
	{
		remoteTree = URLBuild@MapAt[
			Replace[Most@#, "raw" :> "tree", 1] &,
			URLParse@remotePrefix,
			"Path"
		],
		remoteDir = URLBuild@MapAt[
			Most,
			URLParse@remotePrefix,
			"Path"
		],
		remoteFile = Last@URLParse[remotePrefix]["Path"]
	},
	If[!MemberQ["tree"]@URLParse[remoteTree]["Path"], Message@gitMirrorHandler::notgit];
	$partNameList = getPathFromTree[remoteTree, remoteFile];
	If[!MatchQ[{__String?(StringContainsQ[remoteFile])}]@$partNameList, Message@gitMirrorHandler::notgit];
	$total = Length@$partNameList;
	PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData[
		"Parts found. Downloading...",
		None,
		None
	];
	Do[
		(
			$statusCode = URLDownload[
				URLBuild@{remoteDir, #},
				FileNameJoin@{DirectoryName@localPrefix, #}
			, "StatusCode"]&@$partNameList[[i]];
			PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData[
				Inherited,
				ToString/@{i, $total} //StringRiffle[#, "/"]&,
				i/$total
			];
		),
		{i, $total}
	];
	callCatenate[
		remotePrefix,
		localPrefix,
		$partNameList
	]
]
, "DownloadFailed"]


$maxPostfixLength = 3;

numToPostfix[num_Integer?NonNegative, length_Integer?NonNegative] := "." <> IntegerString[num, 10, length]
numToPostfix[num_] := numToPostfix[num, $currentPostfixLength]

genericMirrorHander[remotePrefix_, localPrefix_] := Catch[
	$currentPostfixLength = 1;
	Catch[
		While[$currentPostfixLength <= $maxPostfixLength,
			If[URLDownload[remotePrefix <> numToPostfix@0, localPrefix <> numToPostfix@0, "StatusCode"] === 404,
				(
					DeleteFile[localPrefix <> numToPostfix@0];
					$currentPostfixLength += 1
				),
				Throw["ValidPostfixLength" -> $currentPostfixLength, "PartFound"]
			]
		];
		Throw[$Failed, "PartNotFound"]
	, "PartFound"];
	PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData[
		"Head of parts found. Downloading...",
		"This paclet server is not a git directory, the progress will be obviously underestimated.",
		0
	];
	Module[{num = 1},
		While[URLDownload[remotePrefix <> numToPostfix@num, localPrefix <> numToPostfix@num, "StatusCode"] =!= 404,
			PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData[
				Inherited,
				Inherited,
				num Power[10, -$currentPostfixLength]
			];
			num += 1
		];
		DeleteFile[localPrefix <> numToPostfix@num];
		callCatenate[
			remotePrefix,
			localPrefix,
			FileNameTake@localPrefix <> numToPostfix@# & /@ Range[0, num-1]
		];
	]
, "PartNotFound"]


(* ::Subsubsection:: *)
(*Download*)


(*
callDownload
URLSaveAsynchronous
If wget/curl exists, use it
*)


(* ::Subsubsection:: *)
(*Catenate*)


(* CheckAbort *)


(* ::Text:: *)
(*StartProcess \:4e0d\:7b49\:5f85\:6307\:4ee4\:5b8c\:6210\:ff0c\:8fd9\:662f\:4e00\:4e2a\:95ee\:9898\:3002\:65b9\:6848\:6709\:4e8c\:ff1a\:4e00\:662f\:5229\:7528ExitCode\:ff0c\:7f3a\:70b9\:662f\:8981\:5f00\:542f\:591a\:4e2a\:8fdb\:7a0b\:6548\:7387\:8f83\:4f4e\:ff1b\:4e8c\:662fecho\:4e00\:4e2aUUID\:7136\:540e\:68c0\:6d4b\:5176\:662f\:5426\:5728\:9002\:5f53\:4f4d\:7f6e\:88ab\:8f93\:51fa\:3002*)


runQueued[commands:{__String}] := Module[
	{
		process
	},
	Do[
		process = StartProcess@$SystemShell;
		Pause[0.2];
		WriteLine[process, StringRiffle@{command, "&&", "exit"}];
		While@ProcessStatus[process, "Running"];
	, {command, commands}];
]


callCatenate[remotePrefix_, targetPath_, sourceFileNameList_] := (
	PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData["Download complete. Catenating...", None, None];
	SetDirectory@DirectoryName@targetPath;
	DeleteFile@targetPath;
	With[
		{
			catAvailable = Quiet[Check[
				RunProcess@{"cat", "--help"};True,
				False
			, {RunProcess::pnfd}], {RunProcess::pnfd}]
		},
		If[catAvailable,
			StringRiffle@{"cat", ##, ">>", targetPath}&@@@PacletMirrorClient`CommandLineUtilities`RunProcessUtilities`SplitArgument@sourceFileNameList //runQueued,
			StringRiffle@{"type", ##, ">>", targetPath}&@@@PacletMirrorClient`CommandLineUtilities`RunProcessUtilities`SplitArgument@sourceFileNameList //runQueued
		]
	];
	finishCatenate[remotePrefix, targetPath, sourceFileNameList];
	ResetDirectory[];
)


finishCatenate[remotePrefix_, targetPath_, sourceFileNameList_] := (
	PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData["Catenation complete. Verifying...", None, None];
	If[Quiet@VerifyPaclet@targetPath,
		(
			PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData["Verification passed. Installing...", None, None];
			DeleteFile@sourceFileNameList;
			ResetDirectory[];
			Throw[targetPath, "DownloadFinished"]
		),
		(
			PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData["Verification failed. Trying to re-download suspicious parts...", None, None];
			DeleteFile /@ Catenate@Values@Most@SortBy[Length]@GroupBy[FileByteCount]@Select[FileExistsQ]@sourceFileNameList;
			$suspiciousParts = Select[Not@*FileExistsQ]@sourceFileNameList;
			$total2 = Length@$suspiciousParts;
			Do[
				PacletMirrorClient`CommandLineUtilities`ProgressPanel`UpdateProgressData[
					Inherited,
					ToString/@{i, $total2} //StringRiffle[#, "/"]&,
					i/$total2
				];
				If[FileExistsQ@#, DeleteFile@#]&@$suspiciousParts[[i]];
				<< CURLLink`;
				URLDownload[URLBuild@{URLBuild@MapAt[Most, URLParse@remotePrefix, "Path"], FileNameTake@$suspiciousParts[[i]]}, $suspiciousParts[[i]], "StatusCode"]
			, {i, $total2}];
			callCatenate[remotePrefix, targetPath, sourceFileNameList]
		)
	];
	
)


End[]
