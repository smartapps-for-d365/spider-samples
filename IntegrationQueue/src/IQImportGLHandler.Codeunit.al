codeunit 63200 "IQ Import G/L Handler" implements "QWESR IQ Integration Type"
{
    TableNo = "QWESR Integration Queue";

    trigger OnRun();
    var
        IQMain: Codeunit "QWESR IQ Main";
    begin
        Rec.Consistent(false); // Prevent any unwanted commits

        case Rec."Next Step" of
            "QWESR IQ Step"::Parse:
                ParseData(Rec);
            "QWESR IQ Step"::Validate:
                ValidateData(Rec);
            "QWESR IQ Step"::Post:
                PostData(Rec);
            else
                Error('Unknown step ''%1'' for integration ''%2''!', Rec."Next Step", Rec."Integration Setup Code");
        end;

        IQMain.SetNextStep(Rec); // This increases the "Next Step" on this record to the next step defined in this Integration Type, after the last defined step a default "Archive" step is set
        Rec.Consistent(true); // Allow commits again
    end;

    local procedure ParseData(IQ: Record "QWESR Integration Queue")
    var
        IQGLLine: Record "IQ G/L Line";
        TempImportType: Record "QWETB Import Type" temporary;
        TextFileImporter: Codeunit "QWETB Text File Importer";
        TempBlob: Codeunit "Temp Blob";
        Field: array[500] of Text;
        NoOfFields: Integer;
    begin
        TempImportType.Init();
        TempImportType."Date Format" := 'YYYYMMDD';
        TempImportType."Decimal Format" := TempImportType."Decimal Format"::Comma;
        TempImportType."File Format" := TempImportType."File Format"::Separator;
        TempImportType."Separator sign" := TempImportType."Separator sign"::Semicolon;
        TempImportType."Text Format" := TempImportType."Text Format"::UTF8;
        TextFileImporter.SetImportType(TempImportType);
        TempBlob.FromRecord(IQ, IQ.FieldNo(Data));
        TextFileImporter.ReadTextBLOB(TempBlob); // TODO: Switch to the new function 'IQ.GetData()' when available

        while TextFileImporter.GetTextLine(Field, NoOfFields) do begin
            IQGLLine.Init();
            IQGLLine."IQ Entry No." := IQ."Entry No.";
            IQGLLine."Line No." += 10000;
            IQGLLine."Posting Date" := TextFileImporter.Txt2Date(Field[1]);
            IQGLLine."Account No." := Field[2];
            IQGLLine."Amount (LCY)" := TextFileImporter.Txt2Dec(Field[3]);
            IQGLLine.Description := Field[4];
            IQGLLine.Insert();
        end;
    end;

    local procedure ValidateData(IQ: Record "QWESR Integration Queue")
    var
        IQGLLine: Record "IQ G/L Line";
        GLAccount: Record "G/L Account";
    begin
        IQGLLine.SetRange("IQ Entry No.", IQ."Entry No.");
        if IQGLLine.FindSet() then
            repeat
                IQGLLine.TestField("Account No.");
                IQGLLine.TestField("Posting Date");
                IQGLLine.TestField("Amount (LCY)");
                GLAccount.Get(IQGLLine."Account No.");
                GLAccount.TestField("Account Type", GLAccount."Account Type"::Posting);
                GLAccount.TestField("Direct Posting", true);
            until IQGLLine.Next() = 0;
    end;

    local procedure PostData(IQ: Record "QWESR Integration Queue")
    var
        IQGLLine: Record "IQ G/L Line";
        GenJournalLine: Record "Gen. Journal Line";
        GLReg: Record "G/L Register";
        IQGLImportSetup: Record "IQ G/L Import Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocNo: Code[20];
    begin
        IQGLImportSetup := GetSetup(IQ."Integration Setup Code");
        IQGLImportSetup.TestField("Posting Nos.");

        IQGLLine.SetRange("IQ Entry No.", IQ."Entry No.");
        if IQGLLine.FindSet(true) then begin
            DocNo := NoSeriesManagement.DoGetNextNo(IQGLImportSetup."Posting Nos.", IQGLLine."Posting Date", true, false);
            repeat
                IQGLLine.TestField("Account No.");
                IQGLLine.TestField("Posting Date");
                IQGLLine.TestField("Amount (LCY)");
                GenJournalLine.Init();
                GenJournalLine."Document No." := DocNo;
                GenJournalLine.Validate("Posting Date", IQGLLine."Posting Date");
                GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.Validate("Account No.", IQGLLine."Account No.");
                GenJournalLine.Validate("Amount (LCY)", IQGLLine."Amount (LCY)");
                GenJournalLine.Validate(Description, IQGLLine.Description);
                GenJournalLine.Validate("Posting No. Series", IQGLImportSetup."Posting Nos.");
                GenJournalLine.Validate("Source Code", IQGLImportSetup."Source Code");
                IQGLLine."Posted Entry No." := GenJnlPostLine.RunWithCheck(GenJournalLine);
                IQGLLine."Document No." := DocNo;
                GenJnlPostLine.GetGLReg(GLReg);
                IQGLLine."G/L Register No." := GLReg."No.";
                IQGLLine.Modify();
            until IQGLLine.Next() = 0;
        end;
    end;

    #region Event Subscribers
    local procedure IsMyEvent(pIntegrationType: Enum "QWESR IQ Integration Type"): Boolean
    begin
        exit(pIntegrationType = "QWESR IQ Integration Type"::"Import G/L Entries");
    end;

    /// <summary>
    /// This event is triggered when a record in the Integration Queue History table is about to be deleted.
    /// This should be used to cleanup any data in other tables, related to this record.
    /// If there are nothing to do in this event, don't use it.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"QWESR Integration Type Mgt.", 'OnAfterDeleteIntegrationQueueHistory', '', false, false)]
    local procedure IntegrationTypeMgt_OnAfterDeleteIQHistory(IntegrationType: Enum "QWESR IQ Integration Type"; IntegrationQueueHistory: Record "QWESR Integration Queue Hist")
    var
        IQHistoryGLLine: Record "IQ History G/L Line";
    begin
        if not IsMyEvent(IntegrationType) then
            exit; // If not this Integration Type -> exit

        // Delete related data
        IQHistoryGLLine.SetRange("IQ Entry No.", IntegrationQueueHistory."Entry No.");
        IQHistoryGLLine.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"QWESR Integration Type Mgt.", 'OnAfterDeleteIntegrationQueue', '', false, false)]
    local procedure IntegrationTypeMgt_OnAfterDeleteIntegrationQueue(IntegrationType: Enum "QWESR IQ Integration Type"; var IQ: Record "QWESR Integration Queue")
    var
        IQGLLine: Record "IQ G/L Line";
    begin
        if not IsMyEvent(IntegrationType) then
            exit; // If not this Integration Type -> exit

        // Delete related data
        IQGLLine.SetRange("IQ Entry No.", IQ."Entry No.");
        IQGLLine.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterFindRecords', '', false, false)]
    local procedure Navigate_OnAfterFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; sender: Page Navigate)
    var
        IQHistoryGLLine: Record "IQ History G/L Line";
        IntegrationQueueHist: Record "QWESR Integration Queue Hist";
    begin
        if not IQHistoryGLLine.ReadPermission() then
            exit;
        if DocNoFilter = '' then
            exit;

        FilterNavigateRecords(DocNoFilter, PostingDateFilter, IQHistoryGLLine, IntegrationQueueHist);

        sender.InsertIntoDocEntry(DocumentEntry, DATABASE::"IQ History G/L Line", IQHistoryGLLine.TableCaption, IQHistoryGLLine.Count);
        sender.InsertIntoDocEntry(DocumentEntry, DATABASE::"QWESR Integration Queue Hist", IntegrationQueueHist.TableCaption, IntegrationQueueHist.Count());
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnBeforeNavigateShowRecords', '', false, false)]
    local procedure Navigate_OnBeforeNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; var TempDocumentEntry: Record "Document Entry"; var IsHandled: Boolean)
    var
        IQHistoryGLLine: Record "IQ History G/L Line";
        IntegrationQueueHist: Record "QWESR Integration Queue Hist";
    begin
        if IsHandled then
            exit;
        if not (TableID in [Database::"IQ History G/L Line", Database::"QWESR Integration Queue Hist"]) then
            exit;
        if DocNoFilter = '' then
            exit;

        FilterNavigateRecords(DocNoFilter, PostingDateFilter, IQHistoryGLLine, IntegrationQueueHist);

        if TableID = Database::"IQ History G/L Line" then
            Page.Run(0, IQHistoryGLLine)
        else
            Page.Run(0, IntegrationQueueHist);
    end;

    local procedure FilterNavigateRecords(DocNoFilter: Text; PostingDateFilter: Text; var IQHistoryGLLine: Record "IQ History G/L Line"; var IntegrationQueueHist: Record "QWESR Integration Queue Hist")
    begin
        IQHistoryGLLine.SetCurrentKey("Document No.", "Posting Date");
        IQHistoryGLLine.SetFilter("Document No.", DocNoFilter);
        IQHistoryGLLine.SetFilter("Posting Date", PostingDateFilter);

        if IQHistoryGLLine.FindSet() then
            repeat
                if IntegrationQueueHist.Get(IQHistoryGLLine."IQ Entry No.") then
                    IntegrationQueueHist.Mark(true);
            until IQHistoryGLLine.Next() = 0;
        IntegrationQueueHist.MarkedOnly(true);
    end;

    #endregion Event Subscribers

    #region Interface "QWESR IQ Integration Type"

