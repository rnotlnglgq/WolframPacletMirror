(* ::Package:: *)

Begin["`Private`"]


(* ::Subsection:: *)
(*Enhance PacletSites*)


PacletSite[url_, _, ___]["URL"] := url
PacletSite[_, name_, ___]["Name"] := name
PacletSite[_, _, rules___][key:Except[_, "URL"|"Name"]] := Lookup[key]@{rules}


(* ::Subsection:: *)
(*Set PacletSites*)


$pacletMirrorList = "https://gitee.com/rnotlnglgq/WolframPacletMirror/raw/master/PacletSites.wl"


SetMirrorSites[] := (
	PacletSiteRemove /@ Select[
		PacletSites[],
		StringContainsQ["wolframpaclet"|"rnotlnglgq", IgnoreCase -> True]@#["URL"] &
	];
	PacletSiteAdd /@ Import[$pacletMirrorList, "Package"]
)


UpdateMirrorSites[] := PacletSiteUpdate/@SetMirrorSites[]


End[]
