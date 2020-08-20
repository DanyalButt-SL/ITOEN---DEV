tableextension 50113 VSI_EDISalesLineExt extends "Sales Line"
{
    fields
    {
        field(7011; "Customer line no."; Integer)
        {
            Caption = 'Customer line no.';
            DataClassification = SystemMetadata;
        }
    }
}