// This file contains your Data Connector logic
section PrecoroAPI;

baseurl = "https://api.precoro.com/";
userid = Extension.CurrentCredential()[Username];
apikey = Extension.CurrentCredential()[Password];


[DataSource.Kind="PrecoroAPI", Publish="PrecoroAPI.Publish"]

shared PrecoroAPI.NavTableNested = () as table =>
    let

        NavTable = (tb as table) => Table.ToNavigationTable(tb, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf"),
        table_header = {"Name", "Key", "Data", "ItemKind", "ItemName", "IsLeaf"},

        lv1 = #table(
            table_header,
            {
                {"PurchaseOrders", "GetPurchaseOrders", PrecoroAPI.GetPurchaseOrders, "function", "function", "true"}
            }   
        )
    in
        NavTable(lv1);


PrecoroAPI.GetPurchaseOrders = () =>
    let
        endpoint = "purchaseorders",
        tb = PrecoroAPI.GetData(endpoint)[data]
    in
        toTable(tb, 1);


PrecoroAPI.GetData = (endpoint as text, optional params as record) =>
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


toTable = (lstrec as list, optional index as number) as table =>
    let
        fieldnames = 
            let
                toprows = if index is null then lstrec else List.FirstN(lstrec, index),
                listfields = List.Transform(toprows, Record.FieldNames),
                namesdistinct = List.Union(listfields)
            in
                namesdistinct,
        tbl = Table.FromRecords(lstrec, fieldnames, MissingField.UseNull)
    in
        tbl;


Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;
