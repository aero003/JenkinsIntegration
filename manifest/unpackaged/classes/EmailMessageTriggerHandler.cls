public with sharing class EmailMessageTriggerHandler {
	public EmailMessageTriggerHandler() {
		
	}

	public void doAfterInsert(List<EmailMessage> emailMessages) {

		Set<Id> caseIds = new Set<Id>();

	    for ( EmailMessage em : emailMessages ){
	      //check if added attachment is related to case or not
	        if ( em.parentId != null && string.valueOf(em.parentId).subString(0,3) == '500'  
                || em.parentId != null && string.valueOf(em.parentId).subString(0,3) == '02s')  {
	        	caseIds.add(em.parentId);
	        }      
	    }

	    //get the cases from above which have been synched with oracle
	    Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case WHERE Oracle_Service_Cloud_ID__c != null AND id IN :caseIds]);//, Oracle_Service_Cloud_ID__c
	    if (cases.isEmpty()) return;

		syncWithOracle(emailMessages, cases, false);
	}

    private void syncWithOracle(List<EmailMessage> emailMessages, Map<Id, Case> cases, Boolean isUpdate) {

        OracleSettings__c settings = OracleService.getOracleSettings();
        Boolean isApiUser = (Test.isRunningTest()) ? false : settings.Salesforce_API_User__c.equalsIgnoreCase(UserInfo.getUserName());
        if (isApiUser) return;        
        
        Map<Id, EmailMessage> recordsToSync = new Map<Id, EmailMessage>();
        Map<Id, EmailMessage> temp = new Map<Id, EmailMessage>();

        for (EmailMessage em : emailMessages) {
        	if (! OracleEmailMessageSync.integrateWithOracle(em, cases)) continue;

            temp.put(em.Id, em);

            if (temp.size() == 10) { //smaller number as there be contacts/cases to sync.
                recordsToSync.clear();
                recordsToSync.putAll(temp);
                OracleEmailMessageSync.sync(recordsToSync, cases, isUpdate);
                temp.clear();
            }
        }

        if ( ! temp.isEmpty()) {
            OracleEmailMessageSync.sync(temp,cases, isUpdate);
        }

    }
}