// this page extension will be used to add new fields
pageextension 50105 VSI_VendorCardExt extends "Vendor Card"
{
    layout
    {
        addlast(AddressDetails)
        {
            field("Order address code"; "Order address code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Default main address';
            }
        }
    }
}