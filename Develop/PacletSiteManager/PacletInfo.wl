(* ::Package:: *)

Paclet[
	Name -> "PacletSiteManager",
	Version -> "0.0.0",
	WolframVersion -> "12.0+,12.1+,12.2.0.0", (* Lower version not tested. *)
	Description -> "Provide tools for building PacletSite, especially on a github repository.",
	Root -> ".",
	Loading -> Automatic,
	Extensions -> {
		{
			"Kernel",
			Root -> ".",
			Context -> "PacletMirrorManager`",
			Symbols -> {
			}
		(* Select[Names["PacletMirrorManager`*"], Capitalize@# === # &@ StringTake[#, 1] &]//StringRiffle[#,"\",\n				\""]& *)
		}
	}
]
