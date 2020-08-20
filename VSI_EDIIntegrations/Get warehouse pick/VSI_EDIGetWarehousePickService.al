codeunit 50117 "VSI_GetWarehousePickService"
{
    procedure sendRequest(TextXML: text) VJsonText: Text;
    var
        doc: XmlDocument;
    begin
        XmlDocument.ReadFrom(TextXML, doc);
        VJsonText := parseXML(doc);
    end;

    procedure parseXML(doc: XmlDocument) VJsonText: Text;
    var
        xmlPackingSlipList: XmlNodeList;
        xmlpackingSlip: XmlNode;
        CountPackingSlip: Integer;
        xmlChildNode: XmlNode;
        i: Integer;
        ShippingAgent: Code[20];
        ProNumber: Code[20]; //not confirm
        StatusStr: Text[30];
        DocumentStatusStr: Text[30];
        lastmodifiedDateTime: Code[20];// not confirm
        LocationCode: Code[20];
        CustomerNo: Code[20];
    begin
        doc.SelectSingleNode('.//SalesPickingSlipRequst', xmlpackingSlip);
        if xmlpackingSlip.SelectSingleNode('.//ShippingAgent', xmlChildNode) then
            ShippingAgent := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//ProNumber', xmlChildNode) then
            ProNumber := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//Status', xmlChildNode) then
            StatusStr := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//DocumentStatus', xmlChildNode) then
            DocumentStatusStr := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//lastmodifiedDateTime', xmlChildNode) then
            lastmodifiedDateTime := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//LocationCode', xmlChildNode) then
            LocationCode := xmlChildNode.AsXmlElement().InnerText;
        if xmlpackingSlip.SelectSingleNode('.//CustomerNo', xmlChildNode) then
            CustomerNo := xmlChildNode.AsXmlElement().InnerText;

        if ShippingAgent = 'DHL' then
            VJsonText := createResponseFromShipAgent(ShippingAgent, ProNumber, StatusStr, DocumentStatusStr, lastmodifiedDateTime, LocationCode, CustomerNo)
        else
            if ShippingAgent = 'CHROB' then
                VJsonText := createResponseFromShipAgent(ShippingAgent, ProNumber, StatusStr, DocumentStatusStr, lastmodifiedDateTime, LocationCode, CustomerNo)
            else
                if LocationCode <> '' then
                    VJsonText := createResponseFromLocationCode(ShippingAgent, ProNumber, StatusStr, DocumentStatusStr, lastmodifiedDateTime, LocationCode, CustomerNo);
    end;

    procedure createResponseFromShipAgent(ShippingAgent: Code[20]; ProNumber: Code[20]; StatusStr: Text[30]; DocumentStatusStr: Text[30]; lastmodifiedDateTime: Code[20]; LocationCode: Code[20]; CustomerNo: Code[20]) VJsonText: Text;
    var
        Status: Option Open,Released;
        DocumentStatus: Option " ","Partially Picked","Partially Shipped","Completely Picked","Completely Shipped";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WhseShipmentLines: Record "Warehouse Shipment Line";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhsePickLines: Record "Warehouse Activity Line";
        WhsePickHeader: Record "Warehouse Activity Header";
        VJsonObjectPickList: JsonObject;
        VJsonObjectHeader: JsonObject;
        VJsonObjectLines: JsonObject;
        VJsonArray: JsonArray;
        VJsonArrayLine: JsonArray;

    begin
        VJsonObjectPickList.Add('SalesPickingSlip', VJsonObjectHeader);
        VJsonObjectHeader.Add('PickingSlipNo', '');
        VJsonObjectHeader.Add('SalesId', '');
        VJsonObjectHeader.Add('Status', '');
        VJsonObjectHeader.Add('Ship_to_Code', '');
        VJsonObjectHeader.Add('Ship_to_Name', '');
        VJsonObjectHeader.Add('Ship_to_Address', '');
        VJsonObjectHeader.Add('Ship_to_Address_2', '');
        VJsonObjectHeader.Add('Ship_to_City', '');
        VJsonObjectHeader.Add('Ship_to_County', '');
        VJsonObjectHeader.Add('Ship_to_Post_Code', '');
        VJsonObjectHeader.Add('Ship_to_Country_Region_Code', '');
        VJsonObjectHeader.Add('Ship_to_UPS_Zone', '');
        VJsonObjectHeader.Add('Ship_to_Contact', '');
        VJsonObjectHeader.Add('Shipment_Method_Code', '');
        VJsonObjectHeader.Add('Shipping_Agent_Code', '');
        VJsonObjectHeader.Add('Bill_to_Name', '');
        VJsonObjectHeader.Add('Bill_to_Address', '');
        VJsonObjectHeader.Add('Bill_to_Address_2', '');
        VJsonObjectHeader.Add('Bill_to_City', '');
        VJsonObjectHeader.Add('Bill_to_County', '');
        VJsonObjectHeader.Add('Bill_to_Post_Code', '');
        VJsonObjectHeader.Add('Bill_to_Country_Region_Code', '');
        VJsonObjectHeader.Add('Bill_to_Contact_No', '');
        VJsonObjectHeader.Add('Bill_to_Contact', '');
        VJsonObjectHeader.Add('Ship_VIA', '');
        VJsonObjectHeader.Add('FOB_Point', '');
        VJsonObjectHeader.Add('Order_Date', '');
        VJsonObjectHeader.Add('Customer_PONumber', '');
        VJsonObjectHeader.Add('Payment_Terms', '');
        VJsonObjectHeader.Add('Location_Code', '');
        VJsonObjectHeader.Add('Sales_PersonCODE', '');
        VJsonObjectHeader.Add('WSShipment_ID', '');
        VJsonObjectHeader.Add('No_Of_Pallet', '');
        VJsonObjectHeader.Add('Total_Weight', '');
        VJsonObjectHeader.Add('Ship_StartDate', '');
        VJsonObjectHeader.Add('Ship_EndDate', '');
        VJsonObjectHeader.Add('SalesLine', VJsonArrayLine);

        VJsonObjectLines.Add('SalesId', '');
        VJsonObjectLines.Add('ItemId', '');
        VJsonObjectLines.Add('ItemDescription', '');
        VJsonObjectLines.Add('OrderedQty', '');
        VJsonObjectLines.Add('PackingUnitQty', '');
        VJsonObjectLines.Add('ShippedQty', '');
        VJsonObjectLines.Add('LotNo', '');
        VJsonObjectLines.Add('LineNo', '');

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Shipping Agent Code", ShippingAgent);
        IF SalesHeader.FINDSET THEN
            REPEAT
                WhsePickLines.Reset();
                WhsePickLines.SetRange("Source No.", SalesHeader."No.");
                if WhsePickLines.FindFirst() then begin
                    WhsePickHeader.Reset();
                    WhsePickHeader.SetRange("No.", WhsePickLines."No.");
                    if WhsePickHeader.FindFirst() then begin
                        WhseShipmentLines.Reset();
                        WhseShipmentLines.SetRange("Source No.", WhsePickLines."Source No.");
                        if WhseShipmentLines.FindFirst() then begin
                            WhseShipmentHeader.Reset();
                            WhseShipmentHeader.SetRange("No.", WhseShipmentLines."No.");
                            if StatusStr <> '' then begin
                                Evaluate(Status, StatusStr);
                                WhseShipmentHeader.SetRange(Status, Status);
                            end;
                            //if DocumentStatusStr <> '' then 
                            Evaluate(DocumentStatus, DocumentStatusStr);
                            WhseShipmentHeader.SetRange("Document Status", DocumentStatus);

                            if WhseShipmentHeader.FindFirst() then begin

                                //Create JSON
                                VJsonObjectHeader.Replace('PickingSlipNo', WhsePickHeader."No.");
                                VJsonObjectHeader.Replace('SalesId', SalesHeader."No.");
                                VJsonObjectHeader.Replace('Status', SalesHeader.Status.AsInteger());
                                VJsonObjectHeader.Replace('Ship_to_Code', SalesHeader."Ship-to Code");
                                VJsonObjectHeader.Replace('Ship_to_Name', SalesHeader."Ship-to Name");
                                VJsonObjectHeader.Replace('Ship_to_Address', SalesHeader."Ship-to Address");
                                VJsonObjectHeader.Replace('Ship_to_Address_2', SalesHeader."Ship-to Address 2");
                                VJsonObjectHeader.Replace('Ship_to_City', SalesHeader."Ship-to City");
                                VJsonObjectHeader.Replace('Ship_to_County', SalesHeader."Ship-to County");
                                VJsonObjectHeader.Replace('Ship_to_Post_Code', SalesHeader."Ship-to City");
                                VJsonObjectHeader.Replace('Ship_to_Country_Region_Code', SalesHeader."Ship-to Country/Region Code");
                                VJsonObjectHeader.Replace('Ship_to_UPS_Zone', SalesHeader."Ship-to UPS Zone");
                                VJsonObjectHeader.Replace('Ship_to_Contact', SalesHeader."Ship-to Contact");
                                VJsonObjectHeader.Replace('Shipment_Method_Code', SalesHeader."Shipment Method Code");
                                VJsonObjectHeader.Replace('Shipping_Agent_Code', SalesHeader."Shipping Agent Code");
                                VJsonObjectHeader.Replace('Bill_to_Name', SalesHeader."Bill-to Name");
                                VJsonObjectHeader.Replace('Bill_to_Address', SalesHeader."Bill-to Address");
                                VJsonObjectHeader.Replace('Bill_to_Address_2', SalesHeader."Bill-to Address 2");
                                VJsonObjectHeader.Replace('Bill_to_City', SalesHeader."Bill-to City");
                                VJsonObjectHeader.Replace('Bill_to_County', SalesHeader."Bill-to County");
                                VJsonObjectHeader.Replace('Bill_to_Post_Code', SalesHeader."Bill-to Post Code");
                                VJsonObjectHeader.Replace('Bill_to_Country_Region_Code', SalesHeader."Bill-to Country/Region Code");
                                VJsonObjectHeader.Replace('Bill_to_Contact_No', SalesHeader."Bill-to Contact No.");
                                VJsonObjectHeader.Replace('Bill_to_Contact', SalesHeader."Bill-to Contact");
                                VJsonObjectHeader.Replace('Ship_VIA', SalesHeader."Shipping Agent Code");
                                VJsonObjectHeader.Replace('FOB_Point', SalesHeader."Shipment Method Code");
                                VJsonObjectHeader.Replace('Order_Date', SalesHeader."Order Date");
                                VJsonObjectHeader.Replace('Customer_PONumber', SalesHeader."External Document No.");
                                VJsonObjectHeader.Replace('Payment_Terms', SalesHeader."Payment Terms Code");
                                VJsonObjectHeader.Replace('Location_Code', SalesHeader."Location Code");
                                VJsonObjectHeader.Replace('Sales_PersonCODE', SalesHeader."Salesperson Code");
                                VJsonObjectHeader.Replace('WSShipment_ID', WhseShipmentLines."No.");
                                //VJsonObjectHeader.Replace('No_Of_Pallet',);
                                //VJsonObjectHeader.Replace('Total_Weight',);
                                //VJsonObjectHeader.Replace('Ship_StartDate',);
                                //VJsonObjectHeader.Replace('Ship_EndDate',);                    
                                VJsonObjectHeader.Replace('SalesLine', addLines(SalesHeader, WhsePickLines));
                                VJsonObjectPickList.Replace('SalesPickingSlip', VJsonObjectHeader);
                                VJsonArray.Add(VJsonObjectPickList.Clone());

                            end;
                        end;
                    end;
                end;

            UNTIL SalesHeader.NEXT = 0;
        VJsonArray.WriteTo(VJsonText);

    end;


    procedure createResponseFromLocationCode(ShippingAgent: Code[20]; ProNumber: Code[20]; StatusStr: Text[30]; DocumentStatusStr: Text[30]; lastmodifiedDateTime: Code[20]; LocationCode: Code[20]; CustomerNo: Code[20]) VJsonText: Text;
    var
        Status: Option Open,Released;
        DocumentStatus: Option " ","Partially Picked","Partially Shipped","Completely Picked","Completely Shipped";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WhseShipmentLines: Record "Warehouse Shipment Line";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        WhsePickLines: Record "Warehouse Activity Line";
        WhsePickHeader: Record "Warehouse Activity Header";
        VJsonObjectHeader: JsonObject;
        VJsonObjectLines: JsonObject;
        VJsonArray: JsonArray;
        VJsonArrayLine: JsonArray;
        VJsonObjectPickList: JsonObject;

    begin
        VJsonObjectPickList.Add('SalesPickingSlip', VJsonObjectHeader);
        VJsonObjectHeader.Add('PickingSlipNo', '');
        VJsonObjectHeader.Add('SalesId', '');
        VJsonObjectHeader.Add('Status', '');
        VJsonObjectHeader.Add('Ship_to_Code', '');
        VJsonObjectHeader.Add('Ship_to_Name', '');
        VJsonObjectHeader.Add('Ship_to_Address', '');
        VJsonObjectHeader.Add('Ship_to_Address_2', '');
        VJsonObjectHeader.Add('Ship_to_City', '');
        VJsonObjectHeader.Add('Ship_to_County', '');
        VJsonObjectHeader.Add('Ship_to_Post_Code', '');
        VJsonObjectHeader.Add('Ship_to_Country_Region_Code', '');
        VJsonObjectHeader.Add('Ship_to_UPS_Zone', '');
        VJsonObjectHeader.Add('Ship_to_Contact', '');
        VJsonObjectHeader.Add('Shipment_Method_Code', '');
        VJsonObjectHeader.Add('Shipping_Agent_Code', '');
        VJsonObjectHeader.Add('Bill_to_Name', '');
        VJsonObjectHeader.Add('Bill_to_Address', '');
        VJsonObjectHeader.Add('Bill_to_Address_2', '');
        VJsonObjectHeader.Add('Bill_to_City', '');
        VJsonObjectHeader.Add('Bill_to_County', '');
        VJsonObjectHeader.Add('Bill_to_Post_Code', '');
        VJsonObjectHeader.Add('Bill_to_Country_Region_Code', '');
        VJsonObjectHeader.Add('Bill_to_Contact_No', '');
        VJsonObjectHeader.Add('Bill_to_Contact', '');
        VJsonObjectHeader.Add('Ship_VIA', '');
        VJsonObjectHeader.Add('FOB_Point', '');
        VJsonObjectHeader.Add('Order_Date', '');
        VJsonObjectHeader.Add('Customer_PONumber', '');
        VJsonObjectHeader.Add('Payment_Terms', '');
        VJsonObjectHeader.Add('Location_Code', '');
        VJsonObjectHeader.Add('Sales_PersonCODE', '');
        VJsonObjectHeader.Add('WSShipment_ID', '');
        VJsonObjectHeader.Add('No_Of_Pallet', '');
        VJsonObjectHeader.Add('Total_Weight', '');
        VJsonObjectHeader.Add('Ship_StartDate', '');
        VJsonObjectHeader.Add('Ship_EndDate', '');
        VJsonObjectHeader.Add('SalesLine', VJsonArrayLine);

        VJsonObjectLines.Add('SalesId', '');
        VJsonObjectLines.Add('ItemId', '');
        VJsonObjectLines.Add('ItemDescription', '');
        VJsonObjectLines.Add('OrderedQty', '');
        VJsonObjectLines.Add('PackingUnitQty', '');
        VJsonObjectLines.Add('ShippedQty', '');
        VJsonObjectLines.Add('LotNo', '');
        VJsonObjectLines.Add('LineNo', '');

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Location Code", LocationCode);
        IF SalesHeader.FINDSET THEN
            REPEAT
                WhsePickLines.Reset();
                WhsePickLines.SetRange("Source No.", SalesHeader."No.");
                if WhsePickLines.FindFirst() then begin
                    WhsePickHeader.Reset();
                    WhsePickHeader.SetRange("No.", WhsePickLines."No.");
                    if WhsePickHeader.FindFirst() then begin
                        WhseShipmentLines.Reset();
                        WhseShipmentLines.SetRange("Source No.", WhsePickLines."Source No.");
                        if WhseShipmentLines.FindFirst() then begin
                            WhseShipmentHeader.Reset();
                            WhseShipmentHeader.SetRange("No.", WhseShipmentLines."No.");
                            if StatusStr <> '' then begin
                                Evaluate(Status, StatusStr);
                                WhseShipmentHeader.SetRange(Status, Status);
                            end;
                            //if DocumentStatusStr <> '' then begin
                            Evaluate(DocumentStatus, DocumentStatusStr);
                            WhseShipmentHeader.SetRange("Document Status", DocumentStatus);
                            //end;
                            if WhseShipmentHeader.FindFirst() then begin

                                //Create JSON
                                VJsonObjectHeader.Replace('PickingSlipNo', WhsePickHeader."No.");
                                VJsonObjectHeader.Replace('SalesId', SalesHeader."No.");
                                VJsonObjectHeader.Replace('Status', SalesHeader.Status.AsInteger());
                                VJsonObjectHeader.Replace('Ship_to_Code', SalesHeader."Ship-to Code");
                                VJsonObjectHeader.Replace('Ship_to_Name', SalesHeader."Ship-to Name");
                                VJsonObjectHeader.Replace('Ship_to_Address', SalesHeader."Ship-to Address");
                                VJsonObjectHeader.Replace('Ship_to_Address_2', SalesHeader."Ship-to Address 2");
                                VJsonObjectHeader.Replace('Ship_to_City', SalesHeader."Ship-to City");
                                VJsonObjectHeader.Replace('Ship_to_County', SalesHeader."Ship-to County");
                                VJsonObjectHeader.Replace('Ship_to_Post_Code', SalesHeader."Ship-to City");
                                VJsonObjectHeader.Replace('Ship_to_Country_Region_Code', SalesHeader."Ship-to Country/Region Code");
                                VJsonObjectHeader.Replace('Ship_to_UPS_Zone', SalesHeader."Ship-to UPS Zone");
                                VJsonObjectHeader.Replace('Ship_to_Contact', SalesHeader."Ship-to Contact");
                                VJsonObjectHeader.Replace('Shipment_Method_Code', SalesHeader."Shipment Method Code");
                                VJsonObjectHeader.Replace('Shipping_Agent_Code', SalesHeader."Shipping Agent Code");
                                VJsonObjectHeader.Replace('Bill_to_Name', SalesHeader."Bill-to Name");
                                VJsonObjectHeader.Replace('Bill_to_Address', SalesHeader."Bill-to Address");
                                VJsonObjectHeader.Replace('Bill_to_Address_2', SalesHeader."Bill-to Address 2");
                                VJsonObjectHeader.Replace('Bill_to_City', SalesHeader."Bill-to City");
                                VJsonObjectHeader.Replace('Bill_to_County', SalesHeader."Bill-to County");
                                VJsonObjectHeader.Replace('Bill_to_Post_Code', SalesHeader."Bill-to Post Code");
                                VJsonObjectHeader.Replace('Bill_to_Country_Region_Code', SalesHeader."Bill-to Country/Region Code");
                                VJsonObjectHeader.Replace('Bill_to_Contact_No', SalesHeader."Bill-to Contact No.");
                                VJsonObjectHeader.Replace('Bill_to_Contact', SalesHeader."Bill-to Contact");
                                VJsonObjectHeader.Replace('Ship_VIA', SalesHeader."Shipping Agent Code");
                                VJsonObjectHeader.Replace('FOB_Point', SalesHeader."Shipment Method Code");
                                VJsonObjectHeader.Replace('Order_Date', SalesHeader."Order Date");
                                VJsonObjectHeader.Replace('Customer_PONumber', SalesHeader."External Document No.");
                                VJsonObjectHeader.Replace('Payment_Terms', SalesHeader."Payment Terms Code");
                                VJsonObjectHeader.Replace('Location_Code', SalesHeader."Location Code");
                                VJsonObjectHeader.Replace('Sales_PersonCODE', SalesHeader."Salesperson Code");
                                VJsonObjectHeader.Replace('WSShipment_ID', WhseShipmentLines."No.");
                                //VJsonObjectHeader.Replace('No_Of_Pallet',);
                                //VJsonObjectHeader.Replace('Total_Weight',);
                                //VJsonObjectHeader.Replace('Ship_StartDate',);
                                //VJsonObjectHeader.Replace('Ship_EndDate',);                    

                                VJsonObjectHeader.Replace('SalesLine', addLines(SalesHeader, WhsePickLines));
                                VJsonObjectPickList.Replace('SalesPickingSlip', VJsonObjectHeader);
                                VJsonArray.Add(VJsonObjectPickList.Clone());

                            end;
                        end;
                    end;
                end;

            UNTIL SalesHeader.NEXT = 0;
        VJsonArray.WriteTo(VJsonText);
    end;


    procedure getLotNumber(SalesLine: Record "Sales Line") LotNo: code[50];
    var
        reservationEntry: Record "Reservation Entry";
        lotId: Text[200];
    begin
        reservationEntry.Reset();
        reservationEntry.SetRange("Item No.", SalesLine."No.");
        reservationEntry.SetRange("Source ID", SalesLine."Document No.");
        reservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");

        if reservationEntry.FindSet then
            repeat
                if lotId <> '' then begin
                    lotId += '-' + reservationEntry."Lot No.";
                end else begin
                    lotId += reservationEntry."Lot No.";
                end;
            until reservationEntry.Next = 0;

        LotNo := lotId;
    end;

    procedure getPickLineQty(WhsePickLines: record "Warehouse Activity Line"; SalesLine: Record "Sales Line") pickLineQty: Decimal;
    var
        pickLineObj: Record "Warehouse Activity Line";
    begin
        pickLineObj.Reset();
        pickLineObj.SetRange(pickLineObj."No.", WhsePickLines."No.");
        pickLineObj.SetRange(pickLineObj."Item No.", SalesLine."No.");
        if pickLineObj.FindFirst() then
            pickLineQty := pickLineObj."Qty. to Handle";
    end;

    procedure addLines(SalesHeader: Record "Sales Header"; WhsePickLines: Record "Warehouse Activity Line") VJsonArrayLines: JsonArray;
    var
        SalesLine: Record "Sales Line";
        VJsonObjectLines: JsonObject;
    begin
        VJsonObjectLines.Add('SalesId', '');
        VJsonObjectLines.Add('ItemId', '');
        VJsonObjectLines.Add('ItemDescription', '');
        VJsonObjectLines.Add('OrderedQty', '');
        VJsonObjectLines.Add('PackingUnitQty', '');
        VJsonObjectLines.Add('ShippedQty', '');
        VJsonObjectLines.Add('LotNo', '');
        VJsonObjectLines.Add('LineNo', '');

        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET THEN
            repeat
                VJsonObjectLines.Replace('SalesId', SalesLine."Document No.");
                VJsonObjectLines.Replace('ItemId', SalesLine."No.");
                VJsonObjectLines.Replace('ItemDescription', SalesLine.Description);
                VJsonObjectLines.Replace('OrderedQty', SalesLine.Quantity);
                VJsonObjectLines.Replace('PackingUnitQty', getPickLineQty(WhsePickLines, SalesLine));
                VJsonObjectLines.Replace('ShippedQty', SalesLine."Quantity Shipped");
                VJsonObjectLines.Replace('LotNo', getLotNumber(SalesLine));
                VJsonObjectLines.Replace('LineNo', SalesLine."Line No.");

                VJsonArrayLines.Add(VJsonObjectLines.Clone());

            until SalesLine.Next() = 0;
    end;
}
