report 50119 VSI_TrialBalanceSummary
{
    DefaultLayout = RDLC;
    RDLCLayout = './VSI_TrialBalanceSummary.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'ITOEN – Trial Balance';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(MainTitle; MainTitle)
            {
            }
            column(TIME; TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f'))
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(GLEntryFilter; GLEntryFilter)
            {
            }
            column(PrintTypeAll; PrintTypeAll)
            {
            }
            column(PrintTypeBalances; PrintTypeBal)
            {
            }
            column(PrintTypeActivities; PrintTypeAct)
            {
            }
            column(PrintType; PrintType)
            {
            }
            column(UseAddRptCurr; UseAddRptCurr)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(IncludeSecondLine; IncludeSecondLine)
            {
            }
            column(OnlyOnePerPage; OnlyOnePerPage)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; "G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(G_L_Entry__TABLECAPTION__________GLEntryFilter; "G/L Entry".TableCaption + ': ' + GLEntryFilter)
            {
            }
            column(STRSUBSTNO_Text002__No___; StrSubstNo(Text002, "No."))
            {
            }
            column(G_L_Account_Name; Name)
            {
            }
            column(BeginningBalance; BeginningBalance)
            {
            }
            column(AnyEntries; AnyEntries)
            {
            }
            column(BeginBalTotal; BeginBalTotal)
            {
            }
            column(DebitAmount_GLAccount; DebitAmount)
            {
            }
            column(CreditAmount_GLAccount; CreditAmount)
            {
            }
            column(EndBalTotal; EndBalTotal)
            {
            }
            column(G_L_Account_No_; "No.")
            {
                IncludeCaption = true;
            }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {

            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Account_Business_Unit_Filter; "Business Unit Filter")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NoBalCaption; NoBalCaptionLbl)
            {
            }
            column(NoActCaption; NoActCaptionLbl)
            {
            }
            column(BalZeroCaption; BalZeroCaptionLbl)
            {
            }
            column(PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaptionLbl)
            {
            }
            column(DebitAmount_Control85Caption; DebitAmount_Control85CaptionLbl)
            {
            }
            column(CreditAmount_Control86Caption; CreditAmount_Control86CaptionLbl)
            {
            }
            column(DebitAmount_Control75Caption; DebitAmount_Control75CaptionLbl)
            {
            }
            column(CreditAmount_Control76Caption; CreditAmount_Control76CaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Beginning_BalanceCaption; Beginning_BalanceCaptionLbl)
            {
            }
            column(Ending_BalanceCaption; Ending_BalanceCaptionLbl)
            {
            }
            column(ReportTotalsCaption; ReportTotalsCaptionLbl)
            {
            }
            column(ReportTotalBegBalCaption; ReportTotalBegBalCaptionLbl)
            {
            }
            column(ReportTotalActivitiesCaption; ReportTotalActivitiesCaptionLbl)
            {
            }
            column(ReportTotalEndBalCaption; ReportTotalEndBalCaptionLbl)
            {
            }
            column(ExternalDocNoCaption; ExternalDocNoCaptionLbl)
            {
            }

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Business Unit Code" = FIELD("Business Unit Filter");
                DataItemTableView = SORTING("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                RequestFilterFields = "Document Type", "Document No.";
                column(Account_______G_L_Account___No__; 'Account: ' + "G/L Account"."No.")
                {
                }
                column(G_L_Account__Name; "G/L Account".Name)
                {
                }
                column(DebitAmount_GLEntry; DebitAmount)
                {
                }
                column(CreditAmount_GLEntry; CreditAmount)
                {
                }
                column(BeginningBalance_GLEntry; BeginningBalance)
                {
                }
                column(G_L_Entry__Posting_Date_; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Document_Type_; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Document_No__; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Ext_Document_No__; "External Document No.")
                {
                }
                column(G_L_Entry__Source_Code_; "Source Code")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Source_Type_; "Source Type")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry__Source_No__; "Source No.")
                {
                    IncludeCaption = true;
                }
                column(G_L_Entry_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Seq1; Seq1)
                {
                }
                column(SourceName; SourceName)
                {
                }
                column(G_L_Entry_Entry_No_; "Entry No.")
                {
                }
                column(G_L_Entry_G_L_Account_No_; "G/L Account No.")
                {
                }
                column(G_L_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(G_L_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(G_L_Entry_Business_Unit_Code; "Business Unit Code")
                {
                }
                column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                {
                }
                column(Balance_to_Carry_ForwardCaption; Balance_to_Carry_ForwardCaptionLbl)
                {
                }

                // VSI Customization
                column(GL_Entry_Debit; "Debit Amount")
                {
                }

                column(GL_Entry_Credit; "Credit Amount")
                {
                }

                column(VSI_OpeningBalance; VSI_OpeningBalance)
                {

                }

                // VSI Customization

                trigger OnAfterGetRecord()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    VSI_OpeningBalance := 0;
                    GLEntry.Reset();
                    GlEntry.SetRange("Posting Date", 0D, ClosingDate(FromDate - 1));
                    GlEntry.SetRange("Global Dimension 1 Code", "G/L Entry"."Global Dimension 1 Code");
                    GlEntry.SetRange("Global Dimension 2 Code", "G/L Entry"."Global Dimension 2 Code");
                    GlEntry.SetRange("G/L Account No.", "G/L Entry"."G/L Account No.");

                    if GlEntry.FindSet() then begin
                        repeat
                            VSI_OpeningBalance += GlEntry.Amount;
                        until GlEntry.Next() = 0;
                    end else begin
                        VSI_OpeningBalance := 0;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if GLEntryFilter <> '' then begin
                        EndingBalance := TotalDebitAmount - TotalCreditAmount;
                        EndBalTotal := EndBalTotal + EndingBalance;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", FromDate, ToDate);
                    Clear("G/L Entry"."Debit Amount");
                    Clear("G/L Entry"."Credit Amount");
                end;
            }
            trigger OnAfterGetRecord()

            begin
                // Sets filter to only get Net Change up to closing date of
                // previous period which is the beginnig balance for this period
                SetRange("Date Filter", 0D, ClosingDate(FromDate - 1));
                if UseAddRptCurr then begin
                    CalcFields("Additional-Currency Net Change");
                    BeginningBalance := "Additional-Currency Net Change";
                end else begin
                    CalcFields("Net Change");
                    BeginningBalance := "Net Change";
                end;

                // Are there any Activities (entries) for this account?
                "G/L Entry".CopyFilters(TempGLEntry);            // get saved user filters
                "G/L Entry".SetFilter("G/L Account No.", "No.");  // then add our own
                "G/L Entry".SetRange("Posting Date", FromDate, ToDate);
                CopyFilter("Global Dimension 1 Filter", "G/L Entry"."Global Dimension 1 Code");
                CopyFilter("Global Dimension 2 Filter", "G/L Entry"."Global Dimension 2 Code");
                CopyFilter("Business Unit Filter", "G/L Entry"."Business Unit Code");
                with "G/L Entry" do
                    SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                AnyEntries := "G/L Entry".Find('-');

                if (PrintType = PrintType::"Accounts with Activities") and not AnyEntries then
                    CurrReport.Skip();
                if (PrintType = PrintType::"Accounts with Balances") and
                   not AnyEntries and
                   (VSI_OpeningBalance = 0)
                then
                    CurrReport.Skip();
            end;

        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Show; PrintType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show';
                        OptionCaption = 'All Accounts,Accounts with Balances,Accounts with Activities';
                        ToolTip = 'Specifies which accounts to include. All Accounts: Includes all accounts with transactions. Accounts with Balances: Includes accounts with balances. Accounts with Activity: Includes accounts that are currently active.';
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        begin
            if "G/L Account".GetFilter("Date Filter") = '' then
                "G/L Account".SetRange("Date Filter", CalcDate('<-CM>', WorkDate), WorkDate);
        end;

    }

    labels
    {
    }
    trigger OnInitReport()
    begin
        PrintTypeAll := PrintType::"All Accounts";
        PrintTypeAct := PrintType::"Accounts with Activities";
        PrintTypeBal := PrintType::"Accounts with Balances";
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        FromDate := "G/L Account".GetRangeMin("Date Filter");
        ToDate := "G/L Account".GetRangeMax("Date Filter");
        PeriodText := StrSubstNo(Text000, Format(FromDate, 0, 4), Format(ToDate, 0, 4));
        "G/L Account".SetRange("Date Filter");
        GLFilter := "G/L Account".GetFilters;
        GLEntryFilter := "G/L Entry".GetFilters;
        EndBalTotal := 0;
        BeginBalTotal := 0;
        if GLEntryFilter <> '' then begin
            TempGLEntry.CopyFilters("G/L Entry");  // save user filters for later
                                                   // accounts w/o activities are never printed if all the
                                                   // user is interested in are certain activities.
            if PrintType = PrintType::"All Accounts" then
                PrintType := PrintType::"Accounts with Activities";
        end;
        if PrintDetail then
            MainTitle := Text003
        else
            MainTitle := Text004;
        if UseAddRptCurr then begin
            GLSetup.Get();
            Currency.Get(GLSetup."Additional Reporting Currency");
            SubTitle := StrSubstNo(Text001, Currency.Description);
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        TempGLEntry: Record "G/L Entry" temporary;
        TypeHelper: Codeunit "Type Helper";
        GLFilter: Text;
        GLEntryFilter: Text;
        FromDate: Date;
        ToDate: Date;
        PeriodText: Text[80];
        MainTitle: Text[88];
        SubTitle: Text[132];
        SourceName: Text[100];
        OnlyOnePerPage: Boolean;
        PrintType: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        IncludeSecondLine: Boolean;
        PrintDetail: Boolean;
        BeginningBalance: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        EndingBalance: Decimal;
        BeginBalTotal: Decimal;
        EndBalTotal: Decimal;
        AnyEntries: Boolean;
        UseAddRptCurr: Boolean;
        Text000: Label 'Date : from %1 to %2';
        Text001: Label 'Amounts are in %1';
        Text002: Label 'Account: %1';
        PrintTypeAll: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        PrintTypeBal: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        PrintTypeAct: Option "All Accounts","Accounts with Balances","Accounts with Activities";
        Text003: Label 'Detail Trial Balance';
        Text004: Label 'Summary Trial Balance';
        Seq1: Integer;
        Seq2: Integer;
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        NoBalCaptionLbl: Label 'Accounts without activities or balances during the above period are not included.';
        NoActCaptionLbl: Label 'Accounts without activities during the above period are not included.';
        BalZeroCaptionLbl: Label 'Beginning Balances are set to zero due to existence of G/L Entry filters.';
        PADSTR_____G_L_Account__Indentation_____G_L_Account__NameCaptionLbl: Label 'Name';
        DebitAmount_Control85CaptionLbl: Label 'Total Debit Activities';
        CreditAmount_Control86CaptionLbl: Label 'Total Credit Activities';
        DebitAmount_Control75CaptionLbl: Label 'Debit Activities';
        CreditAmount_Control76CaptionLbl: Label 'Credit Activities';
        BalanceCaptionLbl: Label 'Balance';
        Beginning_BalanceCaptionLbl: Label 'Beginning Balance';
        ReportTotalsCaptionLbl: Label 'Report Totals';
        ReportTotalBegBalCaptionLbl: Label 'Report Total Beginning Balance';
        ReportTotalActivitiesCaptionLbl: Label 'Report Total Activities';
        ReportTotalEndBalCaptionLbl: Label 'Report Total Ending Balance';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        Total_ActivitiesCaptionLbl: Label 'Total Activities';
        Ending_BalanceCaptionLbl: Label 'Ending Balance';
        ExternalDocNoCaptionLbl: Label 'External Doc. No.';
        VSI_OpeningBalance: Decimal;

}
