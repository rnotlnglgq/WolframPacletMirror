(* ::Package:: *)

(* ::Chapter:: *)
(*Download*)


(* PacletManager`Package`PgetQualifiedName *)
(* Paclet[___]["QualifiedName"] *)

pacletToFileName[paclet_Paclet] := getPacletInfo["QualifiedName"]@paclet <> ".paclet"
SetAttributes[pacletToFileName, Listable]

$UseMirror = False;

(* PacletManager`Services`Private`$wriPacletServerIndex *)
fileNameToURL[fileName_String] := URLBuild@{
	If[$UseMirror, "https://wolframpaclet.wolframpaclet.workers.dev", "http://pacletserver2.wolfram.com"],
	"Paclets",
	URLEncode@fileName
};
SetAttributes[fileNameToURL, Listable]


(* ::Subsubsection:: *)
(*Request*)


(* ::Text:: *)
(*Note: your $ActivationKey should be valid to access the server.*)


DownloadRequest[fileName_String] := HTTPRequest[
	fileNameToURL@fileName,
	<|
		"Headers" -> {
			"Mathematica-systemID" -> $SystemID,
			"Mathematica-license" -> $LicenseID,
			"Mathematica-mathID" -> $MachineID,
			"Mathematica-language" -> $Language,
			"Mathematica-activationKey" -> $ActivationKey
		},
		"UserAgent" -> PacletManager`Package`$userAgent
	|>
];
DownloadRequest[] := DownloadRequest[""]


(* ::Subsubsection:: *)
(*wget Header*)


requestHeader := ExportString[
	DownloadRequest[],
	"HTTPRequest"
] //StringSplit[#, "\n"][[3;;]]&;
wgetHeader := StringTemplate["--header=\"``\""]/@requestHeader //StringRiffle


(* ::Subsubsection:: *)
(*wget URL input*)


ExportURLList[pacletNames:{__String}, urlFileName_:"url.txt"] := Export[urlFileName, StringRiffle[fileNameToURL@pacletNames, "\n"], "Text"]
ExportURLList[paclets:_[__Paclet], urlFileName_:"url.txt"] := ExportURLList[pacletToFileName@paclets, urlFileName]


(* ::Subsubsection:: *)
(*Download command*)


DownloadCommand[] := StringTemplate["wget `` -i ``"][wgetHeader, "url.txt"]


(* ::Subsubsection:: *)
(*Lazy Tool*)


DownloadPaclet[paclets:_[__Paclet]] := (
	paclets //ExportURLList;
	"!"<>DownloadCommand[] //Get
)
DownloadPaclet[single_Paclet] := DownloadPaclet@{single}
DownloadPaclet[partSpec:{___String}|_String, opts:OptionsPattern[]] := DownloadPaclet@PacletSearch[partSpec, opts]
DownloadPaclet[] := DownloadPaclet@{}
(* TODO(?): The url.txt can be in a temporary dir. *)


(* ::Chapter:: *)
(*Update Paclets*)


(* ::Text:: *)
(*The "KernelVer" option is default to be All instead of $VersionStringComplete.*)


(* ::Subsubsection:: *)
(*Fetch Newest SiteInfo*)


NewestSiteInfo[] := (
	PacletSiteUpdate@PacletSite["http://pacletserver.wolfram.com", "Wolfram Research Paclet Server", "Local" -> False];
	OriginalSiteInfo[]
);


(* ::Subsubsection:: *)
(*Find Newest Paclet*)


(* ::Text:: *)
(*RepeatedTiming: 0.354 (slow)*)


(* ::Text:: *)
(*\:9700\:4ed4\:7ec6\:8003\:8651\:53ef\:80fd\:51fa\:73b0\:7684\:60c5\:51b5*)


(* related: PacletNewerQ *)
NewestPaclet[_[paclets__Paclet], OptionsPattern[{"KernelVer" -> All, "SiteInfo" :> OriginalSiteInfo[]}]] := With[
	{
		regPacletList = List@@SiteRegularize@PacletRegularize@{paclets},
		regSite = List@@SiteRegularize@PacletRegularize@OptionValue@"SiteInfo"
	},
	Function[{paclet},
		SelectFirst[
			regSite,
			And[
				KernelVersionMatchQ[getPacletInfo["WolframVersion"]@#]@OptionValue@"KernelVer",
				!OrderedQ@PadRight[getVersionNumbers /@ {#, paclet}],
				SameQ @@ getPacletInfo[{"Name", "Qualifier", "SystemID"}] /@ {#, paclet}
			] &,
			Nothing
		] //If[# === Nothing,
			Nothing,
			paclet -> #
		]&
	] /@ regPacletList
]
NewestPaclet[paclet_Paclet, opts:OptionsPattern[]] := SafeFirst@NewestPaclet[{paclet}, opts]
NewestPaclet[opts:OptionsPattern[]] := NewestPaclet[ThisSiteInfo[], opts]


(* ::Subsubsection:: *)
(*Pick needed paclets*)


PickNewestPaclet[paclets:{(_Paclet -> _Paclet)..}] := With[
	{
		thisSite = getPacletInfo[{"Name", "Version", "Qualifier", "SystemID"}] /@ ThisSiteInfo[]
	},
	If[MemberQ[getPacletInfo[{"Name", "Version", "Qualifier", "SystemID"}]@Values@#]@thisSite, Nothing, #]&/@DeleteDuplicatesBy[Values]@paclets
]


(* ::Subsubsection:: *)
(*Update Specified Paclets*)


ValidPacletQ[expr_] := Head@expr === Paclet; (* Need to be better *)

ValidPacletFileQ[file_] := ValidPacletQ@GetPacletInfo@file;

makePacletPath = FileNameJoin@{"Paclets", #} &;


UpdatePaclet::invalidfile = "File `` is not a valid paclet.";
UpdatePaclet[old_Paclet -> new_Paclet] := Catch@With[
	{
		oldFileName = pacletToFileName@old,
		newFileName = pacletToFileName@new
	},
	DownloadPaclet@new;
	
	If[ValidPacletFileQ@newFileName,
		(
			CopyFile[newFileName, makePacletPath@newFileName, OverwriteTarget -> True];
			DeleteFile@newFileName;
			DeleteFile@FileNames[oldFileName<>"*", "Paclets"];
			SplitPaclet@makePacletPath@newFileName;
			PacletRegularize@new
		),
		(
			DeleteFile@newFileName;
			Message[UpdatePaclet::invalidfile, new];
			$Failed
		)
	]
]


UpdatePaclet[paclets:_[(_Paclet -> _Paclet)..]] := UpdatePaclet /@ paclets


UpdatePaclet[paclets:_[__Paclet], opts:OptionsPattern[]] := UpdatePaclet@PickNewestPaclet@NewestPaclet[paclets, opts]


UpdatePaclet[opts:OptionsPattern[]] := UpdatePaclet[ThisSiteInfo[], opts]
