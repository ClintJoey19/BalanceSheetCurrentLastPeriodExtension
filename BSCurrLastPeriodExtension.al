reportextension 50107 BSCurrLastPeriodExtension extends "Balance Sheet"
{
    RDLCLayout = './BSCurrLastPeriodExtension.rdl';

    dataset 
    {
        add("G/L Account") 
        {
            column(CurrentPeriodBalance; CurrentPeriodBalance) {}
            column(CurrentPeriodBudget; CurrentPeriodBudget) {}
            column(CurrentPeriodVariance; CurrentPeriodVariance) {}

            column(LastYearPeriodBalance; LastYearPeriodBalance) {}
            column(LastYearPeriodBudget; LastYearPeriodBudget) {}
            column(LastYearPeriodVariance; LastYearPeriodVariance) {}
        }

        modify("G/L Account")
        {
            trigger OnAfterAfterGetRecord()
            var
                ReportDateFilter: Text;
                CurrentStartDate: Date;
                CurrentEndDate: Date;
                LastYearStartDate: Date;
                LastYearEndDate: Date;

            begin
                ReportDateFilter := "G/L Account".GetFilter("Date Filter");

                if "G/L Account".GetFilter("Date Filter") <> '' then begin
                    CurrentStartDate := "G/L Account".GetRangeMin("Date Filter");
                    CurrentEndDate := "G/L Account".GetRangeMax("Date Filter");
                end else begin
                    CurrentStartDate := WorkDate();
                    CurrentEndDate := WorkDate();
                end;

                LastYearStartDate := CalcDate('<-1Y>', CurrentStartDate);
                LastYearEndDate := CalcDate('<-1Y>', CurrentEndDate);

                "G/L Account".SetRange("Date Filter", CurrentStartDate, CurrentEndDate);
                "G/L Account".SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");
                "G/L Account".CalcFields("Net Change", "Budgeted Amount");
                CurrentPeriodBalance := "G/L Account"."Net Change";
                CurrentPeriodBudget := "G/L Account"."Budgeted Amount";
                CurrentPeriodVariance := CurrentPeriodBalance - CurrentPeriodBudget;

                "G/L Account".SetRange("Date Filter", LastYearStartDate, LastYearEndDate);
                "G/L Account".SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");
                "G/L Account".CalcFields("Net Change", "Budgeted Amount");
                LastYearPeriodBalance := "G/L Account"."Net Change";
                LastYearPeriodBudget := "G/L Account"."Budgeted Amount";
                LastYearPeriodVariance := LastYearPeriodBalance - LastYearPeriodBudget;

                // Reset the date filter
                "G/L Account".SetFilter("Date Filter", ReportDateFilter);
            end;
        }
    }

    var
        CurrentPeriodBalance: Decimal;
        CurrentPeriodBudget: Decimal;
        CurrentPeriodVariance: Decimal;
        LastYearPeriodBalance: Decimal;
        LastYearPeriodBudget: Decimal;
        LastYearPeriodVariance: Decimal;
}