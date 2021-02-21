(* ::Package:: *)

(* ::Title:: *)
(*CommandLine Utilities*)


Begin["`CommandLineUtilities`"]


(* ::Chapter:: *)
(*RunProcess Utilities*)


Begin["`RunProcessUtilities`"]


SplitArgument = `Private`SplitArgument


Begin["`Private`"]


(* This works for ASCII part only *)
overflowQ = StringLength@StringJoin@# > 2000 & (* 2048 8192 2097152 *)


iterator[{{input_}, {output___}}] := {{}, {output, input}}
iterator[{{input1_, input2_, rest___}, {output___}}] /; overflowQ[input1, input2] := {{input2, rest}, {output, input1}}
iterator[{{input:PatternSequence[_, _], rest___}, {output___}}] /; !overflowQ@input := {{List@input, rest}, {output}}


SplitArgument[args:{__String}] := Flatten/@Last@NestWhile[
	iterator,
	{args, {}},
	First@# =!= {} &
]


End[]


End[]


(* ::Chapter:: *)
(*ProgressPanel*)


Begin["`ProgressPanel`"]


(* READ *)
$ProgressData := `Private`$ProgressData;


(* WRITE *)
UpdateProgressData = `Private`UpdateProgressData;


Begin["`Private`"]


$ProgressData = {None, None, None};
$PageWidth = 50;


(* ::Subsection:: *)
(*ProgressString*)


ProgressString[progress_?NumberQ] := StringJoin["Progress: |", Table["\:2588", #], Table["\:3000", $PageWidth-#], "| "]&@Floor[$PageWidth progress]


ProgressString[None] := ""


(* ::Subsection:: *)
(*UpdateProgressPanel*)


UpdateProgressData[summary_, detail_, progress_] := UpdateProgressData@{summary, detail, progress}


UpdateProgressData[panel:{_, _, _}] := UpdateProgressData[$ProgressData, panel]


UpdateProgressData[old_, new_List?(MemberQ[Inherited])] := UpdateProgressData@MapThread[
	If[#2 === Inherited, #1, #2] &,
	{old, new}
]


UpdateProgressData[old_, new_] := If[$FrontEnd =!= Null,
	$ProgressData = new,
	(
		printProgressUpdate[old, new];
		$ProgressData = new
	)
]


(* ::Subsubsection:: *)
(*Print the progress*)


printProgressUpdate[same:{_, _, _}, same_] := Null


printProgressUpdate[{summary_, None, None}, {summary_, detail_, progress_}] :=
	CommandLinePrint["\n", ProgressString@progress, detail]


printProgressUpdate[{summary_, oldDetail_, _}, {summary_, None, None}] :=
	CommandLinePrint["\r", StringReplace[_ :> "\b"]@oldDetail]


printProgressUpdate[{summary_, oldDetail_, _}, {summary_, newDetail_, newProgress_}] :=
	CommandLinePrint["\r", StringReplace[_ :> "\b"]@oldDetail, ##]&@@Replace[{ProgressString@newProgress, newDetail}, None -> "", 1]


printProgressUpdate[{_, _, _}, {newSummary_, None, None}] :=
	CommandLinePrint["\n\n", #]&@Replace[newSummary, None -> ""]


printProgressUpdate[{_, _, _}, {newSummary_, newDetail_, newProgress_}] :=
	CommandLinePrint["\n\n", #1, "\n", ##2]&@@Replace[{newSummary, ProgressString@newProgress, newDetail}, None -> "", 1]


(* ::Subsection:: *)
(*CommandLinePrint*)


CommandLinePrint = `Private`CommandLinePrint;


CommandLinePrint[any__] := Block[{$CharacterEncoding = $SystemCharacterEncoding},
	WriteString[$Output, any]
]


End[]


End[]


End[]
