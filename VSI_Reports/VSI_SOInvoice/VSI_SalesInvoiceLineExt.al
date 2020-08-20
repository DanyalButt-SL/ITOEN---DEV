tableextension 50116 VSI_SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50103; QTYBO; Decimal)
        {
            InitValue = 0.0;
        }
        field(50104; GDTHSTPerc; Decimal)
        {
            InitValue = 0.0;
        }
        field(50105; GDTHST; Decimal)
        {
            InitValue = 0.0;
        }
    }

}