// This file contains your Data Connector logic
section PrecoroAPI;

baseurl = "https://api.precoro.com/";
userid = Extension.CurrentCredential()[Username];
apikey = Extension.CurrentCredential()[Password];


[DataSource.Kind="PrecoroAPI", Publish="PrecoroAPI.Publish"]

shared Precoro.Company = (#"Company name" as text) as table =>
    let

        NavTable = (tb as table) => Table.ToNavigationTable(tb, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf", "sort") ,
        table_header = {"Name", "Key", "Data", "ItemKind", "ItemName", "IsLeaf", "sort"},
        
        a = #table(table_header, 
            {
                {"Get Warehouse Requests list", "warehouserequests", PrecoroAPI.warehouserequests, "function", "function", "true", 1},
                {"Get Warehouse Requests by IDN", "warehouserequestsByIDN", PrecoroAPI.warehouserequestsByIDN, "function", "function", "true", 2}
             }),

        b = #table(table_header, 
            {
                {"Get Purchase Requisitions list", "purchaserequisitions", PrecoroAPI.purchaserequisitions, "function", "function", "true", 1},
                {"Get Purchase Requisitions by IDN", "purchaserequisitionsByIDN", PrecoroAPI.purchaserequisitionsByIDN, "function", "function", "true", 2}
             }),


        c = #table(table_header, 
            {
                {"Get Request For Proposals list", "requestforproposals", PrecoroAPI.requestforproposals, "function", "function", "true", 1},
                {"Get Request For Proposals by IDN", "requestforproposalsByIDN", PrecoroAPI.requestforproposalsByIDN, "function", "function", "true", 2}
             }),

       d = #table(table_header, 
            {
                {"Get Purchase Orders list", "purchaseorders", PrecoroAPI.purchaseorders, "function", "function", "true", 1},
                {"Get Purchase Orders by IDN", "purchaseordersByIDN", PrecoroAPI.purchaseordersByIDN, "function", "function", "true", 2}
             }),

       e = #table(table_header, 
            {
                {"Get Receipts list", "receipts", PrecoroAPI.receipts, "function", "function", "true", 1},
                {"Get Receipts by IDN", "receiptsByIDN", PrecoroAPI.receiptsByIDN, "function", "function", "true", 2}
             }),
       f = #table(table_header, 
            {
                {"Get Invoices list", "invoices", PrecoroAPI.invoices, "function", "function", "true", 1},
                {"Get invoices by IDN", "invoicesByIDN", PrecoroAPI.invoicesByIDN, "function", "function", "true", 2}
             }),

       g = #table(table_header, 
            {
                {"Payments", "invoices", PrecoroAPI.invoices, "function", "function", "true", 1}
             }),

       h = #table(table_header, 
            {
                {"Budgets", "budgets ", PrecoroAPI.budgets, "function", "function", "true", 1}
             }),

      
       i0 = #table(table_header, 
            {
                {"Stock Transfers", "stocktransfers", PrecoroAPI.stocktransfers, "function", "function", "true", 1},
                {"Get Stock Transfer by ID", "stocktransfersByID", PrecoroAPI.stocktransfersByID, "function", "function", "true", 2}
             }),

        
       i = #table(table_header, 
            {
                {"Inventory", "Inventory ", NavTable(i0), "Table", "Table", "false", 1},
                {"Get Stock-takings list", "stock_takings ", PrecoroAPI.stock_takings, "function", "function", "true", 2},
                {"Get Stock-taking by ID", "stock_takingsByID ", PrecoroAPI.stock_takingsByID, "function", "function", "true", 4},
                {"Get Warehouse Items", "warehousesItemsByWarehouseID ", PrecoroAPI.warehousesItemsByWarehouseID, "function", "function", "true", 5}
             }),
