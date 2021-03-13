(* ::Package:: *)

(* Created with the Wolfram Language : www.wolfram.com *)
Reverse@{
	Sequence@@(
		PacletSite[
			"https://gitee.com/rnotlnglgq/WolframPacletMirror"<>#<>"/raw/master", 
			"Wolfram Paclet Server Mirror "<>#, "Local" -> False
		]&@*IntegerString /@ Range@8
	),
	PacletSite["https://pacletserver.rnotlnglgq.workers.dev", "Wolfram Paclet Server CDN", "Local" -> False]
}
