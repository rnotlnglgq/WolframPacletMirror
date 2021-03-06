(* ::Package:: *)

BuildSiteInfo[] := (
	CatenateParts[];
	ExportSiteInfo[];
	DeleteFile/@Keys@PartsRegularize[];
	ThisSiteInfo[]
)


 
