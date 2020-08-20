codeunit 50109 VSI_EDIRegAndPostShipService
{
    var
        WhseActivLine: Record "Warehouse Activity Line";
        WhseLines: Record "Warehouse Shipment Line";

    trigger OnRun()
    begin
    end;

    procedure getRequest(TextXML: text) response: Text
    var
        doc: XmlDocument;
    begin
        XmlDocument.ReadFrom(TextXML, doc);

        response := parseXML(doc);

    end;

    procedure parseXML(doc: XmlDocument) Response: Text
    var
        No: Code[20];
        Location_Code: Code[10];
        SourceNo: Code[20];
        RegisterPickResponse: Boolean;
        xmlNodeListParent: XmlNodeList;
        coundHeaders: Integer;
        i: Integer;
        xmlParentNode: XmlNode;
        xmlChildNode: XmlNode;

    begin
        doc.SelectNodes('.//SalesPackingSlip', xmlNodeListParent);
        coundHeaders := xmlNodeListParent.Count;
        for i := 1 to xmlNodeListParent.Count do begin
            if xmlNodeListParent.Get(i, xmlParentNode) then begin
                if xmlParentNode.SelectSingleNode('.//SalesId', xmlChildNode) then
                    SourceNo := xmlChildNode.AsXmlElement().InnerText;
                Response := createLines(xmlParentNode, No, Location_Code, SourceNo, Response);
            end;
        end;
    end;

    procedure registerPick(SourceNo: Code[20]; ItemNo: Code[20]; QtyToHand: Decimal; LotNum: Code[50]) response: Text
    var
    //WhseShipm: Record "Posted Whse. Shipment Header";
    begin
        Clear(WhseLines);
        Clear(WhseActivLine);
        WhseLines.RESET;
        WhseLines.SetRange("Source No.", SourceNo);
        WhseLines.SETRANGE("Item No.", ItemNo);
        IF WhseLines.FINDSET THEN
            REPEAT
                WhseActivLine.Reset();
                ;
                WhseActivLine.SETRANGE("Source No.", SourceNo);
                WhseActivLine.SETRANGE("Item No.", ItemNo);
                IF WhseActivLine.FindFirst() THEN begin
                    if QtyToHand <> 0 then
                        modifyQtyInWhsePick(QtyToHand, LotNum);
                    CODEUNIT.Run(CODEUNIT::VSI_EDIRegisterPicks, WhseActivLine);
                end;
                postShippment(QtyToHand);
            UNTIL WhseLines.NEXT = 0;
        if WhseLines."No." <> '' then
            response := MyResponse(WhseLines);
    end;

    procedure postShippment(QtyShp: Decimal) postRes: Boolean
    var
        WhseHeader: Record "Warehouse Shipment Header";
    begin
        CODEUNIT.Run(CODEUNIT::"VSI_EDIPostShipment", WhseLines);
    end;

    procedure createLines(xmlParentNode: XmlNode; No: Code[20]; Location_Code: Code[20]; SourceNo: Code[20]; ResponseIn: Text) Response: Text
    var
        check: Boolean;
        countLines: Integer;
        xmlLineNode: XmlNode;
        xmlLineChildNode: XmlNode;
        linesNodeList: XmlNodeList;
        ItemNo: Code[20];
        QtyStr: Text[30];
        Quantity: Decimal;
        DestinationNo: Code[20];
        i: Integer;
        QtyToHandle: Decimal;
        QtyToHandleStr: Text[30];
        LotNumber: Code[50];

    begin
        check := xmlParentNode.SelectNodes('.//SalesLine', linesNodeList);
        countLines := linesNodeList.Count;
        for i := 1 to linesNodeList.Count do begin
            if linesNodeList.Get(i, xmlLineNode) then begin
                if xmlLineNode.SelectSingleNode('.//ItemId', xmlLineChildNode) then
                    ItemNo := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//LotNo', xmlLineChildNode) then
                    LotNumber := xmlLineChildNode.AsXmlElement().InnerText;
                if xmlLineNode.SelectSingleNode('.//ShippedQty', xmlLineChildNode) then
                    QtyToHandleStr := xmlLineChildNode.AsXmlElement().InnerText
                else
                    QtyToHandleStr := '';

                if QtyToHandleStr <> '' then
                    Evaluate(QtyToHandle, QtyToHandleStr)
                else
                    QtyToHandle := 0;
                Response := ResponseIn + registerPick(SourceNo, ItemNo, QtyToHandle, LotNumber);
            end;
        end;
    end;

    // This Procedure will Modify Quantity to handle in Warehouse pick , before Register
    procedure modifyQtyInWhsePick(QtyToHandle: Decimal; LotNo: Code[50])
    var
        WhseActReg: Codeunit "Whse.-Activity-Register";
    begin
        if WhseActivLine.Get(WhseActivLine."Activity Type"::Pick, WhseActivLine."No.", WhseActivLine."Line No.") then begin
            WhseActivLine.Validate("Qty. to Handle", QtyToHandle);
            WhseActivLine.Validate("Lot No.", LotNo);
            WhseActivLine.Modify(true);
        end;
    end;

    procedure MyResponse(WhseLines: Record "Warehouse Shipment Line") Response: Text;
    var
        WhseShipm: Record "Posted Whse. Shipment Header";
    begin
        WhseShipm.Reset();
        WhseShipm.SetRange("Whse. Shipment No.", WhseLines."No.");
        if WhseShipm.FindSet() then
            repeat
                Response := Response + StrSubstNo(' {"Success": true,"Shipment id": "%1"}', /*WhseShipm."No."*/WhseLines."Source No.");
            until WhseShipm.Next = 0
        else
            Response := StrSubstNo(' {"Success": false}');

    end;


}