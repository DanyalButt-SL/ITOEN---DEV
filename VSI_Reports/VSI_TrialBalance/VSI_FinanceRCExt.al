pageextension 50120 VSI_FinanceRCExt extends "Finance Manager Role Center"
{
    actions
    {
        addlast(Group9)
        {
            action(VSI_TrialBalanceDimensions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance Detail/Summary - ITOEN';
                RunObject = report VSI_TrialBalanceSummary;
            }
        }
    }
}