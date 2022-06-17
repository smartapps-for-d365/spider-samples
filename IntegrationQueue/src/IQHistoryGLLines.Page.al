page 63201 "IQ History G/L Lines"
{
    Caption = 'IQ History G/L Lines';
    Editable = false;
    PageType = List;
    SourceTable = "IQ History G/L Line";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("IQ Entry No."; Rec."IQ Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
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
                field("Posted Entry No."; Rec."Posted Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Manually Changed"; Rec."Manually Changed")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
