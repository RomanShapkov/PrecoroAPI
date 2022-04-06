// This file contains your Data Connector logic
section PrecoroAPI;

baseurl = "https://api.precoro.com/";
userid = Extension.CurrentCredential()[Username];
apikey = Extension.CurrentCredential()[Password];


[DataSource.Kind="PrecoroAPI", Publish="PrecoroAPI.Publish"]
shared PrecoroAPI.GetData = (endpoint as text, optional params as record) =>
    let
        url = Uri.Combine(baseurl, endpoint),
        h = [#"X-AUTH-TOKEN" = apikey, #"email" = userid],
        json = Json.Document( Web.Contents(url, [Headers = h, Query = params, ManualCredentials = true]) )
    in
        json;

// Data Source Kind description
PrecoroAPI = [
    Authentication = [
        // Key = [],
        UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PrecoroAPI.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PrecoroAPI.Icons,
    SourceTypeImage = PrecoroAPI.Icons
];

PrecoroAPI.Icons = [
    Icon16 = { Extension.Contents("PrecoroAPI16.png"), Extension.Contents("PrecoroAPI20.png"), Extension.Contents("PrecoroAPI24.png"), Extension.Contents("PrecoroAPI32.png") },
    Icon32 = { Extension.Contents("PrecoroAPI32.png"), Extension.Contents("PrecoroAPI40.png"), Extension.Contents("PrecoroAPI48.png"), Extension.Contents("PrecoroAPI64.png") }
];
