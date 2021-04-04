#!/usr/bin/env wolframscript
(* ::Package:: *)

Begin@"PacletSiteManager`Private`"
Clear@PacletSiteManager`ApplyPacletChanges
PacletSiteManager`ApplyPacletChanges[
Pattern[changes, 
Blank[Association]]] := Module[
  	{
   		add = Function[#Add][changes],
   		remove = Function[#Remove][changes],
   		valid = {}
   	},
  	Map[
   		Function[
    			With[{fileName = 
       PacletSiteManager`GetPacletValue["FileName"][#]},
     				PacletSiteManager`DownloadPaclet @ #;
Print@FileNames[];
Print@Get@"!ps -ef";
     				If[PacletSiteManager`ValidPacletFileQ[fileName],
      					
      CopyFile[fileName, 
       PacletSiteManager`Private`makePacletPath @ fileName, 
       OverwriteTarget -> True];
      					DeleteFile @ fileName;
      					AppendTo[valid, #],
      					DeleteFile @ fileName;
      					
      Message[PacletSiteManager`ApplyPacletChanges::invalidfile, 
       fileName];
      					Return[
       						Failure[
        							"InvalidFile",
        							<|
         								
         "MessageTemplate" -> \
(PacletSiteManager`ApplyPacletChanges::invalidfile),
         								
         "MessageParameters" -> <|"FileName" -> fileName, 
           "ValidPaclets" -> StringRiffle[valid]|>
         							|>
        						]
       					]
      				]
     			]
    		],
   		add
   	];
  	Map[
   		Function @ 
    DeleteFile @ 
     FileNames[
      StringJoin[PacletSiteManager`GetPacletValue["FileName"][#], 
       "*"], "Paclets"],
   		remove
   	];
  	changes
  ]
End[]

readme = StringRiffle[StringTemplate["* ``\n\t* ``"]@@@Normal@GetRequirementInfo[], "\n"];
Export["README.MD", readme, "String"];
requiredPaclet = ListRequiredPaclet[
	GetRequirementInfo[],
	GetSiteInfo@4
];
Print@"\nRequired:";
Print@ToString@requiredPaclet;
pacletChanges = ListPacletChanges[
	requiredPaclet,
	GetSiteInfo@2
];
Print@"\nChanges:";
Print@ToString@pacletChanges;
Print@"\nApplyResult:";
Print@ToString@ApplyPacletChanges@pacletChanges;
Print@"\nSiteInfo:";
Print@ToString@PutSiteInfo[];
Print@"\nSplitResult:";
Print@ToString@SplitPaclet[];
DeleteFile@Keys@PartsRegularize[];
