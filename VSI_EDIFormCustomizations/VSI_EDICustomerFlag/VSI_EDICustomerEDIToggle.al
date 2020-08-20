tableextension 50100 VSI_EDICustomerEDIToggle extends Customer
{
    fields
    {
        field(50103; "EDI Compliant"; Boolean)
        {
            Caption = 'EDI Compliant';
            DataClassification = SystemMetadata;
        }
    }
}