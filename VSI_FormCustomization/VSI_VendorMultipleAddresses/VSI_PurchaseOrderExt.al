// This page extension is used to auto populate order address code
pageextension 50106 VSI_PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                vendor: Record "Vendor";
                OrderAddr: Record "Order Address";

            begin
                // getting order address code from vendor table
                vendor.Get("Buy-from Vendor No.");
                if vendor."Order address code" <> '' then begin
                    "Order Address Code" := vendor."Order address code";
                    OrderAddr.Get("Buy-from Vendor No.", "Order Address Code");
                    "Buy-from Vendor Name" := OrderAddr.Name;
                    "Buy-from Vendor Name 2" := OrderAddr."Name 2";
                    "Buy-from Address" := OrderAddr.Address;
                    "Buy-from Address 2" := OrderAddr."Address 2";
                    "Buy-from City" := OrderAddr.City;
                    "Buy-from Contact" := OrderAddr.Contact;
                    "Buy-from Post Code" := orderAddr."Post Code";
                    "Buy-from County" := OrderAddr.County;
                    "Buy-from Country/Region Code" := OrderAddr."Country/Region Code";

                    if IsCreditDocType() then begin
                        SetShipToAddress(
                            OrderAddr.Name, OrderAddr."Name 2", OrderAddr.Address, OrderAddr."Address 2",
                            OrderAddr.City, OrderAddr."Post Code", OrderAddr.County, OrderAddr."Country/Region Code");
                        "Ship-to Contact" := OrderAddr.Contact;
                    end;
                    CurrPage.Update();
                end;
            end;
        }
    }
}