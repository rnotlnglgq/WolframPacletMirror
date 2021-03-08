<|
    "UpdateSiteInfo" :> (
        CatenateParts[];
        PutSiteInfo[];
        DeleteFile /@ Keys@PartsRegularize[];
        GetSiteInfo@1
    ),
    "UpdateSite" :> (
        ListRequiredPaclet[
            GetRequirementInfo[],
            GetSiteInfo@3(* Manually execute `PacletSiteUpdate@"https://pacletserver.wolfram.com"` before this! *)
        ] //ListPacletChanges //ApplyPacletChanges
    ),
    "InitializeSite" :> "Not implemented."
|>
