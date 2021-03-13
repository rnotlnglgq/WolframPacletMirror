(* ::Package:: *)

(* ::Chapter:: *)
(*Modify PacletManager*)


(* ::Subsection:: *)
(*Call TryCatenatePaclet*)


Begin["PacletManager`Manager`Private`"]


finishInstall[downloadTask_AsynchronousTaskObject] := Module[{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString, msgLines},
	{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString} = Part[PacletManager`Package`getTaskData @ downloadTask, {1, 2, 3, 6, 7}];
	PacletManager`Package`freeTaskData @ downloadTask;
	Catch[
		If[PacletManager`Package`isNetworkSuccess[pacletSite, statusCode],
			Throw[pacletFile, "DownloadFinished"]
		];
		statusCode = If[statusCode === 404,
			PacletMirrorClient`TryCatenatePaclet[
				StringJoin[pacletSite, "/Paclets/", pacletQualifiedName, ".paclet"],
				pacletFile
			](* This may Throw "DownloadFinished", too. *)
		];
		If[
			Unequal[errorString, ""],
			msgLines = {"Network error", errorString},
			msgLines = {PacletManager`Package`errorStringFromHTTPStatusCode @ statusCode, ""}
		];
		Message[PacletManager`PacletInstall::dwnld, pacletQualifiedName, pacletSite, Sequence @@ msgLines];
		$Failed
	, "DownloadFinished"] //Function[
		If[$FrontEnd =!= Null, PacletMirrorClient`Private`$showPanel = False];
		Switch[#,
			_String,
				PacletManager`Manager`Private`installPacletFromFileOrURL[#, True, True],
			_,
				$Failed
		]
	]
]


End[]


(* ::Subsection:: *)
(*Reload PacletFindRemote*)


Begin["PacletManager`Private`"]


PacletManager`PacletFindRemote[pacletName:_String|All:All, opts:OptionsPattern[]] := PacletManager`PacletFindRemote[{pacletName, All}, opts];

PacletManager`PacletFindRemote[{pacletName:_String|All:All, pacletVersion:_String|All:All}, opts:OptionsPattern[]] := 
	Module[{location, matchingPaclets, site},
		If[OptionValue@"UpdateSites",
			PacletMirrorClient`SetMirrorSites[];
			PacletManager`PacletSiteUpdate /@ PacletManager`PacletSites[] //Quiet
		];
		location = OptionValue@"Location";
		If[location === All, location = _];
		matchingPaclets = Join @@ PacletManager`Package`forEach[
			site,
			Cases[PacletManager`Services`Private`getPacletSiteData[], {location, __}],
			PacletManager`Package`setLocation[
				PacletManager`Package`PCfindMatching[
					"Paclets" -> Last@site,
					"Name" -> pacletName,
					"Version" -> pacletVersion, 
					Sequence @@ DeleteCases[
						Flatten@{opts},
						("Location" -> _) | ("UpdateSites" -> _)
					]
				],
				First@site
			]
		];
		Flatten @ PacletManager`Package`groupByNameAndSortByVersion @ matchingPaclets
	]

Options[PacletManager`PacletFindRemote] = {
	"Location" -> All,
	"SystemID" -> Automatic,
	"WolframVersion" -> Automatic,
	"Extension" -> All,
	"Creator" -> All,
	"Publisher" -> All,
	"Context" -> All,
	"UpdateSites" -> False
};


End[]
