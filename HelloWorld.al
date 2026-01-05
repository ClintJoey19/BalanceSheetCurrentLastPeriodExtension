pageextension 50100 BSCurrLastPeriodExtension extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;
}