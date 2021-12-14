public with sharing class AttachmentTriggerHandler {
	public AttachmentTriggerHandler() {
		
	}

	public void doAfterInsert(List<Attachment> attachments) {

		Set<Id> caseIds = new Set<Id>();

        if (System.isFuture()) { //also add the oracle integration user
            //attachment was downloaded from oracle.
            return;
        }

	    for ( Attachment att : attachments ){
	      //check if added attachment is related to case or not
	        if ( att.parentId != null && string.valueOf(att.parentId).subString(0,3) == '500' )  {
	        	caseIds.add(att.parentId);
	        }      
	    }

	    //get the cases from above which have been synched with oracle
	    Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case WHERE Oracle_Service_Cloud_ID__c != null AND id IN :caseIds]);//, Oracle_Service_Cloud_ID__c
	    if (cases.isEmpty()) return;

		syncWithOracle(attachments, cases);
	}

    private void syncWithOracle(List<Attachment> attachments, Map<Id, Case> cases) {
        
        Map<Id, Attachment> recordsToSync = new Map<Id, Attachment>();
        Map<Id, Attachment> temp = new Map<Id, Attachment>();

        for (Attachment att : attachments) {
        	if (! OracleAttachmentSync.integrateWithOracle(att, cases)) continue;

            temp.put(att.Id, att);

            if (temp.size() == 10) { //smaller number as there be contacts/cases to sync.
                recordsToSync.clear();
                recordsToSync.putAll(temp);
                OracleAttachmentSync.sync(recordsToSync, cases);
                temp.clear();
            }
        }

        if ( ! temp.isEmpty()) {
            OracleAttachmentSync.sync(temp,cases);
        }

    }


}