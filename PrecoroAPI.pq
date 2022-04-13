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
                {"PurchaseOrdersList", "PurchaseOrdersList", PrecoroAPI.PurchaseOrdersList, "function", "function", "true"},
                {"GetPurchaseOrdersByIDN", "GetPurchaseOrdersByIDN", PrecoroAPI.GetPurchaseOrdersByIDN, "function", "function", "true"},
                {"DocumentCustomFields", "GetDocumentCustomFields", PrecoroAPI.GetDocumentCustomFields, "function", "function", "true"},
                {"ItemCustomFields", "GetItemCustomFields", PrecoroAPI.GetItemCustomFields, "function", "function", "true"}
            }   
        )
    in
        NavTable(lv1);

PrecoroAPI.PurchaseOrdersList = Value.ReplaceType(PrecoroAPI.PurchaseOrdersListImpl, PrecoroAPI.PurchaseOrdersType);
PrecoroAPI.PurchaseOrdersType =
type function (  
                      #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                      #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     
                     include_DocumentCustomFields as (type logical meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = "PurchaseOrdersList",
            Documentation.LongDescription = "PurchaseOrdersList"
    ];


PrecoroAPI.GetPurchaseOrdersByIDN = Value.ReplaceType(PrecoroAPI.GetPurchaseOrdersByIDNImpl, PrecoroAPI.GetPurchaseOrdersByIDNType);
PrecoroAPI.GetPurchaseOrdersByIDNType =
type function (  
                      #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                      #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     
                     include_DocumentCustomFields as (type logical meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),
                     include_ItemsCustomFields as (type logical meta [
                        Documentation.FieldCaption = "include_ItemsCustomFields",
                        Documentation.FieldDescription = "include_ItemsCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = "PurchaseOrdersList",
            Documentation.LongDescription = "PurchaseOrdersList"
    ];


PrecoroAPI.PurchaseOrdersListImpl = (
    #"createDate[left_date]" as date, 
    #"createDate[right_date]" as date, 
    include_DocumentCustomFields as logical
    ) =>
    let
        endpoint = "purchaseorders",
        p = [
            #"createDate[left_date]" = Date.ToText(#"createDate[left_date]", "dd.MM.yyyy"), 
            #"createDate[right_date]" = Date.ToText(#"createDate[right_date]", "dd.MM.yyyy")
            //#"per_page" = Text.From(per_page)
            ],
        
        fn = (pg as number) => 
            let 
                add_page_to_p = Record.AddField(p, "page", Text.From(pg)),
                data = PrecoroAPI.GetData(endpoint, add_page_to_p)
            in
                data,
        tb1 =
           List.Combine(
            List.Generate( 
                ()=> [ x = 1 , y = fn(1)],
                each [x] <= Number.From([y][meta][pagination][total_pages]), //not(List.IsEmpty([y])),
                each [ x=[x] + 1, y = fn(x) ],
                each [y][data]
            )
            ),
        tb = toTable(tb1, 1),
        ExpDocCustomFields = Table.ExpandRecordColumn(tb, "dataDocumentCustomFields", {"data"}, {"dataDocumentCustomFields.data"}),

        merge_custom_field = 
            let 
                a = 
                    if include_DocumentCustomFields 
                    then PrecoroAPI.GetPurchaseOrdersWithCustomFields(ExpDocCustomFields) 
                    else ExpDocCustomFields
            in a

    in
        merge_custom_field;



PrecoroAPI.GetPurchaseOrdersByIDNImpl = (
    #"createDate[left_date]" as date, 
    #"createDate[right_date]" as date,
    include_DocumentCustomFields as logical,
    include_ItemsCustomFields as logical
    ) =>
        let
            orders = PrecoroAPI.PurchaseOrdersList(#"createDate[left_date]", #"createDate[right_date]", include_DocumentCustomFields),
            tabl_sel_col = Table.SelectColumns(orders, {"idn", "DocumentCustomFields"}, MissingField.UseNull),
            detail_orders = Table.TransformRows(tabl_sel_col, each 
               Record.AddField( PrecoroAPI.GetData( "purchaseorders/" & Text.From([idn]), []), "DocumentCustomFields", _[DocumentCustomFields]) 
               ),

            tb = toTable(detail_orders, 1),

            
        add_items_custom_field = 
            let 
                a = 
                    if include_ItemsCustomFields 
                    then PrecoroAPI.GetPurchaseOrdersWithCustomFieldsItems(tb) 
                    else tb
            in a

        in 
            add_items_custom_field;


PrecoroAPI.GetDocumentCustomFields = () =>
    let
        endpoint = "documentcustomfields",
        p = [],
       
        fn = (pg as number) => 
            let 
                add_page_to_p = Record.AddField(p, "page", Text.From(pg)),
                data = PrecoroAPI.GetData(endpoint, add_page_to_p)
            in
                data,
        tb1 =
           List.Combine(
            List.Generate( 
                ()=> [ x = 1 , y = fn(1)],
                each [x] <= Number.From([y][meta][pagination][total_pages]), //not(List.IsEmpty([y])),
                each [ x=[x] + 1, y = fn(x) ],
                each [y][data]
            )
            ),

        tb2 = toTable(tb1, 1),
        ExpandedOptions = Table.ExpandRecordColumn(tb2, "options", {"data"}, {"options.data"}),
        ExpandedOptionsData  = Table.ExpandListColumn(ExpandedOptions, "options.data"),
        ExpandedOptionsData1 = Table.ExpandRecordColumn(ExpandedOptionsData, "options.data", {"id", "name", "code", "label", "level", "parent", "enable"}, {"options.data.id", "options.data.name", "options.data.code", "options.data.label", "options.data.level", "options.data.parent", "options.data.enable"})
    in
        ExpandedOptionsData1;

PrecoroAPI.GetItemCustomFields = () =>
    let
        endpoint = "itemcustomfields",
        p = [],
       
        fn = (pg as number) => 
            let 
                add_page_to_p = Record.AddField(p, "page", Text.From(pg)),
                data = PrecoroAPI.GetData(endpoint, add_page_to_p)
            in
                data,
        tb1 =
           List.Combine(
            List.Generate( 
                ()=> [ x = 1 , y = fn(1)],
                each [x] <= Number.From([y][meta][pagination][total_pages]), //not(List.IsEmpty([y])),
                each [ x=[x] + 1, y = fn(x) ],
                each [y][data]
            )
            ),
        tb2 = toTable(tb1, 1),
        #"Expanded options" = Table.ExpandRecordColumn(tb2, "options", {"data"}, {"options.data"}),
        #"Expanded options.data" = Table.ExpandListColumn(#"Expanded options", "options.data"),
        #"Expanded options.data1" = Table.ExpandRecordColumn(#"Expanded options.data", "options.data", {"id", "name", "code", "label", "level", "parent", "externalId", "enable"}, {"options.data.id", "options.data.name", "options.data.code", "options.data.label", "options.data.level", "options.data.parent", "options.data.externalId", "options.data.enable"}),
        #"Added Custom" = 
            Table.AddColumn(#"Expanded options.data1", "CustomField", 
                each Record.AddField(
                        Record.AddField([], [name] & "_Code", [options.data.code]),
                    [name] & "_Name", [options.data.name]))
in
    #"Added Custom";



PrecoroAPI.GetPurchaseOrdersWithCustomFields = (doc_tb as table) =>
    let
        cf_dim = PrecoroAPI.GetDocumentCustomFields(),
        doc = doc_tb,
        #"Removed Other Columns" = Table.SelectColumns(doc,{"id", "dataDocumentCustomFields.data"}),
        #"Expanded dataDocumentCustomFields.data" = Table.ExpandListColumn(#"Removed Other Columns", "dataDocumentCustomFields.data"),
        #"Expanded dataDocumentCustomFields.data1" = Table.ExpandRecordColumn(#"Expanded dataDocumentCustomFields.data", "dataDocumentCustomFields.data", {"value", "documentCustomField"}, {"CustomFields.value", "CustomFields.documentCustomField"}),
        #"Expanded CustomFields.documentCustomField" = Table.ExpandRecordColumn(#"Expanded dataDocumentCustomFields.data1", "CustomFields.documentCustomField", {"id"}, {"CustomFields.documentCustomField.id"}),
        #"Changed Type" = Table.TransformColumnTypes(#"Expanded CustomFields.documentCustomField",{{"CustomFields.documentCustomField.id", Int64.Type}, {"CustomFields.value", Int64.Type}}),
        #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"CustomFields.documentCustomField.id", "CustomFields.value"}, cf_dim, {"id", "options.data.id"}, "Invoked Function", JoinKind.LeftOuter),
        #"Expanded Invoked Function" = Table.ExpandTableColumn(#"Merged Queries", "Invoked Function", {"name", "options.data.name", "options.data.code"}, {"name", "options.data.name", "options.data.code"}),
        #"Added Custom" = 
            Table.AddColumn(#"Expanded Invoked Function", "CustomField", 
                each Record.AddField(
                        Record.AddField([], [name] & "_Code", [options.data.code]),
                    [name] & "_Name", [options.data.name])),
        #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"CustomFields.value", "CustomFields.documentCustomField.id", "name", "options.data.name", "options.data.code"}),
        #"Grouped Rows" = Table.Group(#"Removed Columns", {"id"}, {{"CustomFields", each try Record.Combine(_[CustomField]) otherwise [] , type record }}),
        
        #"MergedToDoc" = Table.NestedJoin(doc, {"id"}, #"Grouped Rows", {"id"}, "CustomFieldsRec", JoinKind.LeftOuter),
        exp_tb = Table.ExpandTableColumn(#"MergedToDoc", "CustomFieldsRec", {"CustomFields"}, {"DocumentCustomFields"})
    in
        exp_tb;

PrecoroAPI.GetPurchaseOrdersWithCustomFieldsItems = (doc_tb as table) =>
let
    #"Invoked FunctionGetPurchaseOrdersByIDN1" = doc_tb,
    cf_dim = PrecoroAPI.GetItemCustomFields(),

    #"Removed Other Columns" = Table.SelectColumns(#"Invoked FunctionGetPurchaseOrdersByIDN1",{"id", "items"}),
    #"Expanded items" = Table.ExpandRecordColumn(#"Removed Other Columns", "items", {"data"}, {"items.data"}),
    #"Expanded items.data" = Table.ExpandListColumn(#"Expanded items", "items.data"),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded items.data", "items.data", "items.data - Copy"),
    #"Expanded items.data1" = Table.ExpandRecordColumn(#"Duplicated Column", "items.data", {"id", "dataProductCustomFields"}, {"items.data.id", "items.data.dataProductCustomFields"}),
    #"Expanded items.data.dataProductCustomFields" = Table.ExpandRecordColumn(#"Expanded items.data1", "items.data.dataProductCustomFields", {"data"}, {"items.data.dataProductCustomFields.data"}),
    #"Expanded items.data.dataProductCustomFields.data" = Table.ExpandListColumn(#"Expanded items.data.dataProductCustomFields", "items.data.dataProductCustomFields.data"),
    #"Expanded items.data.dataProductCustomFields.data1" = Table.ExpandRecordColumn(#"Expanded items.data.dataProductCustomFields.data", "items.data.dataProductCustomFields.data", {"value", "productCustomField"}, {"ProductCustomFields.value", "ProductCustomFields.productCustomField"}),
    #"Expanded ProductCustomFields.productCustomField" = Table.ExpandRecordColumn(#"Expanded items.data.dataProductCustomFields.data1", "ProductCustomFields.productCustomField", {"id"}, {"productCustomField.id"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded ProductCustomFields.productCustomField",{{"ProductCustomFields.value", Int64.Type}, {"productCustomField.id", Int64.Type}}),
    
    #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"productCustomField.id", "ProductCustomFields.value"}, cf_dim, {"id", "options.data.id"}, "ItemCustomFields", JoinKind.LeftOuter),
    #"Expanded ItemCustomFields" = Table.ExpandTableColumn(#"Merged Queries", "ItemCustomFields", {"CustomField"}, {"CustomField"}),
    #"Grouped Rows" = Table.Group(#"Expanded ItemCustomFields", {"id", "items.data.id", "items.data - Copy"}, {{"CustomFields", each try Record.Combine(_[CustomField]) otherwise [] , type record }}),
    #"Added Custom" = Table.AddColumn(#"Grouped Rows", "data", each Record.AddField([#"items.data - Copy"], "ItemCustomFields", [CustomFields])),
    #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"items.data - Copy", "CustomFields", "items.data.id"}),
    #"Grouped Rows1" = Table.Group(#"Removed Columns", {"id"}, {{"items", each _[data], type list }}),
    #"RemoveItems" = Table.RemoveColumns(#"Invoked FunctionGetPurchaseOrdersByIDN1", {"items"}),
    #"MergeItemsWithCF" = Table.NestedJoin(#"RemoveItems", {"id"}, #"Grouped Rows1", {"id"}, "MergeItemsWithCF", JoinKind.LeftOuter),
    #"Expanded MergeItemsWithCF" = Table.ExpandTableColumn(MergeItemsWithCF, "MergeItemsWithCF", {"items"}, {"items"})
in
    #"Expanded MergeItemsWithCF";

GetAllPageData = (startpos as any, step as number, func as function) as list =>
    if not(startpos is null) then
        List.Combine(
            List.Generate( 
                ()=> [ x = startpos , y = func(x)],
                each not(List.IsEmpty([y])),
                each [ x=[x] + step, y = func(x) ],
                each [y]
            )
        )
    else
        func(startpos);


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
        UsernamePassword = [UsernameLabel = "email", PasswordLabel = "X-AUTH-TOKEN"],
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

