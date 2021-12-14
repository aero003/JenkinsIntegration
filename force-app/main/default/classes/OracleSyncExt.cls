public with sharing class OracleSyncExt {

	private final Oracle_Error__c errorRecord;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public OracleSyncExt(ApexPages.StandardController stdController) {
        List<String> fields = new List<String> {'Account__c', 'Contact__c', 'Case__c', 'Attachment__c', 'Email_Message__c'};
        if (!Test.isRunningTest()) {
            stdController.addFields(fields);
        }
        this.errorRecord = (Oracle_Error__c)stdController.getRecord();
    }

    public PageReference sync() {

        if (String.isNotEmpty(this.errorRecord.Account__c) ) {
            Account a = [SELECT Oracle_Service_Cloud_ID__c FROM Account WHERE Id = :this.errorRecord.Account__c];
            OracleAccountSync.syncWithOracle(new List<Id>{this.errorRecord.Account__c}, a.Oracle_Service_Cloud_ID__c != null, false, false);
            return new PageReference('/' + this.errorRecord.Account__c);
        }

        if (String.isNotEmpty(this.errorRecord.Contact__c) ) {
            Contact c = [SELECT Oracle_Service_Cloud_ID__c FROM Contact WHERE Id = :this.errorRecord.Contact__c];
            OracleContactSync.syncWithOracle(new List<Id>{this.errorRecord.Contact__c}, 
                c.Oracle_Service_Cloud_ID__c != null, false, false, new Map<Id, String>());
            return new PageReference('/' + this.errorRecord.Contact__c);
        }

        if (String.isNotEmpty(this.errorRecord.Case__c) ) {
            if (String.isNotEmpty(this.errorRecord.Attachment__c)) {
                OracleAttachmentSync.syncWithOracle(new List<Id>{this.errorRecord.Attachment__c},
                    new Set<Id>{this.errorRecord.Case__c});
                return new PageReference('/' + this.errorRecord.Case__c);
            }
            if (String.isNotEmpty(this.errorRecord.Email_Message__c)) {
                OracleEmailMessageSync.syncWithOracle(new List<Id>{this.errorRecord.Email_Message__c}, 
                    new Set<Id>{this.errorRecord.Case__c}, false);
                return new PageReference('/' + this.errorRecord.Case__c);
            }

            Case c = [SELECT Oracle_Service_Cloud_ID__c FROM Case WHERE Id = :this.errorRecord.Case__c];
            OracleCaseSync.syncWithOracle(new List<Id>{this.errorRecord.Case__c}, c.Oracle_Service_Cloud_ID__c != null);
            return new PageReference('/' + this.errorRecord.Case__c);
        }

        return null;
    }
}