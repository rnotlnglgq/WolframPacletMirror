(* ::Package:: *)

Paclet[
	Name -> "PacletMirrorClient",
	Version -> "0.9.5", (* debug: runQueued contains RunProcess@{"cat", "--help"} *)
	WolframVersion -> "11.0+",(* URLDownload is introduced by 11.0. *)
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
