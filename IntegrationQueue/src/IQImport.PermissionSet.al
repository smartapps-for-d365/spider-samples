permissionset 63200 "IQ Import"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions', Locked = true;

    Permissions =
         codeunit "IQ Import G/L Handler" = X,
         page "IQ G/L Import Setup" = X,
         page "IQ G/L Lines" = X,
         page "IQ History G/L Lines" = X,
         table "IQ G/L Import Setup" = X,
         table "IQ G/L Line" = X,
         table "IQ History G/L Line" = X,
         tabledata "IQ G/L Import Setup" = RIMD,
         tabledata "IQ G/L Line" = RIMD,
         tabledata "IQ History G/L Line" = RIMD;
}