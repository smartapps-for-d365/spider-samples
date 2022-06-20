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
                    ToolTip = 'Specifies the code for this integration.';
                    Editable = false;
                }
                field("Posting Nos."; Rec."Posting Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used for posting to G/L.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code that will be used when posting to G/L.';
                }
            }
        }
    }
}