//
       o1 = #table(table_header, 
            {
                {"Get Suppliers list", "Get Suppliers list", PrecoroAPI.suppliers, "function", "function", "true", 1},
                {"Get Supplier by ID", "Get Supplier by ID", PrecoroAPI.suppliersByID, "function", "function", "true", 2}

             }),

       o2 = #table(table_header, 
            {
                {"Get Items list", "Get Items list", PrecoroAPI.items, "function", "function", "true", 1}
             }),

      
       o = #table(table_header, 
            {
                {"Suppliers and Items", "Suppliers and Items", NavTable(o1), "Table", "Table", "false", 1},
                {"Item Management", "Item Management ",  NavTable(o2), "Table", "Table", "false", 2},
                {"Get Units list", "Get Units list", PrecoroAPI.units, "function", "function", "true", 3},
                {"Get Categories list", "Get Categories list", PrecoroAPI.categories, "function", "function", "true", 4}
             }),

       p = #table(table_header, 
            {
                {"Get Company Payment Terms list", "paymentterms ", PrecoroAPI.paymentterms, "function", "function", "true", 1}

             }),

       r1 = #table(table_header, 
            {
                {"Get Locations list", "locations ", PrecoroAPI.locations, "function", "function", "true", 1}

             }),
       r2 = #table(table_header, 
            {
                {"Get Users list", "users ", PrecoroAPI.users, "function", "function", "true", 1}

             }),
       r3 = #table(table_header, 
            {
                {"Get Item Сustom Fields list", "itemcustomfields ", PrecoroAPI.itemcustomfields, "function", "function", "true", 1}

             }),
       r4 = #table(table_header, 
            {
                {"Get Document Сustom Fields list", "documentcustomfields ", PrecoroAPI.documentcustomfields, "function", "function", "true", 1}

             }),
       r5 = #table(table_header, 
            {
                {"Get Legal Entities list", "legalentities ", PrecoroAPI.legalentities, "function", "function", "true", 1},
                {"Get Legal Entity by ID", "legalentitiesByID ", PrecoroAPI.legalentitiesByID, "function", "function", "true", 2}

             }),
       r6 = #table(table_header, 
            {
                {"Get Warehouses list", "warehouses ", PrecoroAPI.warehouses, "function", "function", "true", 1}

             }),
       r7 = #table(table_header, 
            {
                {"Get Tax list", "taxes ", PrecoroAPI.taxes, "function", "function", "true", 1}

             }),

       r = #table(table_header, 
            {
                {"Locations", "Locations", NavTable(r1), "Table", "Table", "false", 1},
                {"Users", "Users", NavTable(r2), "Table", "Table", "false", 2},
                {"Item Сustom Fields", "Item Сustom Fields", NavTable(r3), "Table", "Table", "false", 3},
                {"Document Сustom Fields", "Document Сustom Fields", NavTable(r4), "Table", "Table", "false", 4},
                {"Legal Entities", "Legal Entities", NavTable(r5), "Table", "Table", "false", 5},
                {"Inventory", "Inventory", NavTable(r6), "Table", "Table", "false", 6},
                {"Taxes", "Taxes", NavTable(r7), "Table", "Table", "false", 7}
             }),


        lv1 = #table(
            table_header,
            {
                {"Warehouse Requests", "WarehouseRequests", NavTable(a) , "Folder", "Folder", "false", 1},
                {"Purchase Requisitions", "PurchaseRequisitions", NavTable(b) , "Folder", "Folder", "false", 2},
                {"Request for Proposals", "RequestForProposals", NavTable(c) , "Folder", "Folder", "false", 3},
                {"Purchase Orders", "PurchaseOrders", NavTable(d) , "Folder", "Folder", "false", 4},
                {"Receipts", "Receipts", NavTable(e) , "Folder", "Folder", "false", 5},
                {"Invoices", "Invoices", NavTable(f) , "Folder", "Folder", "false", 6},
                {"Payments", "Payments", NavTable(g) , "Folder", "Folder", "false", 7},
                {"Budgets", "Budgets", NavTable(h) , "Folder", "Folder", "false", 8},
                {"Inventory", "Inventory", NavTable(i) , "Folder", "Folder", "false", 9},
                {"Suppliers and Items", "Suppliers and Items", NavTable(o) , "Folder", "Folder", "false", 10},
                {"Company Payment Terms", "Company Payment Terms", NavTable(p) , "Folder", "Folder", "false", 11},
                {"Configuration", "Configuration", NavTable(r) , "Folder", "Folder", "false", 12}

                // {"GetDataFromEndpointList", "GetDataFromEndpointList", PrecoroAPI.GetDataFromEndpoint, "function", "function", "true", 13},
                //,{"GetData", "GetData", PrecoroAPI.GetData, "function", "function", "true", 14}
                
            }   
        )
    in
        NavTable(lv1);

endpoints = {
    "warehouserequests",
    "purchaserequisitions",
    "requestforproposals",
    "purchaseorders",
    "receipts",
    "invoices",
    "payments",
    "budgets",
    "stocktransfers",
    "stock_takings",
    "suppliers",
    "units",
    "categories",
    "items",
    "paymentterms",
    "locations",
    "users",
    "itemcustomfields",
    "documentcustomfields",
    "legalentities",
    "warehouses",
    "taxes"
    };


endpointsIDN = {
    "warehouserequests",
    "purchaserequisitions",
    "requestforproposals",
    "purchaseorders",
    "receipts",
    "invoices"
    };
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


