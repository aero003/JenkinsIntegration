public with sharing class OracleSObjectSyncExt {

	private final sObject mysObject;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public OracleSObjectSyncExt(ApexPages.StandardController stdController) {
        List<String> fields = new List<String>{'Oracle_Service_Cloud_ID__c'};
        if (! Test.isRunningTest()) {
            stdController.addFields(fields);    
        }
        
        this.mysObject = (sObject)stdController.getRecord();
    }

    public PageReference sync() {
        String recordId = (String) mysObject.get('Id');
        Boolean isActivated = String.isEmpty(recordId);
        if (recordId.startsWith('001')) {
            OracleAccountSync.syncWithOracle(new List<Id>{(Id)mysObject.get('Id')}, mysObject.get('Oracle_Service_Cloud_ID__c') != null, isActivated, false);
        }
        if (recordId.startsWith('003')) {
            OracleContactSync.syncWithOracle(new List<Id>{(Id)mysObject.get('Id')}, mysObject.get('Oracle_Service_Cloud_ID__c') != null, isActivated, false, null);
        }
        if (recordId.startsWith('500')) {
            OracleCaseSync.syncWithOracle(new List<Id>{(Id)mysObject.get('Id')}, mysObject.get('Oracle_Service_Cloud_ID__c') != null);
        }

        return new PageReference('/' + recordId);
    }
}