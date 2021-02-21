(* ::Package:: *)

(* ::Chapter:: *)
(*Expression Parse*)


(* ::Subsection:: *)
(*Paclet*)


(* ::Subsubsection:: *)
(*Paclet regularization*)


(* ::Code::Initialization:: *)
PacletRegularize[paclet_Paclet] := paclet /. (key_Symbol -> value_) :> (SymbolName@key -> value)
PacletRegularize[paclets:_[__Paclet]] := PacletRegularize /@ paclets


(* ::Code::Initialization:: *)
PacletDeregularize[paclet_Paclet] := paclet /. (key_String -> value_) :> (Symbol@key -> value)
PacletDeregularize[paclets:_[__Paclet|__PacletObject]] := PacletDeregularize /@ paclets


(* ::Subsection:: *)
(*PacletSite*)


(* ::Subsubsection:: *)
(*PacletSite regularization*)


(* ::Text:: *)
(*This function returns de-regularized paclet expressions!*)


(* ::Code::Initialization:: *)
(* PacletManager`Package`groupByNameAndSortByVersion *)
GroupByName[_[paclets___Paclet]] := GroupBy[
	{paclets},
	getPacletValue["Name"]@PacletRegularize[#] &
]


(* ::Text:: *)
(*Lazy to write another PacletManager`Package`getPIValue, just copy it:*)


(* ::Code::Initialization:: *)
getPacletValue[fields_][paclet_Paclet] := getPacletValue[paclet, fields]

getPacletValue[paclet_Paclet, field_String] := field /. (List @@ paclet) /. $piDefaults /. field->Null
getPacletValue[paclet_Paclet, fields:{__String}] := fields /. (List @@ paclet) /. $piDefaults /. Thread[fields->Null]
(* Separate rules for "Extensions" because replacing with $piDefaults will go inside Extensions value and replace subitems. *)
getPacletValue[paclet_Paclet, "Extensions"] := "Extensions" /. (List @@ paclet) /. "Extensions" -> {}
getPacletValue[paclet_Paclet, "QualifiedName"] := PgetQualifiedName[paclet]
(* Special rules to support older paclets that use "MathematicaVersion" instead of "WolframVersion". *)
getPacletValue[paclet_Paclet, fields:{___String, "WolframVersion", ___String}] :=
    fields /. Replace[List @@ paclet, ("MathematicaVersion" -> v_) :> ("WolframVersion" -> v), {1}] /. $piDefaults /. Thread[fields->Null]
getPacletValue[paclet_Paclet, "WolframVersion"] :=
    Block[{plist = List @@ paclet, v},
        v = "MathematicaVersion" /. plist;
        If[v === "MathematicaVersion", "WolframVersion" /. plist /. $piDefaults, v]
    ]
(* Gives the full PacletInfo.m data (note that the lhs of all rules are strings, not symbols as typically written in the PI.m file). *) 
getPacletValue[paclet_Paclet, "PacletInfo"] := List @@ DeleteCases[paclet, "Location" -> _]


(* ::Code::Initialization:: *)
PgetQualifiedName[paclet_] :=
    Block[{n, p, v},
        {n, p, v} = getPacletValue[paclet, {"Name", "Qualifier", "Version"}];
        If[p == "",
            ExternalService`EncodeString[n, "UTF-8"] <> "-" <> v,
        (* else *)
            ExternalService`EncodeString[n, "UTF-8"] <> "-" <> p <> "-" <> v
        ]
    ]


$piDefaults = Dispatch[{
    "Extensions" -> {},
    "SystemID" -> All,
    "WolframVersion" -> "10+",
    "ProductName" -> All,
    "Qualifier" -> "",
    "Internal" -> False,
    "Root" -> ".",
    "BackwardCompatible" -> True,
    "BuildNumber" -> "",
    "Description" -> "",
    "InstallFromDocRequest" -> False,
    "ID" -> "",
    "Creator" -> "",
    "URL" -> "",
    "Publisher" -> "",
    "Support" -> "",
    "Category" -> "",
    "Thumbnail" -> "",
    "Copyright" -> "",
    "License" -> "",
    "Loading" -> Manual,
    "Updating" -> Manual
}]


(* ::Code::Initialization:: *)
getVersionNumbers[paclet_Paclet] := FromDigits/@StringSplit[#, "."]&@getPacletValue["Version"]@PacletRegularize[paclet];

SortByVersion[_[paclets__Paclet]] := ReverseSortBy[
	{paclets},
	getVersionNumbers,
	OrderedQ@*PadRight@*List
]


(* ::Code::Initialization:: *)
SiteRegularize[_[paclets__Paclet]] := PacletSite @@ Catenate@Values@KeySort[
	SortByVersion /@ GroupByName@{paclets}
]
SiteRegularize[] := SiteRegularize@GetPacletInfo[]
