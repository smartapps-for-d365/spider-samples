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
                    ToolTip = 'Specifies the entry number for the Integration Queue History that this line is connected to.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number for this line.';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number that was used when posting this line.';
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the G/L register that was created when posting this line.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date that was used when posting this line.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account number that was used when posting this line.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount in LCY that was used when posting this line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description that was used when posting this line.';
                }
                field("Posted Entry No."; Rec."Posted Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number for the posted G/L Entry.';
                }
                field("Manually Changed"; Rec."Manually Changed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the line has been manually modified by a user after the file was imported, but before posting.';
                }
            }
        }
    }
}