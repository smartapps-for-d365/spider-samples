table 63201 "IQ History G/L Line"
{
    Caption = 'IQ History G/L Line';
    DrillDownPageId = "IQ History G/L Lines";
    LookupPageId = "IQ History G/L Lines";

    fields
    {
        field(1; "IQ Entry No."; Integer)
        {
            Caption = 'IQ Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "QWESR Integration Queue Hist"."Entry No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(13; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(100; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(101; "G/L Register No."; Integer)
        {
            BlankZero = true;
            Caption = 'G/L Register No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Register";
        }
        field(102; "Posted Entry No."; Integer)
        {
            Caption = 'Posted Entry No.';
            DataClassification = CustomerContent;
        }
        field(103; "Manually Changed"; Boolean)
        {
            Caption = 'Manually Changed';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "IQ Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(NavigateFindKey; "Document No.", "Posting Date")
        {

        }
    }
}
