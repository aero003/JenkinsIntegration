public with sharing class CaseTriggerHandler {
	public CaseTriggerHandler() {
		
	}

    public static Boolean run = true;

    public static Boolean runOnce() {
        if (run) {
            run = false;
            return true;
        }
        return run;
    }

    public void doAfterInsert(Map<Id, Case> newCases) {
        if (runOnce()) {
            syncWithOracle(null, newCases, false);
        }
    }

    public void doAfterUpdate(Map<Id, Case> oldCases, Map<Id, Case> newCases) {
        System.debug('run = ' + run);
        if (runOnce()) {
            syncWithOracle(oldCases, newCases, true);
        }
    }

    private void syncWithOracle(Map<Id, Case> oldCases, Map<Id, Case> newCases, Boolean isUpdate) {
        System.debug('CaseTriggerHandler.syncWithOracle(): isUpdate = ' + isUpdate);

        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Case', 'LiveVault: Case');
		Id rtId = rtInfo.getRecordTypeId();
        
        Map<Id, String> caseIdsWithAttachmentIds = new Map<Id, String>();
        for (Case c : newCases.values()) {
            
            Case oldCase = (isUpdate) ? oldCases.get(c.Id) : null;

            if ((!isUpdate && c.Oracle_Attachment_Ids__c != null) || 
                (isUpdate && OracleSyncUtil.isChanged(oldCase, c, new List<String>{'Oracle_Attachment_Ids__c'} ) 
                    && String.isNotEmpty(c.Oracle_Attachment_Ids__c))) 
            {
                caseIdsWithAttachmentIds.put(c.Id, getChangedValue(oldCase, c));
            }
        }


        Map<Id, Case> recordsToSync = new Map<Id, Case>();

        Boolean apiUser = OracleSyncUtil.isAPIUser();        
        //check if case created/updated by api user & no change to attachments
        if (caseIdsWithAttachmentIds.isEmpty() && apiUser) {
            System.debug('Case created by Integration User...return.');
            return;
        }

        for (Case c : newCases.values()) {
            //if need to integrate
            if (! OracleCaseSync.integrateWithOracle(c, rtId)) continue;

            //check if fields changed
            Case oldCase = (isUpdate) ? oldCases.get(c.Id) : null;
            if (isUpdate && (! OracleSyncUtil.isChanged(oldCase, c, OracleSyncConstants.CASE_FIELD_NAMES))) {
                continue;
            }

            recordsToSync.put(c.Id, c);

        }


        System.debug('recordsToSync = ' + recordsToSync);
        syncWithOracle(recordsToSync, isUpdate);

        if (! caseIdsWithAttachmentIds.isEmpty()) {
            OracleAttachmentSync.download(caseIdsWithAttachmentIds);
        }

    }

    private void syncWithOracle(Map<Id, Case> cases, Boolean isUpdate) {

        Map<Id, Case> temp = new Map<Id, Case>();
        Map<Id, Case> recordsToSync = new Map<Id, Case>();
        Integer batchSize = 50;

        for (Case c : cases.values()) {
            recordsToSync.put(c.Id, c);
            if (recordsToSync.size() == batchSize) { 
                temp.clear();
                temp.putAll(recordsToSync);
                OracleCaseSync.sync(temp, isUpdate);
                recordsToSync.clear();
            }

        }

        if ( ! recordsToSync.isEmpty()) {
            OracleCaseSync.sync(recordsToSync, isUpdate);
        }
    } 

    private String getChangedValue(Case oldCase, Case newCase) {

        String oldAttachmentIds = (oldCase == null || oldCase.Oracle_Attachment_Ids__c == null) ? '' : oldCase.Oracle_Attachment_Ids__c.trim();
        String newAttachmentIds = newCase.Oracle_Attachment_Ids__c.trim();

        String changedValue = newAttachmentIds.substring(newAttachmentIds.indexOf(oldAttachmentIds) 
            + oldAttachmentIds.length());

        if(changedValue.startsWith(',')) {
            changedValue = changedValue.substring(1);
        }
        System.debug('changedValue = ' + changedValue);
        return changedValue;
    }

}