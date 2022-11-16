enumextension 63200 "IQIT Extension" extends "QWESR IQ Integration Type"
{
    value(63200; "Import G/L Entries (Sample)")
    {
        Caption = 'Import G/L Entries (Sample)';
        Implementation = "QWESR IQ Integration Type" = "IQ Import G/L Handler";
    }
}