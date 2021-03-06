(* ::Package:: *)

(* ::Chapter:: *)
(*Paclet Expressions*)


(* ::Subsection:: *)
(*Paclet*)


(* ::Subsubsection:: *)
(*Type convert*)


PacletExpressionConvert[2][paclet_Paclet] := paclet /. (key_Symbol -> value_) :> (SymbolName@key -> value)


PacletExpressionConvert[2][pacletObject_PacletObject] := Paclet@@Normal@First@pacletObject


PacletExpressionConvert[1][paclet_Paclet] := paclet /. (key_String -> value_) :> (Symbol@key -> value)


PacletExpressionConvert[1][pacletObject_PacletObject] := pacletObject //PacletExpressionConvert[2] //PacletExpressionConvert[1]


PacletExpressionConvert[3][paclet_Paclet] := paclet //PacletExpressionConvert[2] //PacletExpressionConvert[3]


$PacletInfoKeys = {"BackwardCompatible","BuildNumber","Category","Creator","Description","Extensions","Internal","Loading","MathematicaVersion","Name","Published","Qualifier","Root","Support","SystemID","Updating","URL","Version","WolframVersion"};

PacletExpressionConvert[0][paclet_Paclet] := PacletExpressionConvert[1]@*Paclet@@FilterRules[
	List@@Replace[PacletExpressionConvert[2]@paclet, {
		(key:"PlatformQualifier" -> val_) :> ("Qualifier" -> val)
	}, 1],
	Alternatives@@$PacletInfoKeys
]


(* ::Subsubsection:: *)
(*Get values*)


(* ::Text:: *)
(*Accept: Type-2 Paclet.*)


GetPacletValue[fields_][paclet_Paclet] := GetPacletValue[paclet, fields]

GetPacletValue[paclet_Paclet, field_String] := Replace[field, Join[List@@paclet, $DefaultPacletValue]]
GetPacletValue[paclet_Paclet, fields:{__String}] := GetPacletValue[paclet, #]& /@ fields

GetPacletValue[paclet_Paclet, "QualifiedName"] := With[{n, q, v}=GetPacletValue[paclet, {"Name", "Qualifier", "Version"}] //Thread //Evaluate,
	If[q == "",
		ExternalService`EncodeString[n, "UTF-8"] <> "-" <> v,
		ExternalService`EncodeString[n, "UTF-8"] <> "-" <> q <> "-" <> v
	]
]
GetPacletValue[paclet_Paclet, "MathematicaVersion"|"WolframVersion"] := List@@paclet //Query[{"MathematicaVersion", "WolframVersion"}] //Switch[#,
	{_Missing, _Missing}, "10+",
	{_Missing, _}, Last@#,
	{_, _Missing}, First@#,
	_, Null
]&

GetPacletValue[paclet_Paclet, "VersionNumber"] := FromDigits /@ StringSplit[
	GetPacletValue["Version"]@paclet
, "."];


$DefaultPacletValue = {
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
    "Updating" -> Manual,
    _ -> Null
}


(* ::Subsection:: *)
(*PacletSite*)


(* ::Subsubsection:: *)
(*Group*)


(* ::Text:: *)
(*Accept: Type-2 Paclet Collection.*)


GroupByValue[field_][_[paclets___Paclet]] := GroupBy[GetPacletValue@field]@{paclets}


(* ::Subsubsection:: *)
(*Sort*)


(* ::Text:: *)
(*Accept: Type-2 Paclet Collection.*)
(*ReverseSort(>)*)


SortByVersion[_[paclets___Paclet]] := ReverseSortBy[
	{paclets},
	GetPacletValue["VersionNumber"],
	OrderedQ@*PadRight@*List
]


(* ::Text:: *)
(*Accept: Paclet Collection.*)


SiteRegularize[_[paclets__Paclet]] := PacletSiteManager`Private`PacletSite @@ Catenate@Values@KeySort[
	SortByVersion /@ GroupByValue["Name"][PacletExpressionConvert[2] /@ {paclets}]
]
SiteRegularize[] := SiteRegularize@GetPacletInfo[]
