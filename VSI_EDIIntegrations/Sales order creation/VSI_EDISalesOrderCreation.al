
codeunit 50103 VSI_EDISalesOrderCreation
{
    trigger OnRun()
    begin
    end;

    var
        SalesOrders: List of [Text];
        HeaderCreated: Boolean;

    procedure Create(TextXML: text) HeaderResponse: Text

    var
        check: Boolean;
        doc: XmlDocument;

    begin
        XmlDocument.ReadFrom(TextXML, doc);
        HeaderResponse := createHeader(doc);
    end;

    // This procedure will create sales order header
    procedure createHeader(doc: XmlDocument) Response: Text

    var
        //variables for xml parsing
        vConvertedContent: text;
        varTempBlob: Codeunit "Temp Blob";
        varInStream: InStream;
        varOutStream: OutStream;
        xmlNodeListParent: XmlNodeList;

        salesOrderXML: Text;
        xmlParentNode: XmlNode;
        xmlChildNode: XmlNode;
        i: integer;
        coundHeaders: Integer;
        check: Boolean;

        // variables to store values from xml nodes - sales header
        SalesHeader: Record "Sales Header";
        Document_Type: Enum "Sales Document Type";
        DocumentType: Text[30];
        Sell_to_Customer_No: Code[20];
        Sell_to_Customer_Name: Text[100];
        Posting_Description: Text[100];
        Sell_to_Address: Text[100];
        Sell_to_City: Text[30];
        Sell_to_County: Text[30];
        Sell_to_Post_Code: Code[20];
        Sell_to_Country_Region_Code: Code[10];
        Sell_to_Contact_No: Code[20];
        Sell_to_Contact: Text[100];
        No_of_Archived_Versions: Decimal;
        Document_Date: Date;
        Posting_Date: Date;
        Order_Date: Date;
        ArchivedVersionStr: Text[250];
        DocumentDateStr: Text[30];
        PostingDateStr: Text[30];
        OrderDateStr: Text[30];
        DueDateStr: Text[30];
        Requested_Delivery_DateStr: Text[30];
        Promised_Delivery_DateStr: Text[30];
        Due_Date: Date;
        Requested_Delivery_Date: Date;
        Promised_Delivery_Date: Date;
        Salesperson_Code: Code[20];
        External_Document_No: Code[35];
        Campaign_No: Code[20];
        Opportunity_No: Code[20];
        Responsibility_Center: Code[10];
        Assigned_User_ID: Code[50];
        Job_Queue_Status: Option " ","Scheduled for Posting",Error,Posting;
        JobQueueStatus: Text[30];
        Status: Option Open,Released,"Pending Approval","Pending Prepayment";
        StatusStr: Text[30];
        Currency_Code: Code[10];
        Payment_Terms_Code: Code[10];
        Payment_Method_Code: Code[10];
        Tax_Liable: Boolean;
        TaxLiable: Text[30];
        Tax_Area_Code: Code[20];
        Transaction_Type: Code[10];
        Shortcut_Dimension_1_Code: Code[20];
        Shortcut_Dimension_2_Code: Code[20];
        Payment_Discount_Percent: Decimal;
        PaymentDiscountPercent: Text[30];
        Pmt_Discount_Date: Date;
        PmtDiscountDate: Text[30];
        Direct_Debit_Mandate_ID: Code[35];
        Ship_to_Code: Code[10];
        Ship_to_Name: Text[50];
        Ship_to_Address: Text[50];
        Ship_to_Address_2: Text[50];
        Ship_to_City: Text[30];
        Ship_to_County: Text[30];
        Ship_to_Post_Code: Code[20];
        Ship_to_Country_Region_Code: Code[10];
        Ship_to_UPS_Zone: Code[2];
        Ship_to_Contact: Text[50];
        Shipment_Method_Code: Code[10];
        Shipping_Agent_Code: Code[10];
        Shipping_Agent_Service_Code: Code[10];
        Package_Tracking_No: Text[30];
        Bill_to_Customer_No: Code[20];
        Bill_to_Name: Text[50];
        Bill_to_Address: Text[50];
        Bill_to_Address_2: Text[50];
        Bill_to_City: Text[30];
        Bill_to_County: Text[30];
        Bill_to_Post_Code: Code[20];
        Bill_to_Country_Region_Code: Code[10];
        Bill_to_Contact_No: Code[20];
        Bill_to_Contact: Text[50];
        Location_Code: Code[10];
        Shipment_Date: Date;
        ShipmentDate: Text[30];
        Shipping_Advice: Option Partial,Complete;
        ShippingAdvice: Text[30];
        Outbound_Whse_Handling_Time: DateFormula;
        OutboundWhseHandlingTime: Text[30];
        Shipping_Time: DateFormula;
        ShippingTime: text[30];
        Late_Order_Shipping: Boolean;
        LateOrderShipping: Text[30];
        Transaction_Specification: Code[10];
        Transport_Method: Code[10];
        Exit_Point: Code[10];
        AreaSO: Code[10];
        Prepayment_Percent: Decimal;
        PrepaymentPercent: Text[30];
        Compress_Prepayment: Boolean;
        CompressPrepayment: Text[30];
        Prepmt_Payment_Terms_Code: Code[10];
        Prepayment_Due_Date: Date;
        PrepaymentDueDate: text[30];
        Prepmt_Payment_Discount_Percent: Decimal;
        PrepmtPaymentDiscountPercent: Text[30];
        Prepmt_Pmt_Discount_Date: Date;
        PrepmtPmtDiscountDate: Text[30];
        Prepmt_Include_Tax: Boolean;
        PrepmtIncludeTax: Text[30];
        Date_Filter: Date;
        DateFilter: Text[30];
        SalesHeaderObj: Record "Sales Header";
        ii: Integer;

    begin
        doc.SelectNodes('.//SalesOrders', xmlNodeListParent);
        coundHeaders := xmlNodeListParent.Count;
        // looping all sales order header nodes
        for i := 1 to xmlNodeListParent.Count do begin
            if xmlNodeListParent.Get(i, xmlParentNode) then begin
                if xmlParentNode.SelectSingleNode('.//Sell_to_Customer_No', xmlChildNode) then
                    Sell_to_Customer_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Customer_Name', xmlChildNode) then
                    Sell_to_Customer_Name := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Document_Type', xmlChildNode) then
                    DocumentType := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Posting_Description', xmlChildNode) then
                    Posting_Description := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Address', xmlChildNode) then
                    Sell_to_Address := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_City', xmlChildNode) then
                    Sell_to_City := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_County', xmlChildNode) then
                    Sell_to_County := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Post_Code', xmlChildNode) then
                    Sell_to_Post_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Country_Region_Code', xmlChildNode) then
                    Sell_to_Country_Region_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Contact_No', xmlChildNode) then
                    Sell_to_Contact_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Sell_to_Contact', xmlChildNode) then
                    Sell_to_Contact := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//No_of_Archived_Versions', xmlChildNode) then
                    ArchivedVersionStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Document_Date', xmlChildNode) then
                    DocumentDateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Posting_Date', xmlChildNode) then
                    PostingDateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Order_Date', xmlChildNode) then
                    OrderDateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Due_Date', xmlChildNode) then
                    DueDateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Requested_Delivery_Date', xmlChildNode) then
                    Requested_Delivery_DateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Promised_Delivery_Date', xmlChildNode) then
                    Promised_Delivery_DateStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Salesperson_Code', xmlChildNode) then
                    Salesperson_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//External_Document_No', xmlChildNode) then
                    External_Document_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Campaign_No', xmlChildNode) then
                    Campaign_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Opportunity_No', xmlChildNode) then
                    Opportunity_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Responsibility_Center', xmlChildNode) then
                    Responsibility_Center := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Assigned_User_ID', xmlChildNode) then
                    Assigned_User_ID := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Job_Queue_Status', xmlChildNode) then
                    JobQueueStatus := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Status', xmlChildNode) then
                    StatusStr := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Currency_Code', xmlChildNode) then
                    Currency_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Payment_Terms_Code', xmlChildNode) then
                    Payment_Terms_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Payment_Method_Code', xmlChildNode) then
                    Payment_Method_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Tax_Liable', xmlChildNode) then
                    TaxLiable := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Tax_Area_Code', xmlChildNode) then
                    Tax_Area_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Transaction_Type', xmlChildNode) then
                    Transaction_Type := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shortcut_Dimension_1_Code', xmlChildNode) then
                    Shortcut_Dimension_1_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shortcut_Dimension_2_Code', xmlChildNode) then
                    Shortcut_Dimension_2_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Payment_Discount_Percent', xmlChildNode) then
                    PaymentDiscountPercent := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Pmt_Discount_Date', xmlChildNode) then
                    PmtDiscountDate := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Direct_Debit_Mandate_ID', xmlChildNode) then
                    Direct_Debit_Mandate_ID := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Code', xmlChildNode) then
                    Ship_to_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Name', xmlChildNode) then
                    Ship_to_Name := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Address', xmlChildNode) then
                    Ship_to_Address := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Address_2', xmlChildNode) then
                    Ship_to_Address_2 := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_City', xmlChildNode) then
                    Ship_to_City := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_County', xmlChildNode) then
                    Ship_to_County := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Post_Code', xmlChildNode) then
                    Ship_to_Post_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Country_Region_Code', xmlChildNode) then
                    Ship_to_Country_Region_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_UPS_Zone', xmlChildNode) then
                    Ship_to_UPS_Zone := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Ship_to_Contact', xmlChildNode) then
                    Ship_to_Contact := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipment_Method_Code', xmlChildNode) then
                    Shipment_Method_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipping_Agent_Code', xmlChildNode) then
                    Shipping_Agent_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipping_Agent_Service_Code', xmlChildNode) then
                    Shipping_Agent_Service_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Package_Tracking_No', xmlChildNode) then
                    Package_Tracking_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Customer_No', xmlChildNode) then
                    Bill_to_Customer_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Name', xmlChildNode) then
                    Bill_to_Name := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Address', xmlChildNode) then
                    Bill_to_Address := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Address_2', xmlChildNode) then
                    Bill_to_Address_2 := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_City', xmlChildNode) then
                    Bill_to_City := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_County', xmlChildNode) then
                    Bill_to_County := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Post_Code', xmlChildNode) then
                    Bill_to_Post_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Country_Region_Code', xmlChildNode) then
                    Bill_to_Country_Region_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Contact_No', xmlChildNode) then
                    Bill_to_Contact_No := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Bill_to_Contact', xmlChildNode) then
                    Bill_to_Contact := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Location_Code', xmlChildNode) then
                    Location_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipment_Date', xmlChildNode) then
                    ShipmentDate := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipping_Advice', xmlChildNode) then
                    ShippingAdvice := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Outbound_Whse_Handling_Time', xmlChildNode) then
                    OutboundWhseHandlingTime := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Shipping_Time', xmlChildNode) then
                    ShippingTime := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Late_Order_Shipping', xmlChildNode) then
                    LateOrderShipping := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Transaction_Specification', xmlChildNode) then
                    Transaction_Specification := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Transport_Method', xmlChildNode) then
                    Transport_Method := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Exit_Point', xmlChildNode) then
                    Exit_Point := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Area', xmlChildNode) then
                    AreaSO := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Date_Filter', xmlChildNode) then
                    DateFilter := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepmt_Include_Tax', xmlChildNode) then
                    PrepmtIncludeTax := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepmt_Pmt_Discount_Date', xmlChildNode) then
                    PrepmtPmtDiscountDate := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepmt_Payment_Discount_Percent', xmlChildNode) then
                    PrepmtPaymentDiscountPercent := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepayment_Due_Date', xmlChildNode) then
                    PrepaymentDueDate := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepmt_Payment_Terms_Code', xmlChildNode) then
                    Prepmt_Payment_Terms_Code := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Compress_Prepayment', xmlChildNode) then
                    CompressPrepayment := xmlChildNode.AsXmlElement().InnerText;
                if xmlParentNode.SelectSingleNode('.//Prepayment_Percent', xmlChildNode) then
                    PrepaymentPercent := xmlChildNode.AsXmlElement().InnerText;

                // evaluating values
                if ArchivedVersionStr <> '' then
                    EVALUATE(No_of_Archived_Versions, ArchivedVersionStr);
                if PrepaymentPercent <> '' then
                    EVALUATE(Prepayment_Percent, PrepaymentPercent);
                if CompressPrepayment <> '' then
                    EVALUATE(Compress_Prepayment, CompressPrepayment);
                if PrepaymentDueDate <> '' then
                    EVALUATE(Prepayment_Due_Date, PrepaymentDueDate);
                if PrepmtPaymentDiscountPercent <> '' then
                    EVALUATE(Prepmt_Payment_Discount_Percent, PrepmtPaymentDiscountPercent);
                if PrepmtPmtDiscountDate <> '' then
                    EVALUATE(Prepmt_Pmt_Discount_Date, PrepmtPmtDiscountDate);
                if PrepmtIncludeTax <> '' then
                    EVALUATE(Prepmt_Include_Tax, PrepmtIncludeTax);
                if DateFilter <> '' then
                    EVALUATE(Date_Filter, DateFilter);
                if ShipmentDate <> '' then
                    EVALUATE(Shipment_Date, ShipmentDate);
                if ShippingAdvice <> '' then
                    EVALUATE(Shipping_Advice, ShippingAdvice);
                if OutboundWhseHandlingTime <> '' then
                    EVALUATE(Outbound_Whse_Handling_Time, OutboundWhseHandlingTime);
                if ShippingTime <> '' then
                    EVALUATE(Shipping_Time, ShippingTime);
                if LateOrderShipping <> '' then
                    EVALUATE(Late_Order_Shipping, LateOrderShipping);
                if PmtDiscountDate <> '' then
                    EVALUATE(Pmt_Discount_Date, PmtDiscountDate);
                if PaymentDiscountPercent <> '' then
                    EVALUATE(Payment_Discount_Percent, PaymentDiscountPercent);
                if TaxLiable <> '' then
                    EVALUATE(Tax_Liable, TaxLiable);
                if DocumentType <> '' then
                    EVALUATE(Document_Type, DocumentType);
                if OrderDateStr <> '' then
                    EVALUATE(Order_Date, OrderDateStr);
                if PostingDateStr <> '' then
                    EVALUATE(Posting_Date, PostingDateStr);
                if DocumentDateStr <> '' then
                    EVALUATE(Document_Date, DocumentDateStr);
                if DueDateStr <> '' then
                    EVALUATE(Due_Date, DueDateStr);
                if Requested_Delivery_DateStr <> '' then
                    EVALUATE(Requested_Delivery_Date, Requested_Delivery_DateStr);
                if Promised_Delivery_DateStr <> '' then
                    EVALUATE(Promised_Delivery_Date, Promised_Delivery_DateStr);
                if JobQueueStatus <> '' then
                    EVALUATE(Job_Queue_Status, JobQueueStatus);
                if StatusStr <> '' then
                    EVALUATE(Status, StatusStr);

                // inserting records in sales order header table
                System.Clear(xmlChildNode);
                System.Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader.Validate("Document Type", Document_Type);
                SalesHeader.Validate("Sell-to Customer No.", Sell_to_Customer_No);
                if Sell_to_Customer_Name <> '' then
                    SalesHeader.Validate("Sell-to Customer Name", Sell_to_Customer_Name);
                SalesHeader.Validate("Posting Description", Posting_Description);
                SalesHeader.Validate("Sell-to Address", Sell_to_Address);
                SalesHeader.Validate("Sell-to City", Sell_to_City);
                SalesHeader.Validate("Sell-to County", Sell_to_County);
                SalesHeader.Validate("Sell-to Post Code", Sell_to_Post_Code);
                SalesHeader.Validate("Sell-to Country/Region Code", Sell_to_Country_Region_Code);
                SalesHeader.Validate("Sell-to Contact No.", Sell_to_Contact_No);
                SalesHeader.Validate("Sell-to Contact", Sell_to_Contact);
                SalesHeader."No. of Archived Versions" := No_of_Archived_Versions;
                if OrderDateStr <> '' then
                    SalesHeader.Validate("Order Date", Order_Date)
                else
                    SalesHeader.Validate("Order Date", Today());
                if PostingDateStr <> '' then
                    SalesHeader.validate("Posting Date", Posting_Date)
                else
                    SalesHeader.Validate("Posting Date", Today());
                if DocumentDateStr <> '' then
                    SalesHeader.validate("Document Date", Document_Date)
                else
                    SalesHeader.Validate("Document Date", Today());
                if Requested_Delivery_DateStr <> '' then
                    SalesHeader.Validate("Requested Delivery Date", Requested_Delivery_Date)
                else
                    SalesHeader.Validate("Requested Delivery Date", Today());
                SalesHeader.validate("Assigned User ID", Assigned_User_ID);
                SalesHeader.validate("Job Queue Status", Job_Queue_Status);
                SalesHeader.validate("Status", Status);
                SalesHeader.Validate("Currency Code", Currency_Code);
                SalesHeader.Validate("Payment Terms Code", Payment_Terms_Code);
                SalesHeader.Validate("Payment Method Code", Payment_Method_Code);
                SalesHeader.Validate("Tax Liable", Tax_Liable);
                SalesHeader.Validate("Tax Area Code", Tax_Area_Code);
                SalesHeader.validate("Transaction Type", Transaction_Type);
                SalesHeader.Validate("Shortcut Dimension 1 Code", Shortcut_Dimension_1_Code);
                SalesHeader.Validate("Shortcut Dimension 2 Code", Shortcut_Dimension_2_Code);
                SalesHeader.Validate("Payment Discount %", Payment_Discount_Percent);
                SalesHeader.Validate("Pmt. Discount Date", Pmt_Discount_Date);
                SalesHeader.Validate("Direct Debit Mandate ID", Direct_Debit_Mandate_ID);
                SalesHeader.Validate("Shipment Method Code", Shipment_Method_Code);
                SalesHeader.Validate("Shipping Agent Code", Shipping_Agent_Code);
                SalesHeader.Validate("Shipping Agent Service Code", Shipping_Agent_Service_Code);
                SalesHeader.Validate("Package Tracking No.", Package_Tracking_No);
                if Bill_to_Customer_No <> '' then
                    SalesHeader.Validate("Bill-to Customer No.", Bill_to_Customer_No);
                SalesHeader."Bill-to Name" := Bill_to_Name;
                SalesHeader.Validate("Bill-to Address", Bill_to_Address);
                SalesHeader.Validate("Bill-to Address 2", Bill_to_Address_2);
                SalesHeader.Validate("Bill-to City", Bill_to_City);
                SalesHeader.Validate("Bill-to County", Bill_to_County);
                SalesHeader.Validate("Bill-to Post Code", Bill_to_Post_Code);
                SalesHeader.Validate("Bill-to Country/Region Code", Bill_to_Country_Region_Code);
                SalesHeader.Validate("Bill-to Contact No.", Bill_to_Contact_No);
                SalesHeader.Validate("Bill-to Contact", Bill_to_Contact);
                SalesHeader.Validate("Bill-to Address 2", Bill_to_Address_2);

                // if location code is given then address will be populates automatically from location
                // else address will be filled by provided values
                if Location_Code <> '' then begin
                    SalesHeader.Validate("Location Code", Location_Code)
                end
                else begin
                    SalesHeader.Validate("Ship-to Code", Ship_to_Code);
                    SalesHeader.Validate("Ship-to Name", Ship_to_Name);
                    SalesHeader.Validate("Ship-to Address", Ship_to_Address);
                    SalesHeader.Validate("Ship-to Address 2", Ship_to_Address_2);
                    SalesHeader.Validate("Ship-to City", Ship_to_City);
                    SalesHeader.Validate("Ship-to County", Ship_to_County);
                    SalesHeader.Validate("Ship-to Post Code", Ship_to_Post_Code);
                    SalesHeader.Validate("Ship-to Country/Region Code", Ship_to_Country_Region_Code);
                    SalesHeader.Validate("Ship-to UPS Zone", Ship_to_UPS_Zone);
                    SalesHeader.Validate("Ship-to Contact", Ship_to_Contact);
                end;

                SalesHeader.Validate("Shipment Date", Shipment_Date);
                SalesHeader.Validate("Shipping Advice", Shipping_Advice);
                SalesHeader.Validate("Outbound Whse. Handling Time", Outbound_Whse_Handling_Time);
                SalesHeader.Validate("Shipping Time", Shipping_Time);
                SalesHeader."Late Order Shipping" := Late_Order_Shipping;
                SalesHeader.Validate("Transaction Specification", Transaction_Specification);
                SalesHeader.Validate("Transport Method", Transport_Method);
                SalesHeader.Validate("External Document No.", External_Document_No);
                SalesHeader.Validate("Exit Point", Exit_Point);
                SalesHeader.Validate("Area", AreaSO);
                SalesHeader.Validate("Date Filter", Date_Filter);
                SalesHeader.Validate("Prepmt. Include Tax", Prepmt_Include_Tax);
                SalesHeader.Validate("Prepmt. Payment Discount %", Prepmt_Payment_Discount_Percent);
                SalesHeader.Validate("Prepmt. Pmt. Discount Date", Prepmt_Pmt_Discount_Date);
                SalesHeader.Validate("Prepmt. Payment Terms Code", Prepmt_Payment_Terms_Code);
                SalesHeader.Validate("Prepayment Due Date", Prepayment_Due_Date);
                SalesHeader.Validate("Compress Prepayment", Compress_Prepayment);
                SalesHeader.Validate("Prepayment %", Prepayment_Percent);
                SalesHeader.Insert(true);
                // calling sales lines creation procedure
                createLines(xmlParentNode, SalesHeader."No.");
                SalesOrders.Add(SalesHeader."No.");
            end;
        end;
        for ii := 1 to SalesOrders.Count do begin
            if SalesHeaderObj.Get(SalesHeader."Document Type", SalesOrders.Get(ii)) then
                Response := Response + StrSubstNo(' {Status: Success , %1},', SalesHeaderObj."No.")
            else
                Response := 'Sales Order creation failed';
        end;
    end;

    // This procedure will create sales lines
    procedure createLines(xmlParentNode: XmlNode; DocumentNo: code[20])
    var
        SalesLine: Record "Sales Line";
        SalesLineObj: Record "Sales Line";

        // variables to store values from xml nodes - sales header
        Document_Type: Enum "Sales Document Type";
        DocumentType: Text[30];
        No: Code[20];
        CrossReferenceNo: Code[20];
        ICPartnerCode: Code[20];
        ICPartnerReference: Code[20];
        VariantCode: Code[10];
        PurchasingCode: Code[10];
        ReturnReasonCode: Code[10];
        VATProdPostingGroup: Code[20];
        LocationCode: Code[10];
        BinCode: Code[20];
        UnitofMeasureCode: Code[10];
        TaxAreaCode: Code[20];
        TaxGroupCode: Code[20];
        ShippingAgentCode: Code[10];
        ShippingAgentServiceCode: Code[10];
        WorkTypeCode: Code[10];
        BlanketOrderNo: Code[20];
        DepreciationBookCode: Code[10];
        DuplicateinDepreciationBook: Code[10];
        DeferralCode: Code[10];
        ShortcutDimension1Code: Code[20];
        ShortcutDimension2Code: Code[20];
        Description: Text[100];
        PackageTrackingNo: Text[30];
        UnitofMeasure: Text[50];
        RequestedDeliveryDate: Date;
        PromisedDeliveryDate: Date;
        PlannedDeliveryDate: Date;
        PlannedShipmentDate: Date;
        ShipmentDate: Date;
        FAPostingDate: Date;
        RequestedDeliveryDateStr: Text[50];
        PromisedDeliveryDateStr: Text[50];
        PlannedDeliveryDateStr: Text[50];
        PlannedShipmentDateStr: Text[50];
        ShipmentDateStr: Text[50];
        FAPostingDateStr: Text[50];
        ShippingTime: DateFormula;
        OutboundWhseHandlingTime: DateFormula;
        ShippingTimeStr: Text[50];
        OutboundWhseHandlingTimeStr: Text[50];
        LineNo: Integer;
        ApplfromItemEntry: Integer;
        AppltoItemEntry: Integer;
        BlanketOrderLineNo: Integer;
        ApplfromItemEntryStr: Text[50];
        AppltoItemEntryStr: Text[50];
        BlanketOrderLineNoStr: Text[50];
        Nonstock: Boolean;
        DropShipment: Boolean;
        SpecialOrder: Boolean;
        SubstitutionAvailable: Boolean;
        TaxLiable: Boolean;
        AllowInvoiceDisc: Boolean;
        AllowItemChargeAssignment: Boolean;
        DepruntilFAPostingDate: Boolean;
        UseDuplicationList: Boolean;
        NonstockStr: Text[50];
        DropShipmentStr: Text[50];
        SpecialOrderStr: Text[50];
        SubstitutionAvailableStr: Text[50];
        TaxLiableStr: Text[50];
        AllowInvoiceDiscStr: Text[50];
        AllowItemChargeAssignmentStr: Text[50];
        DepruntilFAPostingDateStr: Text[50];
        UseDuplicationListStr: Text[50];
        Reserve: Enum "Reserve Method";
        ICPartnerRefType: Enum "IC Partner Reference Type";
        Type: Enum "Sales Line Type";
        ReserveStr: Text[20];
        ICPartnerRefTypeStr: Text[20];
        TypeStr: Text[20];
        Quantity: Decimal;
        QtytoAssembletoOrder: Decimal;
        ReservedQuantity: Decimal;
        UnitCostLCY: Decimal;
        UnitPrice: Decimal;
        LineDiscountPercent: Decimal;
        LineAmount: Decimal;
        AmountIncludingVAT: Decimal;
        LineDiscountAmount: Decimal;
        PrepaymentPercent: Decimal;
        PrepmtLineAmount: Decimal;
        PrepmtAmtInv: Decimal;
        InvDiscountAmount: Decimal;
        InvDiscAmounttoInvoice: Decimal;
        QtytoShip: Decimal;
        QuantityShipped: Decimal;
        QtytoInvoice: Decimal;
        QuantityInvoiced: Decimal;
        PrepmtAmttoDeduct: Decimal;
        PrepmtAmtDeducted: Decimal;
        QtytoAssign: Decimal;
        QtyAssigned: Decimal;
        WhseOutstandingQty: Decimal;
        WhseOutstandingQtyBase: Decimal;
        ATOWhseOutstandingQty: Decimal;
        ATOWhseOutstdQtyBase: Decimal;
        QuantityStr: Text[50];
        QtytoAssembletoOrderStr: Text[50];
        ReservedQuantityStr: Text[50];
        UnitCostLCYStr: Text[50];
        UnitPriceStr: Text[50];
        LineDiscountPercentStr: Text[50];
        LineAmountStr: Text[50];
        AmountIncludingVATStr: Text[50];
        LineDiscountAmountStr: Text[50];
        PrepaymentPercentStr: Text[50];
        PrepmtLineAmountStr: Text[50];
        PrepmtAmtInvStr: Text[50];
        InvDiscountAmountStr: Text[50];
        InvDiscAmounttoInvoiceStr: Text[50];
        QtytoShipStr: Text[50];
        QuantityShippedStr: Text[50];
        QtytoInvoiceStr: Text[50];
        QuantityInvoicedStr: Text[50];
        PrepmtAmttoDeductStr: Text[50];
        PrepmtAmtDeductedStr: Text[50];
        QtytoAssignStr: Text[50];
        QtyAssignedStr: Text[50];
        WhseOutstandingQtyStr: Text[50];
        WhseOutstandingQtyBaseStr: Text[50];
        ATOWhseOutstandingQtyStr: Text[50];
        ATOWhseOutstdQtyBaseStr: Text[50];
        coundHeaders: Integer;
        countLines: Integer;
        i: Integer;
        xmlLineNode: XmlNode;
        xmlLineChildNode: XmlNode;
        linesNodeList: XmlNodeList;
        check: Boolean;

    begin
        check := xmlParentNode.SelectNodes('.//SalesOrderSalesLines', linesNodeList);
        countLines := linesNodeList.Count;
        // looping to all sales lines nodes
        for i := 1 to linesNodeList.Count do begin
            if linesNodeList.Get(i, xmlLineNode) then begin
                if xmlLineNode.SelectSingleNode('.//Document_Type', xmlLineChildNode) then
                    DocumentType := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//No', xmlLineChildNode) then
                    No := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Cross_Reference_No', xmlLineChildNode) then
                    CrossReferenceNo := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//IC_Partner_Code', xmlLineChildNode) then
                    ICPartnerCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//IC_Partner_Reference', xmlLineChildNode) then
                    ICPartnerReference := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//IC_Partner_Ref_Type', xmlLineChildNode) then
                    ICPartnerRefTypeStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Variant_Code', xmlLineChildNode) then
                    VariantCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Purchasing_Code', xmlLineChildNode) then
                    PurchasingCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Return_Reason_Code', xmlLineChildNode) then
                    ReturnReasonCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//VAT_Prod_Posting_Group', xmlLineChildNode) then
                    VATProdPostingGroup := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Location_Code', xmlLineChildNode) then
                    LocationCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Bin_Code', xmlLineChildNode) then
                    BinCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Unit_of_Measure_Code', xmlLineChildNode) then
                    UnitofMeasureCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Tax_Area_Code', xmlLineChildNode) then
                    TaxAreaCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Tax_Group_Code', xmlLineChildNode) then
                    TaxGroupCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shipping_Agent_Code', xmlLineChildNode) then
                    ShippingAgentCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shipping_Agent_Service_Code', xmlLineChildNode) then
                    ShippingAgentServiceCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Work_Type_Code', xmlLineChildNode) then
                    WorkTypeCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Blanket_Order_No', xmlLineChildNode) then
                    BlanketOrderNo := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Depreciation_Book_Code', xmlLineChildNode) then
                    DepreciationBookCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Duplicate_in_Depreciation_Book', xmlLineChildNode) then
                    DuplicateinDepreciationBook := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Deferral_Code', xmlLineChildNode) then
                    DeferralCode := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shortcut_Dimension_1_Code', xmlLineChildNode) then
                    ShortcutDimension1Code := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shortcut_Dimension_2_Code', xmlLineChildNode) then
                    ShortcutDimension2Code := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Description', xmlLineChildNode) then
                    Description := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Package_Tracking_No', xmlLineChildNode) then
                    PackageTrackingNo := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Unit_of_Measure', xmlLineChildNode) then
                    UnitofMeasure := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Quantity', xmlLineChildNode) then
                    QuantityStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Qty_to_Assemble_to_Order', xmlLineChildNode) then
                    QtytoAssembletoOrderStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Reserved_Quantity', xmlLineChildNode) then
                    ReservedQuantityStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Unit_Cost_LCY', xmlLineChildNode) then
                    UnitCostLCYStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Line_Discount_Percent', xmlLineChildNode) then
                    LineDiscountPercentStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Line_Amount', xmlLineChildNode) then
                    LineAmountStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Unit_Price', xmlLineChildNode) then
                    UnitPriceStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Amount_Including_VAT', xmlLineChildNode) then
                    AmountIncludingVATStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Line_Discount_Amount', xmlLineChildNode) then
                    LineDiscountAmountStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Prepayment_Percent', xmlLineChildNode) then
                    PrepaymentPercentStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Prepmt_Line_Amount', xmlLineChildNode) then
                    PrepmtLineAmountStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Prepmt_Amt_Inv', xmlLineChildNode) then
                    PrepmtAmtInvStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Inv_Discount_Amount', xmlLineChildNode) then
                    InvDiscountAmountStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Inv_Disc_Amount_to_Invoice', xmlLineChildNode) then
                    InvDiscAmounttoInvoiceStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Qty_to_Ship', xmlLineChildNode) then
                    QtytoShipStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Quantity_Shipped', xmlLineChildNode) then
                    QuantityShippedStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Qty_to_Invoice', xmlLineChildNode) then
                    QtytoInvoiceStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Quantity_Invoiced', xmlLineChildNode) then
                    QuantityInvoicedStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Prepmt_Amt_to_Deduct', xmlLineChildNode) then
                    PrepmtAmttoDeductStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Prepmt_Amt_Deducted', xmlLineChildNode) then
                    PrepmtAmtDeductedStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Qty_to_Assign', xmlLineChildNode) then
                    QtytoAssignStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Qty_Assigned', xmlLineChildNode) then
                    QtyAssignedStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Whse_Outstanding_Qty', xmlLineChildNode) then
                    WhseOutstandingQtyStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Whse_Outstanding_Qty_Base', xmlLineChildNode) then
                    WhseOutstandingQtyBaseStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//ATO_Whse_Outstanding_Qty', xmlLineChildNode) then
                    ATOWhseOutstandingQtyStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//ATO_Whse_Outstd_Qty_Base', xmlLineChildNode) then
                    ATOWhseOutstdQtyBaseStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Appl_from_Item_Entry', xmlLineChildNode) then
                    ApplfromItemEntryStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Appl_to_Item_Entry', xmlLineChildNode) then
                    AppltoItemEntryStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Blanket_Order_Line_No', xmlLineChildNode) then
                    BlanketOrderLineNoStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Requested_Delivery_Date', xmlLineChildNode) then
                    RequestedDeliveryDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Promised_Delivery_Date', xmlLineChildNode) then
                    PromisedDeliveryDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Planned_Delivery_Date', xmlLineChildNode) then
                    PlannedDeliveryDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Planned_Shipment_Date', xmlLineChildNode) then
                    PlannedShipmentDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shipment_Date', xmlLineChildNode) then
                    ShipmentDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//FA_Posting_Date', xmlLineChildNode) then
                    FAPostingDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Shipping_Time', xmlLineChildNode) then
                    ShippingTimeStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Outbound_Whse_Handling_Time', xmlLineChildNode) then
                    OutboundWhseHandlingTimeStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Nonstock', xmlLineChildNode) then
                    NonstockStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Drop_Shipment', xmlLineChildNode) then
                    DropShipmentStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Special_Order', xmlLineChildNode) then
                    SpecialOrderStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Substitution_Available', xmlLineChildNode) then
                    SubstitutionAvailableStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Tax_Liable', xmlLineChildNode) then
                    TaxLiableStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Allow_Invoice_Disc', xmlLineChildNode) then
                    AllowInvoiceDiscStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Allow_Item_Charge_Assignment', xmlLineChildNode) then
                    AllowItemChargeAssignmentStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Depr_until_FA_Posting_Date', xmlLineChildNode) then
                    DepruntilFAPostingDateStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Use_Duplication_List', xmlLineChildNode) then
                    UseDuplicationListStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Reserve', xmlLineChildNode) then
                    ReserveStr := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//Type', xmlLineChildNode) then
                    TypeStr := xmlLineChildNode.AsXmlElement().InnerText;

                //Evaluating values

                if QuantityStr <> '' then
                    Evaluate(Quantity, QuantityStr);
                if DocumentType <> '' then
                    Evaluate(Document_Type, DocumentType);
                if QtytoAssembletoOrderStr <> '' then
                    Evaluate(QtytoAssembletoOrder, QtytoAssembletoOrderStr);
                if ReservedQuantityStr <> '' then
                    Evaluate(ReservedQuantity, ReservedQuantityStr);
                if UnitCostLCYStr <> '' then
                    Evaluate(UnitCostLCY, UnitCostLCYStr);
                if LineDiscountPercentStr <> '' then
                    Evaluate(LineDiscountPercent, LineDiscountPercentStr);
                if LineAmountStr <> '' then
                    Evaluate(LineAmount, LineAmountStr);
                if AmountIncludingVATStr <> '' then
                    Evaluate(AmountIncludingVAT, AmountIncludingVATStr);
                if LineDiscountAmountStr <> '' then
                    Evaluate(LineDiscountAmount, LineDiscountAmountStr);
                if PrepaymentPercentStr <> '' then
                    Evaluate(PrepaymentPercent, PrepaymentPercentStr);
                if PrepmtLineAmountStr <> '' then
                    Evaluate(PrepmtLineAmount, PrepmtLineAmountStr);
                if PrepmtAmtInvStr <> '' then
                    Evaluate(PrepmtAmtInv, PrepmtAmtInvStr);
                if InvDiscountAmountStr <> '' then
                    Evaluate(InvDiscountAmount, InvDiscountAmountStr);
                if InvDiscAmounttoInvoiceStr <> '' then
                    Evaluate(InvDiscAmounttoInvoice, InvDiscAmounttoInvoiceStr);
                if QtytoShipStr <> '' then
                    Evaluate(QtytoShip, QtytoShipStr);
                if QuantityShippedStr <> '' then
                    Evaluate(QuantityShipped, QuantityShippedStr);
                if QtytoInvoiceStr <> '' then
                    Evaluate(QtytoInvoice, QtytoInvoiceStr);
                if QuantityInvoicedStr <> '' then
                    Evaluate(QuantityInvoiced, QuantityInvoicedStr);
                if PrepmtAmttoDeductStr <> '' then
                    Evaluate(PrepmtAmttoDeduct, PrepmtAmttoDeductStr);
                if PrepmtAmtDeductedStr <> '' then
                    Evaluate(PrepmtAmtDeducted, PrepmtAmtDeductedStr);
                if QtytoAssignStr <> '' then
                    Evaluate(QtytoAssign, QtytoAssignStr);
                if QtyAssignedStr <> '' then
                    Evaluate(QtyAssigned, QtyAssignedStr);
                if WhseOutstandingQtyStr <> '' then
                    Evaluate(WhseOutstandingQty, WhseOutstandingQtyStr);
                if WhseOutstandingQtyBaseStr <> '' then
                    Evaluate(WhseOutstandingQtyBase, WhseOutstandingQtyBaseStr);
                if ATOWhseOutstandingQtyStr <> '' then
                    Evaluate(ATOWhseOutstandingQty, ATOWhseOutstandingQtyStr);
                if ATOWhseOutstdQtyBaseStr <> '' then
                    Evaluate(ATOWhseOutstdQtyBase, ATOWhseOutstdQtyBaseStr);
                if ApplfromItemEntryStr <> '' then
                    Evaluate(ApplfromItemEntry, ApplfromItemEntryStr);
                if AppltoItemEntryStr <> '' then
                    Evaluate(AppltoItemEntry, AppltoItemEntryStr);
                if BlanketOrderLineNoStr <> '' then
                    Evaluate(BlanketOrderLineNo, BlanketOrderLineNoStr);
                if RequestedDeliveryDateStr <> '' then
                    Evaluate(RequestedDeliveryDate, RequestedDeliveryDateStr);
                if PromisedDeliveryDateStr <> '' then
                    Evaluate(PromisedDeliveryDate, PromisedDeliveryDateStr);
                if PlannedDeliveryDateStr <> '' then
                    Evaluate(PlannedDeliveryDate, PlannedDeliveryDateStr);
                if PlannedShipmentDateStr <> '' then
                    Evaluate(PlannedShipmentDate, PlannedShipmentDateStr);
                if ShipmentDateStr <> '' then
                    Evaluate(ShipmentDate, ShipmentDateStr);
                if FAPostingDateStr <> '' then
                    Evaluate(FAPostingDate, FAPostingDateStr);
                if ShippingTimeStr <> '' then
                    Evaluate(ShippingTime, ShippingTimeStr);
                if OutboundWhseHandlingTimeStr <> '' then
                    Evaluate(OutboundWhseHandlingTime, OutboundWhseHandlingTimeStr);
                if NonstockStr <> '' then
                    Evaluate(Nonstock, NonstockStr);
                if DropShipmentStr <> '' then
                    Evaluate(DropShipment, DropShipmentStr);
                if SpecialOrderStr <> '' then
                    Evaluate(SpecialOrder, SpecialOrderStr);
                if SubstitutionAvailableStr <> '' then
                    Evaluate(SubstitutionAvailable, SubstitutionAvailableStr);
                if TaxLiableStr <> '' then
                    Evaluate(TaxLiable, TaxLiableStr);
                if AllowInvoiceDiscStr <> '' then
                    Evaluate(AllowInvoiceDisc, AllowInvoiceDiscStr);
                if AllowItemChargeAssignmentStr <> '' then
                    Evaluate(AllowItemChargeAssignment, AllowItemChargeAssignmentStr);
                if DepruntilFAPostingDateStr <> '' then
                    Evaluate(DepruntilFAPostingDate, DepruntilFAPostingDateStr);
                if UseDuplicationListStr <> '' then
                    Evaluate(UseDuplicationList, UseDuplicationListStr);
                if ICPartnerRefTypeStr <> '' then
                    Evaluate(ICPartnerRefType, ICPartnerRefTypeStr);
                if ReserveStr <> '' then
                    Evaluate(Reserve, ReserveStr);
                if TypeStr <> '' then
                    Evaluate(Type, TypeStr);
                if UnitPriceStr <> '' then
                    Evaluate(UnitPrice, UnitPriceStr);

                // inserting sales lines
                System.Clear(SalesLine);
                System.Clear(xmlLineChildNode);
                SalesLine.Init();

                // generate line number
                SalesLineObj.RESET;
                SalesLineObj.SETRANGE("Document No.", DocumentNo);
                SalesLineObj.SETRANGE("Document Type", Document_Type);
                if SalesLineObj.FINDLAST then
                    LineNo := SalesLineObj."Line No." + 10000
                else
                    LineNo := 10000;

                Salesline."Document No." := DocumentNo;
                Salesline.Validate("Document Type", Document_Type);
                salesline.Validate(Type, Type);
                Salesline.Validate("No.", No);
                Salesline.Validate("Cross-Reference No.", CrossReferenceNo);
                Salesline.Validate("IC Partner Code", ICPartnerCode);
                Salesline.Validate("IC Partner Reference", ICPartnerReference);
                Salesline.Validate("Variant Code", VariantCode);
                Salesline.Validate("Purchasing Code", PurchasingCode);
                Salesline.Validate("Return Reason Code", ReturnReasonCode);
                Salesline.Validate("VAT Prod. Posting Group", VATProdPostingGroup);
                Salesline."VAT Prod. Posting Group" := VATProdPostingGroup;
                Salesline.Validate("Location Code", LocationCode);
                Salesline.Validate("Bin Code", BinCode);
                Salesline.Validate("Unit of Measure Code", UnitofMeasureCode);
                Salesline.Validate("Tax Area Code", TaxAreaCode);
                Salesline.Validate("Tax Group Code", TaxGroupCode);
                Salesline.Validate("Shipping Agent Code", ShippingAgentCode);
                Salesline.Validate("Shipping Agent Service Code", ShippingAgentServiceCode);
                Salesline.Validate("Work Type Code", WorkTypeCode);
                Salesline.Validate("Blanket Order No.", BlanketOrderNo);
                Salesline.Validate("Depreciation Book Code", DepreciationBookCode);
                Salesline.Validate("Duplicate in Depreciation Book", DuplicateinDepreciationBook);
                Salesline.Validate("Deferral Code", DeferralCode);
                Salesline.Validate("Shortcut Dimension 1 Code", ShortcutDimension1Code);
                Salesline.Validate("Shortcut Dimension 2 Code", ShortcutDimension2Code);
                Salesline.Validate(Description, Description);
                Salesline.Validate("Package Tracking No.", PackageTrackingNo);
                Salesline.Validate("Unit of Measure", UnitofMeasure);
                salesline.Validate(Quantity, Quantity);
                salesline.Validate("Qty. to Assemble to Order", QtytoAssembletoOrder);
                salesline.Validate("Reserved Quantity", ReservedQuantity);
                salesline.Validate("Unit Cost (LCY)", UnitCostLCY);
                salesline.Validate("Line Discount %", LineDiscountPercent);
                salesline.Validate("Line Amount", LineAmount);
                salesline.Validate("Amount Including VAT", AmountIncludingVAT);
                salesline.Validate("Line Discount Amount", LineDiscountAmount);
                salesline.Validate("Prepayment %", PrepaymentPercent);
                salesline.Validate("Prepmt. Line Amount", PrepmtLineAmount);
                salesline.Validate("Prepmt. Amt. Inv.", PrepmtAmtInv);
                salesline.Validate("Inv. Discount Amount", InvDiscountAmount);
                salesline.Validate("Inv. Disc. Amount to Invoice", InvDiscAmounttoInvoice);
                salesline.Validate("Qty. to Ship", QtytoShip);
                salesline.Validate("Quantity Shipped", QuantityShipped);
                salesline.Validate("Qty. to Invoice", QtytoInvoice);
                salesline.Validate("Quantity Invoiced", QuantityInvoiced);
                salesline.Validate("Prepmt Amt to Deduct", PrepmtAmttoDeduct);
                salesline.Validate("Prepmt Amt Deducted", PrepmtAmtDeducted);
                salesline.Validate("Qty. to Assign", QtytoAssign);
                salesline.Validate("Qty. Assigned", QtyAssigned);
                salesline.Validate("Whse. Outstanding Qty.", WhseOutstandingQty);
                salesline.Validate("Whse. Outstanding Qty. (Base)", WhseOutstandingQtyBase);
                salesline.Validate("ATO Whse. Outstanding Qty.", ATOWhseOutstandingQty);
                salesline.Validate("ATO Whse. Outstd. Qty. (Base)", ATOWhseOutstdQtyBase);
                salesline.Validate("Line No.", LineNo);
                salesline.Validate("Unit Price", UnitPrice);
                salesline.Validate("Appl.-from Item Entry", ApplfromItemEntry);
                salesline.Validate("Appl.-to Item Entry", AppltoItemEntry);
                salesline.Validate("Blanket Order Line No.", BlanketOrderLineNo);
                salesline.Validate("Requested Delivery Date", RequestedDeliveryDate);
                salesline.Validate("Promised Delivery Date", PromisedDeliveryDate);
                salesline.Validate("Planned Delivery Date", PlannedDeliveryDate);
                salesline.Validate("Planned Shipment Date", PlannedShipmentDate);
                salesline.Validate("Shipment Date", ShipmentDate);
                salesline.Validate("FA Posting Date", FAPostingDate);
                salesline.Validate("Shipping Time", ShippingTime);
                salesline.Validate("Outbound Whse. Handling Time", OutboundWhseHandlingTime);
                salesline.Validate(Nonstock, Nonstock);
                salesline.Validate("Drop Shipment", DropShipment);
                salesline.Validate("Special Order", SpecialOrder);
                salesline."Substitution Available" := SubstitutionAvailable;
                salesline.Validate("Tax Liable", TaxLiable);
                salesline.Validate("Allow Invoice Disc.", AllowInvoiceDisc);
                salesline.Validate("Allow Item Charge Assignment", AllowItemChargeAssignment);
                salesline.Validate("Depr. until FA Posting Date", DepruntilFAPostingDate);
                salesline.Validate("Use Duplication List", UseDuplicationList);
                salesline.Validate("IC Partner Ref. Type", ICPartnerRefType);
                salesline.Validate(Reserve, Reserve);
                SalesLine.Insert(true);
            end;
        end;
    end;
}