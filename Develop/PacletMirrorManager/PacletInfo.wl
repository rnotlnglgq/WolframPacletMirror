(* ::Package:: *)

Paclet[
	Name -> "PacletMirrorManager",
	Version -> "0.14.0", (* Try to support PM v4. *)
	WolframVersion -> "11.0+", (* Not tested. *)
	Description -> "Provide tools for the moderation and management of the mirror.",
	Root -> ".",
	Loading -> Automatic,
	Extensions -> {
		{
			"Kernel",
			Root -> ".",
			Context -> "PacletMirrorManager`",
			Symbols -> {
				"BuildSiteInfo",
				"CatenateParts",
				"DownloadCommand",
				"DownloadPaclet",
				"DownloadRequest",
				"ExportSiteInfo",
				"ExportURLList",
				"GetPacletInfo",
				"GroupByName",
				"KernelVersionMatchQ",
				"NewestPaclet",
				"NewestSiteInfo",
				"OriginalSiteInfo",
				"PacletDeregularize",
				"PacletList",
				"PacletPartList",
				"PacletRegularize",
				"PacletSeriesRegularize",
				"PacletSearch",
				"PacletQuery",
				"PartsRegularize",
				"PickNewestPaclet",
				"SiteRegularize",
				"SortByVersion",
				"SplitPaclet",
				"ThisSiteInfo",
				"UpdatePaclet",
				"UpdateSiteInfo",
				"ValidPacletFileQ",
				"ValidPacletQ"
			}
		(* Select[Names["PacletMirrorManager`*"], Capitalize@# === # &@ StringTake[#, 1] &]//StringRiffle[#,"\",\n				\""]& *)
		},
		{
			"Documentation",
			Language -> "ChineseSimplified", MainPage -> "Tutorials/Introduction"
		}
	}
]
