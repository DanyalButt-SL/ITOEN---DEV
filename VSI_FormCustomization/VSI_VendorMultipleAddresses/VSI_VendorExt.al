//This tables extension will be used to add new fields
tableextension 50104 VSI_VendorExt extends "Vendor"
{
    fields
    {
        // default order address field
        field(27041; "Order address code"; Code[10])
        {
            Caption = 'Default main address';
            TableRelation = "Order Address".Code where("Vendor No." = field("No."));
        }
    }
}