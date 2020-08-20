pageextension 50114 VSI_EDISalesOrderExt extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Customer line no."; "Customer line no.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'This field will be used by EDI for complate data transformation';
                Visible = true;
            }
        }
    }
}