#pragma warning disable AL0432
    procedure GetIntegrationSteps(IntegrationType: Codeunit "QWESR Integration Type Mgt."; var IQStepOrder: Record "QWESR tIQStepOrder" temporary)
#pragma warning restore AL0432
    begin
        IntegrationType.AddIntegrationStep("QWESR IQ Integration Type"::"Import G/L Entries", IQStepOrder, "QWESR IQ Step"::Parse, Codeunit::"IQ Import G/L Handler");
        IntegrationType.AddIntegrationStep("QWESR IQ Integration Type"::"Import G/L Entries", IQStepOrder, "QWESR IQ Step"::Validate, Codeunit::"IQ Import G/L Handler");
        IntegrationType.AddIntegrationStep("QWESR IQ Integration Type"::"Import G/L Entries", IQStepOrder, "QWESR IQ Step"::Post, Codeunit::"IQ Import G/L Handler");
    end;

    procedure ArchiveData(IQ: Record "QWESR Integration Queue")
    var
        IQGLLine: Record "IQ G/L Line";
        IQHistoryGLLine: Record "IQ History G/L Line";
    begin
        IQGLLine.SetRange("IQ Entry No.", IQ."Entry No.");
        if IQGLLine.FindSet() then
            repeat
                IQHistoryGLLine.TransferFields(IQGLLine);
                IQHistoryGLLine.Insert();
            until IQGLLine.Next() = 0;
        IQGLLine.DeleteAll();
    end;

    procedure IsIntegrationQueueDeletionAllowed(var IQ: Record "QWESR Integration Queue"): Boolean
    begin
    end;

    procedure IsIntegrationQueueImportDeletionAllowed(var IQImport: Record "QWESR Integration Queue Import"): Boolean
    begin
    end;

    procedure ShowDetails(IQ: Record "QWESR Integration Queue"): Boolean
    var
        IQGLLine: Record "IQ G/L Line";
    begin
        IQGLLine.FilterGroup := 2;
        IQGLLine.SetRange("IQ Entry No.", IQ."Entry No.");
        IQGLLine.FilterGroup := 0;
        IQGLLine.FindFirst();
        Page.Run(0, IQGLLine);
        exit(true);
    end;

    procedure ShowHistoryDetails(IntegrationQueueHistory: Record "QWESR Integration Queue Hist"): Boolean
    var
        IQHistoryGLLine: Record "IQ History G/L Line";
    begin
        IQHistoryGLLine.FilterGroup := 2;
        IQHistoryGLLine.SetRange("IQ Entry No.", IntegrationQueueHistory."Entry No.");
        IQHistoryGLLine.FilterGroup := 0;
        IQHistoryGLLine.FindFirst();
        Page.Run(0, IQHistoryGLLine);
        exit(true);
    end;

    procedure AnalyzeHistory(IntegrationQueueHistory: Record "QWESR Integration Queue Hist"): Boolean
    var
        IQHistoryGLLine: Record "IQ History G/L Line";
        Navigate: Page Navigate;
    begin
        IQHistoryGLLine.FilterGroup := 2;
        IQHistoryGLLine.SetRange("IQ Entry No.", IntegrationQueueHistory."Entry No.");
        IQHistoryGLLine.FilterGroup := 0;
        IQHistoryGLLine.FindFirst();
        Navigate.SetDoc(IQHistoryGLLine."Posting Date", IQHistoryGLLine."Document No.");
        Navigate.RunModal();
        exit(true);
    end;

    procedure AdditionalSettingsIsSupported(): Boolean
    begin
        exit(true);
    end;

    procedure ShowAdditionalSettings(IntegrationSetupCode: Code[20]): Boolean
    begin
        Page.Run(Page::"IQ G/L Import Setup", GetSetup(IntegrationSetupCode));
        exit(true);
    end;

    procedure ClearAdditionalSettings(IntegrationSetupCode: Code[20]): Boolean
    var
        IQGLImportSetup: Record "IQ G/L Import Setup";
    begin
        if IQGLImportSetup.Get(IntegrationSetupCode) then
            IQGLImportSetup.Delete();
        exit(true);
    end;
    #endregion Interface "QWESR IQ Integration Type"

    local procedure GetSetup(IntegrationSetupCode: Code[20]) IQGLImportSetup: Record "IQ G/L Import Setup"
    begin
        if not IQGLImportSetup.Get(IntegrationSetupCode) then begin
            IQGLImportSetup.Init();
            IQGLImportSetup."Integration Setup Code" := IntegrationSetupCode;
            IQGLImportSetup.Insert();
        end;
    end;
}
