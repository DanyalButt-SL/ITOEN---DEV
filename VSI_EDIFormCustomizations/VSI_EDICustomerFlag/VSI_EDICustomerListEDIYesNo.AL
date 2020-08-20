pageextension 50101 VSI_EDICustomerListEDIYesNo extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("EDI Compliant"; "EDI Compliant")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The customers are EDI are capable or not.';
                Visible = true;
            }
        }
    }
}