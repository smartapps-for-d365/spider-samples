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
                    ToolTip = 'Specifies the entry number for the Integration Queue Entry that this line is connected to.';
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number for this line.';
                    Editable = false;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date that was imported from the text file.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account number that was imported from the text file.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount in LCY that was imported from the text file.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description that was imported from the text file.';
                }
                field("Manually Changed"; Rec."Manually Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the line has been manually modified by a user.';
                    Editable = false;
                }
            }
        }
    }
}