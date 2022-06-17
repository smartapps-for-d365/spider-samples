page 63202 "IQ G/L Import Setup"
{
    Caption = 'IQ G/L Import Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "IQ G/L Import Setup";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Integration Setup Code"; Rec."Integration Setup Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Nos."; Rec."Posting Nos.")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
