pageextension 50102 VSI_EDICustomerCardEDIToggle extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("EDI Compliant"; "EDI Compliant")
            {
                ApplicationArea = All;
            }
        }

    }
}