PrecoroAPI.warehousesItemsByWarehouseID = Value.ReplaceType(PrecoroAPI.warehousesItemsByWarehouseIDImpl, byListIDNType("Get Warehouse Items"));
PrecoroAPI.warehousesItemsByWarehouseIDImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => 
    let 
        Source = PrecoroAPI.GetDataFromEndpointByIDN("warehouses",  #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields, "id", "/items"),
        #"Removed Other Columns" = Table.SelectColumns(Source,{"data"}),
        #"Expanded data" = Table.ExpandListColumn(#"Removed Other Columns", "data"),
        #"Expanded data1" = Table.ExpandRecordColumn(#"Expanded data", "data", {"id", "warehouse", "quantity", "mainItem", "taxes"}, {"id", "warehouse", "quantity", "mainItem", "taxes"}),
        #"Filtered Rows" = Table.SelectRows(#"Expanded data1", each ([id] <> null))
    in
        #"Filtered Rows";

PrecoroAPI.taxes = Value.ReplaceType(PrecoroAPI.taxesImpl, byListType1("Get Tax list"));
PrecoroAPI.taxesImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("taxes");

PrecoroAPI.warehouses = Value.ReplaceType(PrecoroAPI.warehousesImpl, byListType1("Get Warehouses list"));
PrecoroAPI.warehousesImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("warehouses");

PrecoroAPI.legalentitiesByID = Value.ReplaceType(PrecoroAPI.legalentitiesByIDImpl, byListIDNType("Get Legal Entities by ID"));
PrecoroAPI.legalentitiesByIDImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("legalentities", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields, "id");

PrecoroAPI.legalentities = Value.ReplaceType(PrecoroAPI.legalentitiesImpl, byListType1("Get Legal Entities list"));
PrecoroAPI.legalentitiesImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("legalentities");

PrecoroAPI.documentcustomfields = Value.ReplaceType(PrecoroAPI.documentcustomfieldsImpl, byListType1("Get Document Сustom Fields list"));
PrecoroAPI.documentcustomfieldsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("documentcustomfields");

PrecoroAPI.itemcustomfields = Value.ReplaceType(PrecoroAPI.itemcustomfieldsImpl, byListType1("Get Item Сustom Fields list"));
PrecoroAPI.itemcustomfieldsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("itemcustomfields");

PrecoroAPI.users = Value.ReplaceType(PrecoroAPI.usersImpl, byListType1("Get Users list"));
PrecoroAPI.usersImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("users");

PrecoroAPI.locations = Value.ReplaceType(PrecoroAPI.locationsImpl, byListType1("Get Locations list"));
PrecoroAPI.locationsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("locations");

PrecoroAPI.paymentterms = Value.ReplaceType(PrecoroAPI.paymenttermsImpl, byListType1("Get Company Payment Terms list"));
PrecoroAPI.paymenttermsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("paymentterms");

PrecoroAPI.categories = Value.ReplaceType(PrecoroAPI.categoriesImpl, byListType1("Get Categories list"));
PrecoroAPI.categoriesImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("categories");

PrecoroAPI.units = Value.ReplaceType(PrecoroAPI.itemsImpl, byListType1("Get Units list"));
PrecoroAPI.unitsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("units");

PrecoroAPI.items = Value.ReplaceType(PrecoroAPI.itemsImpl, byListType1("Get Items list"));
PrecoroAPI.itemsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("items");

PrecoroAPI.suppliersByID = Value.ReplaceType(PrecoroAPI.suppliersByIDImpl, byListIDNType("Get Supplier by ID"));
PrecoroAPI.suppliersByIDImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("suppliers", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields, "id");

PrecoroAPI.suppliers = Value.ReplaceType(PrecoroAPI.suppliersImpl, byListType1("Get Suppliers list"));
PrecoroAPI.suppliersImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("suppliers");

PrecoroAPI.stock_takingsByID = Value.ReplaceType(PrecoroAPI.stock_takingsByIDImpl, byListIDNType("Get Stock-takings by ID"));
PrecoroAPI.stock_takingsByIDImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("stock_takings", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields, "id");

PrecoroAPI.stock_takings = Value.ReplaceType(PrecoroAPI.stock_takingsImpl, byListType1("Get Stock-takings list"));
PrecoroAPI.stock_takingsImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("stock_takings");

PrecoroAPI.stocktransfersByID = Value.ReplaceType(PrecoroAPI.stocktransfersByIDImpl, byListType2("Get stocktransfers by ID"));
PrecoroAPI.stocktransfersByIDImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date) => PrecoroAPI.GetDataFromEndpointByIDN("stocktransfers", #"createDate[left_date]",  #"createDate[right_date]", null, null,  "id");

PrecoroAPI.stocktransfers = Value.ReplaceType(PrecoroAPI.stocktransfersImpl, byListType1("Get Stock Transfers list"));
PrecoroAPI.stocktransfersImpl = () => PrecoroAPI.GetDataFromEndpoint1Impl("stocktransfers");

PrecoroAPI.budgets = Value.ReplaceType(PrecoroAPI.budgetsImpl, byListIDNType("Get Budgets list"));
PrecoroAPI.budgetsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => 
    let
        Source = PrecoroAPI.GetDataFromEndpoint("budgets", #"createDate[left_date]",  #"createDate[right_date]", false ),
        dCF = if include_DocumentCustomFields is null then false else include_DocumentCustomFields,
        resTb = 
            let
                #"Changed Type" = Table.TransformColumnTypes(Source,{{"allDocumentCustomFieldIds", Int64.Type}}),
                #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"allDocumentCustomFieldIds"}, PrecoroAPI.GetDocumentCustomFields(), {"id"}, "DCF", JoinKind.LeftOuter),
                fnGetDCF = Table.AddColumn(#"Merged Queries", "DocumentCustomFields", each fnCFBudget([DCF], [allDocumentCustomFieldOptionsIds])),
                removeCl = Table.RemoveColumns(fnGetDCF, {"DCF"})
            in 
                removeCl,
        resTb1 = if dCF then resTb else Source,
        iCF = if include_ItemsCustomFields is null then false else include_ItemsCustomFields,
        
        /*resTb2 = 
            let
                #"Changed Type" = Table.TransformColumnTypes(resTb1,{{"allItemCustomFieldIds", Int64.Type}}),
                #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"allItemCustomFieldIds"}, PrecoroAPI.GetItemCustomFieldsExpand(), {"id"}, "ICF", JoinKind.LeftOuter),
                fnGetDCF = Table.AddColumn(#"Merged Queries", "ItemCustomFields", each fnCFBudget([ICF], [allItemCustomFieldOptionsIds])),
                removeCl = Table.RemoveColumns(fnGetDCF, {"ICF"})
            in 
                removeCl*/
        
        resTb3 = 
            let
                    a =
                        let
                            b = 
                                let
                                    #"Removed Other Columns" = Table.SelectColumns(resTb1,{"children", "id"}),
                                    #"Expanded children" = Table.ExpandRecordColumn(#"Removed Other Columns", "children", {"data"}, {"children.data"}),
                                    #"Expanded children.data" = Table.ExpandListColumn(#"Expanded children", "children.data"),
                                    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded children.data", "children.data", "children.data2"),
                                    #"Expanded children.data1" = Table.ExpandRecordColumn(#"Duplicated Column", "children.data2", {"allItemCustomFieldIds", "allItemCustomFieldOptionsIds", "allDocumentCustomFieldIds", "allDocumentCustomFieldOptionsIds"}, {"children.data.allItemCustomFieldIds", "children.data.allItemCustomFieldOptionsIds", "children.data.allDocumentCustomFieldIds", "children.data.allDocumentCustomFieldOptionsIds"})
                                in
                                    #"Expanded children.data1",
                            c =
                                let
                                    #"Changed Type" = Table.TransformColumnTypes(b,{{"children.data.allItemCustomFieldIds", Int64.Type}}),
                                    #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"children.data.allItemCustomFieldIds"}, PrecoroAPI.GetItemCustomFieldsExpand(), {"id"}, "ICF", JoinKind.LeftOuter),
                                    fnGetDCF = Table.AddColumn(#"Merged Queries", "ItemCustomFields", each fnCFBudget([ICF], [children.data.allItemCustomFieldOptionsIds])),
                                    removeCl = Table.RemoveColumns(fnGetDCF, {"ICF"})
                                in
                                    if iCF then removeCl else b
                         in
                             c,

                    docCF = 
                        let
                            #"Changed Type" = Table.TransformColumnTypes(a,{{"children.data.allDocumentCustomFieldIds", Int64.Type}}),
                            #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"children.data.allDocumentCustomFieldIds"}, PrecoroAPI.GetDocumentCustomFields(), {"id"}, "DCF", JoinKind.LeftOuter),
                            fnGetDCF = Table.AddColumn(#"Merged Queries", "DocumentCustomFields", each fnCFBudget([DCF], [children.data.allDocumentCustomFieldOptionsIds])),
                            removeCl5 = Table.RemoveColumns(fnGetDCF, {"DCF"})
                        in 
                            if dCF then removeCl5 else a,


                    //#"Added Custom" = Table.AddColumn(#"Expanded children.data1", "ICS", each []),
                    //#"Added Custom1" = Table.AddColumn(removeCl, "DCF", each []),

                    b = 
                        let
                            #"Added Custom2" = Table.AddColumn(docCF, "data1", each if [children.data] is null then [children.data] else if iCF then Record.AddField( [children.data], "ItemCustomFields", [ItemCustomFields]) else [children.data]),
                            #"Added Custom3" = Table.AddColumn(#"Added Custom2", "children", each if [data1] is null then [data1] else if dCF then Record.AddField( [data1], "DocumentCustomFields", [DocumentCustomFields]) else [data1]),
                            #"Removed Other Columns1" = Table.SelectColumns(#"Added Custom3",{"children", "id"}),
                            #"Grouped Rows" = Table.Group(#"Removed Other Columns1", {"id"}, { {"children", each _[children], type list } } ),
                            tbChildre = Table.TransformColumns(#"Grouped Rows", {{"children", each [data = _]} }),
                            merge = Table.NestedJoin( resTb1, {"id"}, tbChildre, {"id"}, "dataCF",  JoinKind.LeftOuter),
                            #"Removed Columns" = Table.RemoveColumns(merge,{"children"}),
                            #"Expanded dataCF" = Table.ExpandTableColumn(#"Removed Columns", "dataCF", {"children"}, {"children"})
                        in
                            #"Expanded dataCF"
            in
                b   
    in
        if iCF or dCF then resTb3 else resTb1;

PrecoroAPI.payments = Value.ReplaceType(PrecoroAPI.paymentsImpl, byListType("Get Payments list"));
PrecoroAPI.paymentsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("payments", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );

PrecoroAPI.invoices = Value.ReplaceType(PrecoroAPI.invoicesImpl, byListType("Get Invoices list"));
PrecoroAPI.invoicesByIDN = Value.ReplaceType(PrecoroAPI.invoicesByIDNImpl, byListIDNType("Get invoices by IDN"));
PrecoroAPI.invoicesImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("invoices", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.invoicesByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("invoices", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

PrecoroAPI.receipts = Value.ReplaceType(PrecoroAPI.receiptsImpl, byListType("Get Receipts list"));
PrecoroAPI.receiptsByIDN = Value.ReplaceType(PrecoroAPI.receiptsByIDNImpl, byListIDNType("Get Receipts by IDN"));
PrecoroAPI.receiptsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("receipts", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.receiptsByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("receipts", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

PrecoroAPI.purchaseorders = Value.ReplaceType(PrecoroAPI.purchaseordersImpl, byListType("Get Purchase Orders list"));
PrecoroAPI.purchaseordersByIDN = Value.ReplaceType(PrecoroAPI.purchaseordersByIDNImpl, byListIDNType("Get Purchase Orders by IDN"));
PrecoroAPI.purchaseordersImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("purchaseorders", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.purchaseordersByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("purchaseorders", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

PrecoroAPI.requestforproposals = Value.ReplaceType(PrecoroAPI.requestforproposalsImpl, byListType("Get Request For Proposals list"));
PrecoroAPI.requestforproposalsByIDN = Value.ReplaceType(PrecoroAPI.requestforproposalsByIDNImpl, byListIDNType("Get Request For Proposals by IDN"));
PrecoroAPI.requestforproposalsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("requestforproposals", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.requestforproposalsByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("requestforproposals", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

PrecoroAPI.purchaserequisitions = Value.ReplaceType(PrecoroAPI.purchaserequisitionsImpl, byListType("Get Purchase Requisitions list"));
PrecoroAPI.purchaserequisitionsByIDN = Value.ReplaceType(PrecoroAPI.purchaserequisitionsByIDNImpl, byListIDNType("Get Purchase Requisitions by IDN"));
PrecoroAPI.purchaserequisitionsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("purchaserequisitions", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.purchaserequisitionsByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("purchaserequisitions", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

PrecoroAPI.warehouserequests = Value.ReplaceType(PrecoroAPI.warehouserequestsImpl, byListType("Get Warehouse Requests list"));
PrecoroAPI.warehouserequestsByIDN = Value.ReplaceType(PrecoroAPI.warehouserequestsByIDNImpl, byListIDNType("Get Warehouse Requests by IDN"));
PrecoroAPI.warehouserequestsImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any) => PrecoroAPI.GetDataFromEndpoint("warehouserequests", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields as any );
PrecoroAPI.warehouserequestsByIDNImpl = (optional #"createDate[left_date]" as date, optional #"createDate[right_date]" as date, optional include_DocumentCustomFields as any, optional include_ItemsCustomFields as any) => PrecoroAPI.GetDataFromEndpointByIDN("warehouserequests", #"createDate[left_date]",  #"createDate[right_date]", include_DocumentCustomFields, include_ItemsCustomFields );

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
byListType1 = (nm as text) => type function ()
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = nm
    ];

byListType2 = (nm as text) => type function (
                     optional #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                     optional #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = nm
    ];

byListType = (nm as text) => type function (
                     optional #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                     optional #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     optional include_DocumentCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = nm
    ];

byListIDNType = (nm as text) => type function (
                     optional #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                     optional #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     optional include_DocumentCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),
                     optional include_ItemsCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_ItemsCustomFields",
                        Documentation.FieldDescription = "include_ItemsCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])

                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = nm
    ];

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
PrecoroAPI.GetDataFromEndpoint = Value.ReplaceType(PrecoroAPI.GetDataFromEndpointImpl, PrecoroAPI.GetDataFromEndpointType);
PrecoroAPI.GetDataFromEndpointType =
type function (
                     endpoint as (type text meta
                        [
                        Documentation.FieldCaption = "endpoint",
                        Documentation.FieldDescription = "endpoint",
                        Documentation.SampleValues = {"warehouserequests", "purchaserequisitions"},
                        Documentation.AllowedValues = endpoints
                        ]
                     ),
                     optional #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                     optional #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     optional include_DocumentCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = "GetDataFromEndpoint",
            Documentation.LongDescription = "GetDataFromEndpoint"
    ];

PrecoroAPI.GetDataFromEndpointByIDN = Value.ReplaceType(PrecoroAPI.GetDataFromEndpointByIDNImpl, PrecoroAPI.GetDataFromEndpointByIDNType);
PrecoroAPI.GetDataFromEndpointByIDNType =
type function (      
                    endpoint as (type text meta
                        [
                        Documentation.FieldCaption = "endpoint",
                        Documentation.FieldDescription = "endpoint",
                        Documentation.SampleValues = {"warehouserequests", "purchaserequisitions"},
                        Documentation.AllowedValues = endpointsIDN
                        ]),
                     optional #"createDate[left_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[left_date]",
                        Documentation.FieldDescription = "createDate[left_date]"
                        ]),
                     optional #"createDate[right_date]" as (type date meta [
                        Documentation.FieldCaption = "createDate[right_date]",
                        Documentation.FieldDescription = "createDate[right_date]"
                        ]),
                     optional include_DocumentCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_DocumentCustomFields",
                        Documentation.FieldDescription = "include_DocumentCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),
                     optional include_ItemsCustomFields as (type any meta [
                        Documentation.FieldCaption = "include_ItemsCustomFields",
                        Documentation.FieldDescription = "include_ItemsCustomFields",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),
                     optional id_for_iteration as (type text meta [
                        Documentation.FieldCaption = "id_for_iteration",
                        Documentation.FieldDescription = "id_for_iteration",
                        Documentation.SampleValues = {"idn", "id"}
                        ]),
                    optional endpoint2 as (type text meta [
                        Documentation.FieldCaption = "endpoint2",
                        Documentation.FieldDescription = "endpoint2"
                        ])
           )
        as function meta [
            Documentation.Name = "GetDataFromEndpointByIDN",
            Documentation.LongDescription = "GetDataFromEndpointByIDN"
    ];


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PrecoroAPI.GetDataFromEndpointByIDNImpl = (
    endpoint as text,
    optional #"createDate[left_date]" as date, 
    optional #"createDate[right_date]" as date,
    optional include_DocumentCustomFields as any,
    optional include_ItemsCustomFields as any,
    optional id_for_iteration as text, // указать наименование поля для итераций, по умолчанию "idn"
    optional endpoint2 as text
    ) =>
        let
            id_name = if id_for_iteration is null then "idn" else "id",
            e2 = if endpoint2 is null then "" else endpoint2,
            tb = PrecoroAPI.GetDataFromEndpoint(endpoint, #"createDate[left_date]", #"createDate[right_date]", include_DocumentCustomFields),
            tabl_sel_col = Table.SelectColumns(tb, {id_name, "DocumentCustomFields"}, MissingField.UseNull ),

            dCF = if include_DocumentCustomFields is null then false else if include_DocumentCustomFields then true else false,

            tb_detail = Table.TransformRows(tabl_sel_col, each 
               //fCheckNullList( 
                    if dCF 
                    then  Record.AddField( PrecoroAPI.GetData( Text.From(endpoint) & "/" & Text.From( Record.Field(_, id_name)  ) & Text.From(e2) , []), "DocumentCustomFields", _[DocumentCustomFields] )
                    else  PrecoroAPI.GetData( Text.From(endpoint) & "/" & Text.From( Record.Field(_, id_name) ) & Text.From(e2), [])
                  //)
               ),

           tb1 = toTable(tb_detail, 1),

           add_items_custom_field = 
                        if include_ItemsCustomFields is null then tb1 else
                        if include_ItemsCustomFields then try PrecoroAPI.ItemsWithCustomFields(tb1) otherwise tb1 
                        else tb1
        in 
            add_items_custom_field;


PrecoroAPI.GetDataFromEndpointImpl = (
    endpoint as text,
    optional #"createDate[left_date]" as date, 
    optional #"createDate[right_date]" as date, 
    optional include_DocumentCustomFields as any
    ) =>
    let
        endpoint = endpoint,
        p = 
            let
                dt2 = if #"createDate[right_date]" is null then Date.From(DateTime.LocalNow()) else #"createDate[right_date]",
                b = add_rec([], "createDate[left_date]", Date.ToText(#"createDate[left_date]", "dd.MM.yyyy")), 
                c = add_rec(b, "createDate[right_date]", Date.ToText(dt2, "dd.MM.yyyy"))
            in 
                c,
        
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
                each List.Transform( [y][data], each _ )//fCheckNullList(_) )
            )
            ),
        tb = toTable(tb1, 1),

        incCF = if include_DocumentCustomFields is null then false else include_DocumentCustomFields,

        ExpDocCustomFields = 
            if incCF 
            then 
                try 
                    PrecoroAPI.DocumentWithCustomFields(
                        Table.ExpandRecordColumn(tb, "dataDocumentCustomFields", {"data"}, {"dataDocumentCustomFields.data"})
                        )
                otherwise tb
            else tb
    in
        ExpDocCustomFields;


PrecoroAPI.GetDataFromEndpoint1Impl = (
    endpoint as text
    ) =>
    let
        endpoint = endpoint,
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
                each List.Transform( [y][data], each _) //fCheckNullList(_) )
            )
            ),
        tb = toTable(tb1, 1)

    in
        tb;

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
                each List.Transform( [y][data], each _ ) //fCheckNullList(_) )
            )
            ),

        tb2 = toTable(tb1, 1),
        
        ExpandedOptions = Table.ExpandRecordColumn(tb2, "options", {"data"}, {"options.data"}),
        ExpandedOptionsData  = Table.ExpandListColumn(ExpandedOptions, "options.data"),
        ExpandedOptionsData1 = Table.ExpandRecordColumn(ExpandedOptionsData, "options.data", {"id", "name", "code", "label", "level", "parent", "enable"}, {"options.data.id", "options.data.name", "options.data.code", "options.data.label", "options.data.level", "options.data.parent", "options.data.enable"}),
        #"Changed Type" = Table.TransformColumnTypes(ExpandedOptionsData1,{{"id", Int64.Type}, {"options.data.id", Text.Type}}),
        #"Expanded options.data.parent" = Table.ExpandRecordColumn(#"Changed Type", "options.data.parent", {"id"}, {"options.data.parent.id"}),
        #"Removed Other Columns" = Table.SelectColumns(#"Expanded options.data.parent",{"id", "name", "options.data.id", "type", "options.data.name", "options.data.code", "options.data.level", "options.data.parent.id"}),
        #"Changed Type1" = Table.TransformColumnTypes(#"Removed Other Columns",{{"options.data.parent.id", Int64.Type}}),
        tb_to_buf = Table.Buffer(#"Changed Type1"),
        #"Invoked Custom Function" = Table.AddColumn(tb_to_buf, "Hierarchy", each if [type]=1 then pChild(tb_to_buf, [options.data.id], [id], []) else null)
in
    #"Invoked Custom Function";
      
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
        #"Changed Type" = Table.TransformColumnTypes(tb2, {{"id", Int64.Type}})
in
    #"Changed Type";

PrecoroAPI.GetItemCustomFieldsExpand = () =>
    let

        tb2 = PrecoroAPI.GetItemCustomFields(),
        
        #"Expanded options" = Table.ExpandRecordColumn(tb2, "options", {"data"}, {"options.data"}),
        #"Expanded options.data" = Table.ExpandListColumn(#"Expanded options", "options.data"),
        #"Expanded options.data1" = Table.ExpandRecordColumn(#"Expanded options.data", "options.data", {"id", "name", "code", "label", "level", "parent", "externalId", "enable"}, {"options.data.id", "options.data.name", "options.data.code", "options.data.label", "options.data.level", "options.data.parent", "options.data.externalId", "options.data.enable"}),
        #"Expanded options.data.parent" = Table.ExpandRecordColumn(#"Expanded options.data1", "options.data.parent", {"id"}, {"options.data.parent.id"}),
        #"Changed Type" = Table.TransformColumnTypes(#"Expanded options.data.parent",{{"id", Int64.Type}, {"options.data.id", Text.Type},{"options.data.parent.id", Int64.Type}}),
        #"Invoked Custom Function" = Table.AddColumn(#"Changed Type", "Hierarchy", each  if [type]=1 then pChild(#"Changed Type", [options.data.id], [id], []) else null)
in
    #"Invoked Custom Function";



PrecoroAPI.DocumentWithCustomFields = (doc_tb as table) =>
    let
        cf_dim = PrecoroAPI.GetDocumentCustomFields(),
        doc = doc_tb,
        #"Removed Other Columns" = Table.SelectColumns(doc,{"id", "dataDocumentCustomFields.data"}),
        #"Expanded dataDocumentCustomFields.data" = Table.ExpandListColumn(#"Removed Other Columns", "dataDocumentCustomFields.data"),
        #"Expanded dataDocumentCustomFields.data1" = Table.ExpandRecordColumn(#"Expanded dataDocumentCustomFields.data", "dataDocumentCustomFields.data", {"value", "documentCustomField", "type"}, {"CustomFields.value", "CustomFields.documentCustomField", "CustomFields.type"}),
        #"Expanded CustomFields.documentCustomField" = Table.ExpandRecordColumn(#"Expanded dataDocumentCustomFields.data1", "CustomFields.documentCustomField", {"id"}, {"CustomFields.documentCustomField.id"}),
        #"Changed Type" = Table.TransformColumnTypes(#"Expanded CustomFields.documentCustomField",{{"CustomFields.documentCustomField.id", Int64.Type}, {"CustomFields.value", Text.Type}}),
        
        add_key_val = Table.AddColumn( #"Changed Type", "CustomFields.value_key", each if [CustomFields.type]=1 then [CustomFields.value] else null ),
        #"Merged Queries" = Table.NestedJoin(add_key_val, {"CustomFields.documentCustomField.id", "CustomFields.value_key"}, cf_dim, {"id", "options.data.id"}, "Invoked Function", JoinKind.LeftOuter),

        // select_step

        #"Expanded Invoked Function" = Table.ExpandTableColumn(#"Merged Queries", "Invoked Function", {"name", "options.data.name", "options.data.code", "Hierarchy"}, {"name", "options.data.name", "options.data.code", "Hierarchy"}),
        #"Added Custom" = 
            Table.AddColumn(#"Expanded Invoked Function", "CustomField", 
                each
                    if [CustomFields.value_key] is null 
                    then Record.AddField([], [name], [CustomFields.value] )
                    else Record.AddField([],
                            //Record.AddField(
                                //Record.AddField([], [name] & "_Code", [options.data.code] )
                            //,[name] & "_Name", [options.data.name])
                        [name] & "_Hierarchy", [Hierarchy])
                    ),
        #"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"CustomFields.value", "CustomFields.documentCustomField.id", "name", "options.data.name", "options.data.code", "CustomFields.value_key", "Hierarchy"}),
        #"Grouped Rows" = Table.Group(#"Removed Columns", {"id"}, {{"CustomFields", each try Record.Combine(_[CustomField]) otherwise [] , type record }}),
        
        #"MergedToDoc" = Table.NestedJoin(doc, {"id"}, #"Grouped Rows", {"id"}, "CustomFieldsRec", JoinKind.LeftOuter),
        exp_tb = Table.ExpandTableColumn(#"MergedToDoc", "CustomFieldsRec", {"CustomFields"}, {"DocumentCustomFields"})
    in
        exp_tb;

PrecoroAPI.ItemsWithCustomFields = (doc_tb as table) =>
let
    #"Invoked FunctionGetPurchaseOrdersByIDN1" = Table.Buffer(doc_tb),
    cf_dim = Table.Buffer(PrecoroAPI.GetItemCustomFieldsExpand()),
    cf_dim0 = Table.Buffer(PrecoroAPI.GetItemCustomFields()),
    #"Removed Other Columns" = Table.SelectColumns(#"Invoked FunctionGetPurchaseOrdersByIDN1",{"id", "items"}),
    #"Expanded items" = Table.ExpandRecordColumn(#"Removed Other Columns", "items", {"data"}, {"items.data"}),
    #"transformNullToEmptyRecords" = Table.TransformColumns(#"Expanded items", {"items.data", (v)=> if List.IsEmpty(v) then {[]} else v }),

    #"Expanded items.data" = Table.ExpandListColumn( #"transformNullToEmptyRecords", "items.data"),
    
    
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded items.data", "items.data", "items.data - Copy"),
    #"Expanded items.data1" = Table.ExpandRecordColumn(#"Duplicated Column", "items.data", {"id", "dataItemCustomFields"}, {"items.data.id", "items.data.dataItemCustomFields"}),
    #"Expanded items.data.dataProductCustomFields" = Table.ExpandRecordColumn(#"Expanded items.data1", "items.data.dataItemCustomFields", {"data"}, {"items.data.dataItemCustomFields.data"}),
    #"Expanded items.data.dataProductCustomFields.data" = Table.ExpandListColumn(#"Expanded items.data.dataProductCustomFields", "items.data.dataItemCustomFields.data"),
    #"Expanded items.data.dataProductCustomFields.data1" = Table.ExpandRecordColumn(#"Expanded items.data.dataProductCustomFields.data", "items.data.dataItemCustomFields.data", {"value", "itemCustomField"}, {"ItemCustomFields.value", "ItemCustomFields.ItemCustomField"}),
    #"Expanded ProductCustomFields.productCustomField" = Table.ExpandRecordColumn(#"Expanded items.data.dataProductCustomFields.data1", "ItemCustomFields.ItemCustomField", {"id"}, {"ItemCustomField.id"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded ProductCustomFields.productCustomField",{{"ItemCustomFields.value", Text.Type}, {"ItemCustomField.id", Int64.Type}}),
    
    #"Merged Type" = Table.NestedJoin(#"Changed Type", {"ItemCustomField.id"}, cf_dim0, {"id"}, "ItemCustomFieldsType", JoinKind.LeftOuter),
    #"ExpandedType" = Table.ExpandTableColumn(#"Merged Type", "ItemCustomFieldsType", {"type"}, {"ItemCustomFields.type"}),
    #"Changed Type1" = Table.TransformColumnTypes( #"ExpandedType",{{"ItemCustomFields.type", Int64.Type}}),
    add_key_val = Table.AddColumn(#"Changed Type1", "ItemCustomFields.value_key", each if [ItemCustomFields.type]=1 then [ItemCustomFields.value] else null ),
    #"Changed Type2" = Table.TransformColumnTypes( add_key_val,{{"ItemCustomFields.value_key", Text.Type}}),

    #"Merged Queries" = Table.NestedJoin(#"Changed Type2", {"ItemCustomField.id", "ItemCustomFields.value_key"}, cf_dim, {"id", "options.data.id"}, "ItemCustomFields", JoinKind.LeftOuter),
    #"Expanded Invoked Function" = Table.ExpandTableColumn(#"Merged Queries", "ItemCustomFields", {"name", "options.data.name", "options.data.code", "Hierarchy"}, {"name", "options.data.name", "options.data.code", "Hierarchy"}),
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    #"Added CustomField" = 
        Table.AddColumn(#"Expanded Invoked Function", "CustomField", 
          each
               if [ItemCustomFields.value_key] is null 
               then Record.AddField([], [name], [ItemCustomFields.value] )
               else Record.AddField([], [name] & "_Hierarchy", [Hierarchy] )
        ),
               
    //#"Expanded ItemCustomFields" = Table.ExpandTableColumn(#"Merged Queries", "ItemCustomFields", {"CustomField"}, {"CustomField"}),
    #"Grouped Rows" = Table.Group(#"Added CustomField", {"id", "items.data.id", "items.data - Copy"}, {{"CustomFields", each try Record.Combine(_[CustomField]) otherwise [] , type record }}),
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
        bn = Web.Contents(url, [Headers = h, Query = params, ManualCredentials = true]),
        json = replaceEmptyListToEmptyRecord(bn)
    in
        json;

// Data Source Kind description
PrecoroAPI = [
    TestConnection = (dataSourcePath) => { "Precoro.Company", Json.Document(dataSourcePath)[Company name] },
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
    isLeafColumn as text,
    sort as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [   
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn,
            NavigationTable.sort = sort
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;


fCheckNullList = (rec as record) =>
    let
        rec = Record.TransformFields( rec,
            {
                {"budget",       each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"approvalStep", each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"approvingWay", each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"lastApprover", each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"lastEditor",   each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"purchaseOrder", each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"warehouse",    each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"location",    each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"egalEntity",    each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ },
                {"exchangeRate",    each if Value.Type(_) = List.Type then if List.IsEmpty(_) then [] else _ else _ }
                 
            }
            ,MissingField.Ignore )
    in
        rec;


pChild = (tb as table, parent_id as any, id as any, res as record) => 
    let
        s1 = Table.ToRecords(Table.SelectRows(tb, each [options.data.id] = Text.From(parent_id) and [id]=id )){0},
        name = Text.From(s1[name]),
        lv = Text.From(s1[options.data.level]),
        next_parent = Number.From(s1[options.data.parent.id]),
        res_ = Record.AddField( 
                    Record.AddField(res, name &"_Code_lv"& lv, s1[options.data.code]),
                    name &"_Name_lv"& lv, s1[options.data.name]
        )
                    
    in
         if parent_id is null then res else @pChild(tb, next_parent, id, res_);

/*
fnCFBudget = 
    (tb as table, filter as text) =>
        let
            values = Text.Split(filter, ","),
            tbRes = Table.SelectRows(tb, each List.Contains(values, [options.data.id]) ),
            tbSelCol = Table.SelectColumns( tbRes, {"Hierarchy"} )
        in
            tbSelCol[Hierarchy];
*/

fnCFBudget = 
    (tb as table, filter as any) =>
        let
            fiSTR = if filter is null then "" else filter,
            values = Text.Split(fiSTR, ","),
            tbRes = if filter is null then tb else Table.SelectRows(tb, each List.Contains(values, [options.data.id]) ),
            tbSelCol = Table.AddColumn( Table.SelectColumns( tbRes, {"options.data.id", "Hierarchy"} ), "rec", each Record.AddField([],[options.data.id], [Hierarchy]))
        in
            Record.Combine(tbSelCol[rec]);

replaceEmptyListToEmptyRecord = (bn as binary) =>
    let
        toText = Text.FromBinary(bn),
        textReplace = Text.Replace(Text.Replace(toText,":[]", ":null" ), "{""data"":null", "{""data"":[]" ),
        toJson = Json.Document(textReplace)
    in
        toJson;

add_rec = (rec as record, recname as text, value as any) =>
    if value is null then rec else Record.AddField(rec, recname, value);