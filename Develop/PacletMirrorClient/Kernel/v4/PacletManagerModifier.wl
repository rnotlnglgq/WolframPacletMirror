(* ::Package:: *)

(* ::Chapter:: *)
(*Modify PacletManager*)


(* ::Subsection:: *)
(*Call TryCatenatePaclet*)


Begin["PacletManager`Manager`Private`"]


finishInstall[assoc_Association] := Module[{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString, msgLines},
	{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString} = Lookup[assoc, {"QualifiedName", "DownloadedFile", "PacletSite", "StatusCode", "ErrorString"}];
	Catch[
		If[PacletManager`Package`isNetworkSuccess[pacletSite, statusCode],
			Throw[pacletFile, "DownloadFinished"],
			statusCode = If[statusCode === 404,
				PacletMirrorClient`TryCatenatePaclet[
					StringJoin[pacletSite, "/Paclets/", pacletQualifiedName, ".paclet"],
					pacletFile
				](* This may Throw "DownloadFinished", too. *)
			];
			If[errorString != "",
				msgLines = {"Network error", errorString},
				msgLines = {PacletManager`Package`errorStringFromHTTPStatusCode[statusCode], ""}
			];
			Message[PacletInstall::dwnld, pacletQualifiedName, pacletSite, Sequence @@ msgLines];
			$Failed
		]
	, "DownloadFinished"] //Function[
		If[$FrontEnd =!= Null, PacletMirrorClient`Private`$showPanel = False];
		Switch[#,
			_String,
				PacletManager`Manager`Private`installPacletFromFileOrURL[#, ForceVersionInstall -> True, "DeletePacletFile" -> True],
			_,
				$Failed
		]
	]
];
	
finishInstall[downloadTask_AsynchronousTaskObject] :=
	Module[{taskData, pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString, installedPaclet},
		taskData = PacletManager`Package`getTaskData[downloadTask];
		{pacletQualifiedName, pacletFile, pacletSite, statusCode, errorString, installedPaclet} = taskData[[{1,2,3,6,7,9}]];
		If[PacletObjectQ[installedPaclet],
			installedPaclet,
			p = finishInstall[<|"QualifiedName" -> pacletQualifiedName, "DownloadedFile" -> pacletFile, "PacletSite" -> pacletSite, "StatusCode" -> statusCode, "ErrorString" -> errorString|>];
			PacletManager`Package`setTaskData[downloadTask, ReplacePart[taskData, 9->p]];
			p
		]
	]


End[]


(* ::Subsection:: *)
(*Reload PacletFindRemote*)


$InitialUpdate = False;


Begin["PacletManager`Service`Private`"]


$propertySelectors = <|"Location"->All, "SystemID"->Automatic, "WolframVersion"->Automatic, "ProductID"->Automatic,
                       "Extension"->All, "Loading"->All, "Creator"->All, "Publisher"->All, "Context"->All, (* Undocumented: *) "Internal"->All|>

(* PacletFindRemote is only documented to take the UpdatePacletSites option, as the documented form is to use an association of properties as the second argument.
   But for compatibility with pre-12.1 code, it still allows the properties as options.
*)
Options[PacletFindRemote] = 
    Options[PacletManager`PacletFindRemote] = 
        Join[{UpdatePacletSites -> False, "UpdateSites"->False}, Normal[$propertySelectors]]

PacletFindRemote[pacletName:(_String | All), props:_Association:<||>, opts:OptionsPattern[]] :=
    PacletFindRemote[pacletName -> All, props, opts]

PacletFindRemote[paclet_PacletObject, props:_Association:<||>, opts:OptionsPattern[]] :=
    PacletFindRemote[paclet["Name"] -> paclet["Version"], props, opts]

(* Old, undocumented form for backward compatibility only. *)
PacletFindRemote[{pacletName:(_String | All):All, pacletVersion:(_String | All):All}, props:_Association:<||>, opts:OptionsPattern[]] :=
    PacletFindRemote[pacletName -> pacletVersion, props, opts]
    
PacletFindRemote[pacletName:(_String | All) -> pacletVersion:(_String | All), props:_Association:<||>, opts:OptionsPattern[]] :=
    Module[{propSelectors, location, matchingPaclets, site},
        If[PacletMirrorClient`$InitialUpdate && OptionValue["UpdateSites"] || OptionValue[UpdatePacletSites], Quiet[SetMirrorSites[]; PacletSiteUpdate /@ PacletSites[]]];
        (* We only support use of the Association arg, or opts, not both. No attempt is made to weave together properties
           selected via the assoc and via opts.
        *)
        If[Length[props] > 0,
            propSelectors = Append[$propertySelectors, props],
        (* else *)
            propSelectors = Append[$propertySelectors, Association[Flatten[{opts}]]]
        ];
        location = propSelectors["Location"];
        If[location === All, location = _];
        If[Head[location] === PacletSiteObject, location = First[location]];
        matchingPaclets = Join @@
            PacletManager`Package`forEach[site, Cases[PacletManager`Services`Private`getPacletSiteData[], {location, __} | {_, location, __}],
                PacletManager`Package`setLocation[PacletManager`Package`PCfindMatching["Paclets" -> Last[site], "Name" -> pacletName, "Version" -> pacletVersion,
                                            DeleteCases[FilterRules[Normal[propSelectors], Options[PacletManager`Package`PCfindMatching]], "Location" -> _]],
                            First[site]
                ]
            ];
        Switch["Loading" /. propSelectors,
            Manual | "Manual",
                matchingPaclets = Select[matchingPaclets, (PacletManager`Package`getLoadingState[#] === Manual)&],
            Automatic,
                matchingPaclets = Select[matchingPaclets, (PacletManager`Package`getLoadingState[#] === Automatic)&],
            "Startup",
                matchingPaclets = Select[matchingPaclets, (PacletManager`Package`getLoadingState[#] === "Startup")&]
        ];
        Flatten[PacletManager`Package`groupByNameAndSortByVersion[matchingPaclets]]
    ]

(* If the caller leaves out the first arg (paclet name string) and just passes an association, then pull out the Name and Version to make the
   documented arg form. This def must come after the one above, so that a name->version rule in the first arg isn't seen as part of the OptionsPattern below, 
   following a missing Association.
*)
PacletFindRemote[props:_Association:<||>, opts:OptionsPattern[]] := PacletFindRemote[Lookup[props, "Name", All] -> Lookup[props, "Version", All], props, opts]


End[]
