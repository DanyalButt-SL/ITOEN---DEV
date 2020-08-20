pageextension 50107 VSI_EDINativeSalesInvEntityExt extends "Native - Sales Inv. Entity"
{
    layout
    {
        addlast(Group)
        {
            field("Document Type"; "Document Type")
            {
                ApplicationArea = All;
            }
            field("Bill-to Customer No."; "Bill-to Customer No.")
            {
                ApplicationArea = All;
            }
            field("Bill-to Name"; "Bill-to Name")
            {
                ApplicationArea = All;
            }
            field("Bill-to Address"; "Bill-to Address")
            {
                ApplicationArea = All;
            }
            field("Bill-to Address 2"; "Bill-to Address 2")
            {
                ApplicationArea = All;
            }
            field("Bill-to City"; "Bill-to City")
            {
                ApplicationArea = All;
            }
            field("Bill-to Contact"; "Bill-to Contact")
            {
                ApplicationArea = All;
            }
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
            }
            field("Ship-to Code"; "Ship-to Code")
            {
                ApplicationArea = All;
            }
            field("Ship-to Name"; "Ship-to Name")
            {
                ApplicationArea = All;
            }
            field("Ship-to Address"; "Ship-to Address")
            {
                ApplicationArea = All;
            }
            field("Ship-to Address 2"; "Ship-to Address 2")
            {
                ApplicationArea = All;
            }
            field("Ship-to City"; "Ship-to City")
            {
                ApplicationArea = All;
            }
            field("Ship-to Contact"; "Ship-to Contact")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("Shipment Method Code"; "Shipment Method Code")
            {
                ApplicationArea = All;
            }
            field("Customer Posting Group"; "Customer Posting Group")
            {
                ApplicationArea = All;
            }
            field("Currency Code"; "Currency Code")
            {
                ApplicationArea = All;
            }
            field("Salesperson Code"; "Salesperson Code")
            {
                ApplicationArea = All;
            }
            field("Order No."; "Order No.")
            {
                ApplicationArea = All;
            }
            field("Recalculate Invoice Disc."; "Recalculate Invoice Disc.")
            {
                ApplicationArea = All;
            }
            field("Sell-to Address"; "Sell-to Address")
            {
                ApplicationArea = All;
            }
            field("Sell-to Address 2"; "Sell-to Address 2")
            {
                ApplicationArea = All;
            }
            field("Sell-to City"; "Sell-to City")
            {
                ApplicationArea = All;
            }
            field("Sell-to Contact"; "Sell-to Contact")
            {
                ApplicationArea = All;
            }
            field("Bill-to Post Code"; "Bill-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Bill-to County"; "Bill-to County")
            {
                ApplicationArea = All;
            }
            field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("Sell-to Post Code"; "Sell-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Sell-to County"; "Sell-to County")
            {
                ApplicationArea = All;
            }
            field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("Ship-to Post Code"; "Ship-to Post Code")
            {
                ApplicationArea = All;
            }
            field("Ship-to County"; "Ship-to County")
            {
                ApplicationArea = All;
            }
            field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("Document Date"; "Document Date")
            {
                ApplicationArea = All;
            }
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
            }
            field("Tax Area Code"; "Tax Area Code")
            {
                ApplicationArea = All;
            }
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Sell-to Phone No."; "Sell-to Phone No.")
            {
                ApplicationArea = All;
            }
            field("Sell-to E-Mail"; "Sell-to E-Mail")
            {
                ApplicationArea = All;
            }
            field("Cust. Ledger Entry No."; "Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
            }
            field("Sell-to Contact No."; "Sell-to Contact No.")
            {
                ApplicationArea = All;
            }
            field(Posted; Posted)
            {
                ApplicationArea = All;
            }
            field("Order Id"; "Order Id")
            {
                ApplicationArea = All;
            }
            field("Currency Id"; "Currency Id")
            {
                ApplicationArea = All;
            }
            field("Payment Terms Id"; "Payment Terms Id")
            {
                ApplicationArea = All;
            }
            field("Shipment Method Id"; "Shipment Method Id")
            {
                ApplicationArea = All;
            }
            field("Bill-to Customer Id"; "Bill-to Customer Id")
            {
                ApplicationArea = All;
            }
            part(PostedSalesLines; "Posted Sales Invoice Subform")
            {
                ApplicationArea = All;
                Caption = 'Posted Lines', Locked = true;
                EntityName = 'PostedLine';
                EntitySetName = 'PostedLines';
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }
}