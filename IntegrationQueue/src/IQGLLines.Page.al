page 63200 "IQ G/L Lines"
{
    Caption = 'IQ G/L Lines';
    Editable = true;
    PageType = List;
    SourceTable = "IQ G/L Line";
    UsageCategory = None;
    AutoSplitKey = true;
    DelayedInsert = true;
    PopulateAllFields = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("IQ Entry No."; Rec."IQ Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Manually Changed"; Rec."Manually Changed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
