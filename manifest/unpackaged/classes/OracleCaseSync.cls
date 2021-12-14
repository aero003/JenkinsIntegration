public with sharing class OracleCaseSync {
	

    public static Boolean integrateWithOracle(Case c, Id rtId) {
        return (c.Integrate_With_Oracle__c && rtId == c.RecordTypeId);
    }  

    public static void sync(Map<Id, Case> cases, Boolean isUpdate) {
        if (System.isBatch() || System.isFuture()) {
            OracleCaseSync.syncWithOracle(cases.values(), isUpdate);
        } else {
            OracleCaseSync.syncWithOracleFuture(new List<Id>(cases.keySet()), isUpdate);
        }
    } 


    @future(callout=true)
    public static void syncWithOracleFuture(List<Id> caseIds, Boolean isUpdate) {
        syncWithOracle(caseIds, isUpdate);
    }
    
    public static void syncWithOracle(List<Id> caseIds, Boolean isUpdate) {
        List<Case> cases = OracleSyncDAO.getCases(caseIds);
        syncWithOracle(cases, isUpdate);
    }

    public static void syncWithOracle(List<Case> cases, Boolean isUpdate) {
        System.debug('OracleCaseSync.syncWithOracle(): isUpdate = ' + isUpdate);
    	List<Case> updatedCases = new List<Case>();
    	List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

        Map<Id, EmailMessage> messagesWithAttachments = new Map<Id, EmailMessage>();
        Set<Id> caseIds = new Set<Id>();
        Set<Id> caseIdsForAttachment = new Set<Id>();
        
        Map<Id, List<EmailMessage>> emailMessages = (isUpdate) ? new Map<Id, List<EmailMessage>>() : OracleSyncDAO.getMessagesFromCases(cases);

    	for (Case c : cases) {
        	OracleIncident oIncident = createOracleIncident(c);
            
            //if insert add messages to Incident
            List<OracleThread> threads = new List<OracleThread>();
            if (c.Oracle_Service_Cloud_ID__c == null) {
                List<EmailMessage> messages = emailMessages.containsKey(c.Id) ? emailMessages.get(c.Id) : new List<EmailMessage>();
                for (EmailMessage em : messages) {
                    threads.add(OracleEmailMessageSync.createOracleThread(em, c));
                    if (em.HasAttachment) {
                        messagesWithAttachments.put(em.Id, em);
                        caseIds.add(c.Id);
                    }

                }
            }
            oIncident.threads = threads;

            //create request
	        HttpRequest req = null;
	        if (c.Oracle_Service_Cloud_ID__c != null) {
	        	req = OracleService.createHttpRequest('/incidents/' + c.Oracle_Service_Cloud_ID__c , 'POST');
	        	req.setHeader('X-HTTP-Method-Override','PATCH');
	        	//+ '?_HttpMethod=PATCH'
	        } else {
	        	req = OracleService.createHttpRequest('/incidents', 'POST');
                //add cases getting synced to this set
                caseIdsForAttachment.add(c.Id);
	        }
	        req.setHeader('prefer',	'exclude-null-properties');
	        req.setBody(JSON.serializePretty(oIncident));

            Case updatedCase = new Case(Id = c.Id);
            updatedCases.add(updatedCase);

	        try {
	        	String response = OracleService.send(req);
	        	System.debug('response = ' + response);

                updatedCase.Synced_With_Oracle__c = true;

	        	if (c.Oracle_Service_Cloud_ID__c == null) {
		        	Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response);
		        	Integer id = m.get('id') == null ? null : (Integer) m.get('id');
                    updatedCase.Oracle_Service_Cloud_ID__c = String.valueOf(id);
	        	}

	        } catch(OracleService.OracleException e) {
                updatedCase.Synced_With_Oracle__c = false;
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', c.id));
	        } catch(Exception e) {
                updatedCase.Synced_With_Oracle__c = false;
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Case__c', c.id));
	        }

    	}

        if (! messagesWithAttachments.isEmpty()) {
            List<Attachment> attachments = OracleSyncDAO.getAttachmentsFromEmails(messagesWithAttachments);
            Map<Id, Case> m = new Map<Id, Case>(OracleSyncDAO.getBasicCaseInfo(caseIds));
            OracleAttachmentSync.syncAttachmentOnEmailsWithOracle(attachments, messagesWithAttachments, m);
        }

        //check if cases have attachments
        if (! caseIdsForAttachment.isEmpty()) {
            List<Attachment> attachments = OracleSyncDAO.getAttachmentsFromCases(caseIdsForAttachment);
            if ( ! attachments.isEmpty()) {
                Map<Id, Case> m = new Map<Id, Case>(OracleSyncDAO.getBasicCaseInfo(caseIdsForAttachment));
                OracleAttachmentSync.syncWithOracle(attachments, m);

            }
        }

        if (!errors.isEmpty()) {
            insert errors;
        }



    	if (!updatedCases.isEmpty()) {
    		update updatedCases;
    	}

    }

    public static OracleIncident createOracleIncident(Case caze) {

    	OracleIncident oIncident = new OracleIncident();

    	//customFields
    	OracleIncident.c x = new OracleIncident.c();
    	x.reason = caze.Reason;
    	x.salesforce_id = caze.Id;
    	x.account_id = caze.AccountId;
    	x.salesforce_contact_id = caze.ContactId;
        x.record_type_id = caze.RecordTypeId;
    	x.record_type_name = caze.RecordType.Name;
    	x.salesforce_case_created = caze.CreatedDate;
    	x.origin = caze.Origin;
    	x.priority = caze.Priority;
    	x.salesforce_status = caze.Status;
    	x.salesforce_description = caze.Description;
        x.case_number = caze.CaseNumber;

    	OracleIncident.CustomFields customFields = new OracleIncident.CustomFields();
    	customFields.c = x;
    	oIncident.customFields = customFields;

    	//org
    	OracleIncident.Organization org = new OracleIncident.Organization();
    	org.id = Integer.valueOf(caze.Account.Oracle_Service_Cloud_ID__c);

    	oIncident.organization = org;

        oIncident.subject = caze.subject;

    	//contact
    	OracleIncident.CreatedByAccount primaryContact = new OracleIncident.CreatedByAccount();
    	primaryContact.id = Integer.valueOf(caze.Contact.Oracle_Service_Cloud_ID__c);
    	oIncident.primaryContact = primaryContact;

    	//oIncident.product = caze.Product__c;



    	return oIncident;
    }
}