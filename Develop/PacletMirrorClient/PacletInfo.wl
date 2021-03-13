(* ::Package:: *)

Paclet[
	Name -> "PacletMirrorClient",
	Version -> "0.13.0", (* Cooperate with new PacletSiteManager. *)
	WolframVersion -> "11.0+", (* URLDownload is introduced by 11.0. *)
	Description -> "Change the default PacletManager to support our mirror service.",
	Root -> ".",
	Loading -> Automatic,
	Extensions -> {
		{
			"Kernel",
			Root -> ".",
			Context -> "PacletMirrorClient`",
			Symbols -> {
				"PacletManager`PacletFindRemote",
				"PacletManager`Manager`Private`finishInstall",
				"PacletMirrorClient`SetMirrorSites",
				"PacletMirrorClient`UpdateMirrorSites",
				"PacletMirrorClient`TryCatenatePaclet"
			}
		}
	}
]
