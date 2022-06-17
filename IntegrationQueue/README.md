# Spider Integration Queue Import Sample

This app demonstrates how to utilize the Integration Queue in Spider to
implement a simple import and handling of a text file.

The steps to create this kind of integration is documented on <https://docs.smartappsford365.com/spider/integrationqueue-how-to-create-custom-integration-type/>

## The Business Logic

All business logic is collected in the [IQ Import G/L Handler](src/IQImportGLHandler.Codeunit.al) codeunit.

## Sample data

The file [sample.txt](sample.txt) contains sample data that could be used to test this app.
The sample data contains G/L Accounts that probably does not exit in a CRONUS
database, only to demonstrate the error handling in the Integration Queue.
