(* ::Package:: *)

Paclet[
	Name -> "PacletSiteManager",
	Version -> "0.0.0",
	WolframVersion -> "12.0+,12.1+,12.2.0.0", (* Lower versions are not tested. You can download and force the installation. *)
	Description -> "Provide tools for building PacletSite, especially on a github repository.",
	Root -> ".",
	Loading -> Automatic,
	Extensions -> {
		{
			"Kernel",
			Root -> ".",
			Context -> "PacletSiteManager`",
			Symbols -> {
				$Downloader,
				$VersionStringComplete,
				$WolframPacletSite,
				$PartSize,
				$RequirementFile,
				ApplyPacletChanges,
				BlockedExport,
				BlockedImport,
				BuildTreeBySeries,
				CatenateParts,
				DownloadCommand,
				DownloadPaclet,
				DownloadRequest,
				ExportURLList,
				GetPacletInfo,
				GetPacletValue,
				GetRequirementInfo,
				GetSiteInfo,
				GroupByValue,
				KernelVersionMatchQ,
				ListPacletChanges,
				ListRequiredPaclet,
				PacletExpressionConvert,
				PacletList,
				PacletPartList,
				PacletQuery,
				PacletSearch,
				PartsRegularize,
				PutRequirementInfo,
				PutSiteInfo,
				SiteRegularize,
				SortByVersion,
				SplitPaclet,
				ValidPacletFileQ,
				ValidPacletQ
			}
		(* Select[Names["PacletSiteManager`*"], Capitalize@# === # &@ StringTake[#, 1] &]//StringRiffle[#,"\",\n				\""]& *)
		}
	}
]
