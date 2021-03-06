(* ::Package:: *)

(* ::Title:: *)
(*PacletMirrorManager*)


(* ::Subsubsection:: *)
(*Develop Note*)


(* ::Text:: *)
(*\:8bb8\:591a\:51fd\:6570\:53ef\:4ee5\:5728 PacletManager` \:4e2d\:627e\:5230\:4f5c\:7528\:7c7b\:4f3c\:7684\:ff0c\:4f46\:7531\:4e8e\:8be5\:7a0b\:5e8f\:5305\:7a0d\:9648\:65e7\:ff0c\:547d\:540d\:7565\:6df7\:4e71\:ff0c\:8fd9\:91cc\:5c3d\:91cf\:91cd\:5199\:3002*)


(* ::Text:: *)
(*\:51e1\:8981\:63a5\:53d7 {__Paclet} \:4e3a\:53c2\:6570\:7684\:ff0c\:8bbe\:7f6e Listable \:5c5e\:6027\:ff1b\:5176\:4ed6\:5e94\:7528\:4e8e Paclet \:7684\:51fd\:6570\:ff0c\:4e5f\:901a\:5e38\:53ef\:81ea\:52a8\:4f5c\:7528\:4e8e _PacletSite \:5185\:90e8\:3002*)


BeginPackage["PacletMirrorManager`", {"PacletManager`", "GeneralUtilities`"}]


SetDirectory@FileNameJoin@{PacletFind["PacletMirrorManager"][[1]]["Location"], "Kernel"};

<< Setting.wl;
<< Declaration.wl;

Begin["`Private`"]
	Get /@ FileNames["*.wl", "Definitions"];
End[]

<< Message.wl;
<< SyntaxInformation.wl;

ResetDirectory[];


EndPackage[]
