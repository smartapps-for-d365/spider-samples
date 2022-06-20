table 63202 "IQ G/L Import Setup"
{
    Caption = 'IQ G/L Import Setup';

    fields
    {
        field(1; "Integration Setup Code"; Code[20])
        {
            Caption = 'Integration Setup Code';
            DataClassification = CustomerContent;
        }
        field(10; "Posting Nos."; Code[20])
        {
            Caption = 'Posting Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(11; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
    keys
    {
        key(PK; "Integration Setup Code")
        {
            Clustered = true;
        }
    }
}
