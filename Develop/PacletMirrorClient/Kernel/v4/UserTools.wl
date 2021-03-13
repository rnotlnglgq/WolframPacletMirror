(* ::Package:: *)

Begin["`Private`"]


(* ::Subsection:: *)
(*Set PacletSites*)


$pacletMirrorList = "https://gitee.com/rnotlnglgq/WolframPacletMirror/raw/master/PacletSites.wl";


SetMirrorSites[] := (
	PacletSiteUnregister /@ Select[
		PacletSites[],
		StringContainsQ["wolframpaclet"|"rnotlnglgq", IgnoreCase -> True]@#["URL"] &
	];
	PacletSiteRegister[#1, #2]& @@@ Import[$pacletMirrorList, "Package"]
)


UpdateMirrorSites[] := PacletSiteUpdate /@ SetMirrorSites[]


End[]
