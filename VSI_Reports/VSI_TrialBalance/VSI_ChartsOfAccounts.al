pageextension 50118 VSI_ChartsOfAccounts extends "Chart of Accounts"
{
    // Added menu item for Trial Balance Detail/Summary with Dimensions 
    actions
    {
        addafter("Trial Balance Detail/Summary")
        {
            action(VSI_TrialBalanceSummaryDimension)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance Detail/Summary - ITOEN';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report VSI_TrialBalanceSummary;
                ToolTip = 'View general ledger account balances with Dimensions';
            }
        }
    }
}