(* ::Package:: *)

Begin["`Private`"]


(* ::Subsection:: *)
(*Set PacletSites*)


SetMirrorSites[] := (
	PacletSiteRemove /@ Select[
		PacletSites[],
		StringContainsQ["wolframpaclet", IgnoreCase -> True][First@#] &
	];
	PacletSiteAdd /@ Import["https://gitee.com/wolframpaclet/WolframPacletGeneral/raw/master/PacletSites.wl", "Package"]
)


UpdateMirrorSites[] := PacletSiteUpdate/@SetMirrorSites[]


End[]
